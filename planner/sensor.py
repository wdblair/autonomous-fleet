def main(ip, port):
    # Inputs: ip = IP address (or hostname) of server. Always as a string
    #         port = Port (int) of UDP broadcasting
    import socket

    #Set the port to listen on
    UDP_IP = ip # "localhost"
    UDP_PORT = port #25000

    #listen for info
    sock = socket.socket(socket.AF_INET, # Internet
                         socket.SOCK_DGRAM) # UDP
    sock.bind((UDP_IP, UDP_PORT))


    #get the next round of data
    data, addr = sock.recvfrom(2048) # get at most 1024 bytes

    #data has the following string format
    #"%f\t%f\t%f\t%f"
    print data

if __name__ == '__main__':
    import sys
    main(sys.argv[1],int(sys.argv[2]))