def main(ip, port, mode, heading, altitude):
    # Inputs: ip = IP address (or hostname) of server. Always as a string
    #         port = Port (int) of UDP broadcasting
    import socket

    #Set the port to listen on
    UDP_IP = ip # "localhost"
    UDP_PORT = port #25000

    #send for info
    sock = socket.socket(socket.AF_INET,
                         socket.SOCK_DGRAM)

    tuple = mode + "\t" + str(heading) + "\t" + str(altitude) + "\n"
    print(tuple)
    sock.sendto(tuple, (UDP_IP, UDP_PORT))

if __name__ == '__main__':
    import sys
    main(sys.argv[1], int(sys.argv[2]), sys.argv[3], sys.argv[4], int(sys.argv[5]))
