To run and use the script, follow these steps:

1. Save the Script
If you haven't already, save the script as setup_ml_env.sh:
bash
Copy
Edit
nano setup_ml_env.sh
Paste the script inside, then save and exit (CTRL+X, then Y, then Enter).
2. Make the Script Executable
bash
Copy
Edit
chmod +x setup_ml_env.sh
3. Run the Script
bash
Copy
Edit
./setup_ml_env.sh
It will:
Create requirements.txt
Download packages to /opt/pip_packages
Install packages locally
Optionally, start a local PyPI server (if you choose y when prompted)
4. Use Local PyPI Server (Optional)
If you chose to start the PyPI server, use it on other LAN devices with this command:

bash
Copy
Edit
pip install --index-url http://<server-ip>:8080/simple/ -r requirements.txt
Replace <server-ip> with your server’s local IP (shown in the script output).
