#!/usr/bin/env python3
import sys
from socket import *
import threading
import select
import time
import re


def createOutboundSocket(fakeIP, serverIP):
    outboundSocket = socket(AF_INET, SOCK_STREAM)
    outboundSocket.bind((fakeIP, 0))
    outboundSocket.connect((serverIP, 8080))
    return outboundSocket


def readHTTP(socket):
    message = b''
    contLen = 0
    contLenRE = re.compile(b'\s+Content-Length:\s[0-9]+\s+')
    numRE = re.compile(b'[0-9]+')
    crlfRE = re.compile(b'\\r\\n\\r\\n')
    crlfMatch = None
    while(1):
        data = socket.recv(2048)
        if(len(data) == 0):
            socket.close()
            return None

        message += data

        contLenMatch = contLenRE.search(message)
        if(contLenMatch):
            numMatch = numRE.search(contLenMatch.group(0))
            contLen = int(numMatch.group(0).decode('utf-8'))

        # read (potential) body and return
        crlfMatch = crlfRE.search(message)
        if(crlfMatch):
            contentLeft = contLen - (len(message) - crlfMatch.end())
            while(contentLeft > 0):
                # print(contentLeft)
                data = socket.recv(2048)
                contentLeft -= len(data)
                message += data
            return([message, contLen])


bitrateMap = None  # Maps labels to actual bitrates
# numChunks = 103
# So we don't do extra work

# Throughput
currentTP = 0
currentBitrate = -1

# lastTime = None


def modifyChunk(clientMessage):
    global currentBitrate

    chunkRE = re.compile(b'[0-9]+Seg[0-9]+-Frag[0-9]+')
    chunkRequest = chunkRE.search(clientMessage)
    if(chunkRequest == None):
        return clientMessage

    startIdx = chunkRequest.start()
    numRE = re.compile(b'[0-9]+')
    num = numRE.search(clientMessage[startIdx:])
    newClientMessage = clientMessage.replace(
        num.group(0), str(currentBitrate).encode('utf-8'))

    return newClientMessage


def checkForSWF(clientMessage, serverMessage):
    global numChunks
    swfRE = re.compile(b'GET\s/StrobeMediaPlayback.swf')
    if(swfRE.search(clientMessage) == None):
        return
    crlfRE = re.compile(b'\\r\\n\\r\\n')
    crlf = crlfRE.search(serverMessage)

    # TODO: Figure out number of chunks from swf object. For now, we hardcode it

    numChunks = 103


def checkForManifest(clientMessage, serverMessage, contLen, fakeIP, serverIP):
    manifestRE = re.compile(b'big_buck_bunny.f4m')
    if(manifestRE.search(clientMessage) == None):
        return [serverMessage, contLen]
    global bitrateMap
    bitrateRE = re.compile(b'bitrate="[a-zA-Z0-9]+"\s+')
    intRE = re.compile(b'[0-9]+')
    bitrateRaw = bitrateRE.findall(serverMessage)

    bitrates = []

    for item in bitrateRaw:
        bitrate = int(intRE.search(item).group(0).decode('utf-8'))
        bitrates.append(bitrate)

    bitrates.sort()
    minBitrate = bitrates[0]
    ### HARD CODING ACTUAL BITRATES, MAPPING TO BITRATES IN MANIFEST ###
    # Duration = 596.50133333333338 seconds, 5.84805228758 s per chunk
    # numChunks = 102
    # 10: total bytes = 17601811 Bytes, 140814.488 kb,  236.067348271 kb/s
    # 100: total bytes = 24340946 Bytes, 194727.568 kb,326.449510032 kb/s
    # 500: total bytes = 54448551 (102 chunks), 435588.408 kb, 730.238783484 kb/s
    # 1000: total bytes = 92,647,320, 741,178.56 kb, 1242.54300633 kb/s
    actualBitrates = [236.067348271, 326.449510032,
                      730.238783484, 1242.54300633]

    bitrateMap = {}

    for idx, rate in enumerate(bitrates):
        bitrateMap[rate] = actualBitrates[idx]

    global currentBitrate
    currentBitrate = minBitrate

    newRequest = clientMessage.replace(
        b'big_buck_bunny.f4m', b'big_buck_bunny_nolist.f4m')

    outboundSocket = createOutboundSocket(fakeIP, serverIP)
    outboundSocket.sendall(newRequest)
    newServerResponse = readHTTP(outboundSocket)
    outboundSocket.close()

    return newServerResponse


def measureThroughput(clientMessage, ts, tf, contLen, alpha):
    global currentTP
    global bitrateMap
    chunkRE = re.compile(b'/vod/[0-9]+Seg[0-9]+-Frag[0-9]+')
    chunkRequest = chunkRE.search(clientMessage)
    if(chunkRequest == None):
        return [None, None]

    kbit_length = float(contLen)*8.0/1000.0
    newTP = kbit_length/(tf-ts)
    currentTP = alpha*newTP + (1-alpha)*currentTP
    return newTP, currentTP


