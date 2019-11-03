#!/usr/bin/python3
import socket
import sys

host = '127.0.0.1'
port = 41370

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)


# Connect the socket to the port where the server is listening
server_address = (host, port)
print('connecting to {} port {}'.format(*server_address))
sock.connect(server_address)

try:
    # Send data
    message = b'This is the message.  It will be repeated.'
    print('*** sending {!r}'.format(message))
    sock.sendall(message)

    # Look for the response
    amount_received = 0
    amount_expected = len(message)

    while amount_received < amount_expected:
        data = sock.recv(16)
        amount_received += len(data)
        print('*** received {!r}'.format(data))

finally:
    print('closing socket')
    sock.close()