def modifyBitrate():
    global bitrateMap
    global currentTP
    global currentBitrate

    # haven't read manifest yet
    if(bitrateMap == None):
        return [None, None]

    for key, val in bitrateMap.items():
        if(currentTP - val*1.5 >= 0):
            currentBitrate = key
    minKey = min(bitrateMap, key=bitrateMap.get)
    if currentTP < bitrateMap[minKey]:
        currentBitrate = minKey

    #### HARD CODING THE BITRATE HERE #####
    return [currentBitrate, bitrateMap[currentBitrate]]


def newClientSocket(clientSocket, addr, log, alpha, fakeIP, serverIP, logTimeStart):
    global currentBitrate
    global lastTime
    # ts = time.time()

    # if(lastTime == None):
    lastTime = logTimeStart
    try:
        outboundSocket = createOutboundSocket(fakeIP, serverIP)
    except error:
        print('Apache server not active, please run it')
        clientSocket.close()
        return
    print('started outbound socket')

    while(1):
        clientResponse = readHTTP(clientSocket)

        if clientResponse == None:
            print('Client closed socket, closing outbound socket')
            outboundSocket.close()
            return

        clientMessage = clientResponse[0]
        # print(clientMessage)

        #### MODIFY CLIENT MESSAGE HERE ###
        clientMessage = modifyChunk(clientMessage)

        try:
            outboundSocket.sendall(clientMessage)
        except error:
            print('Outbound closed socket, closing client socket')
            clientSocket.close()
            return

        serverTime = time.time()
        serverResponse = readHTTP(outboundSocket)
        serverTime = time.time() - serverTime

        # print(serverResponse)
        if serverResponse == None:
            print('Outbound closed socket, closing client socket')
            clientSocket.close()
            return

        serverMessage, contLen = serverResponse
        tf = time.time()
        ts = lastTime
        lastTime = tf
        ### CHECK FOR MANIFEST HERE ###
        serverMessage, contLen = checkForManifest(
            clientMessage, serverMessage, contLen, fakeIP, serverIP)

        ### MEASURE THROUGHPUT AND CHANGE BITRATE HERE (only if we've seen the manifest) ###
        newTP, currentTP = measureThroughput(
            clientMessage, ts, tf, contLen, alpha)
        currentBitrate, actualBitrate = modifyBitrate()

        writeLog(log, clientMessage, serverTime, newTP, currentTP,
                 actualBitrate, serverIP, currentBitrate)
        try:
            clientSocket.sendall(serverMessage)
        except error:
            print('Client closed socket, closing outbound socket 2')
            outboundSocket.close()
            return


def writeLog(log, clientMessage, serverTime, newTP, currentTP, actualBitrate, serverIP, currentBitrate):
    chunkRE = re.compile(b'/vod/[0-9]+Seg[0-9]+-Frag[0-9]+')
    chunkRequest = chunkRE.search(clientMessage)
    if(chunkRequest == None):
        return
    chunkRequest = chunkRequest.group(0)

    epoch = int(time.time())
    print('\n')
    print('Epoch: ', epoch)
    print('ServerTime: ', serverTime)
    print('New Throughput: ', newTP)
    print('Average Throughput: ', currentTP)
    print('Bitrate (actual): ', actualBitrate)
    print('ServerIP: ', serverIP)
    print('Request ', chunkRequest)
    f = open(log, 'a')
    f.write(str(epoch) + ' ' + str(serverTime) + ' ' + str(int(newTP)) + ' ' + str(float(int(currentTP))) + ' ' +
            str(int(actualBitrate)) + ' ' + serverIP + ' ' + chunkRequest.decode('utf-8') + '\n')
    f.close()


if __name__ == '__main__':
    if(len(sys.argv) != 6):
        print(
            'error: run with ./proxy <log> <alpha> <listen-port> <fake-ip> <web-server-ip>')
        sys.exit()

    log = sys.argv[1]
    alpha = float(sys.argv[2])
    listenPort = int(sys.argv[3])
    fakeIP = sys.argv[4]
    serverIP = sys.argv[5]
    open(log, 'w').close()

    # create listening socket using IPV4 and TCP
    serverSocket = socket(AF_INET, SOCK_STREAM)
    serverSocket.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
    serverSocket.bind(('', listenPort))
    serverSocket.listen(5)
    while(True):
        clientSocket, addr = serverSocket.accept()
        print('client with {address} accepted'.format(address=addr))
        logTimeStart = time.time()
        newThread = threading.Thread(
            target=newClientSocket, args=(clientSocket, addr, log, alpha, fakeIP, serverIP, logTimeStart), daemon=True)
        newThread.start()
