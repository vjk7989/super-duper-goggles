# Universal Offline ML Environment Setup Script

# Step 1: Create requirements.txt from provided pip commands
read -p "Enter pip install commands (e.g., numpy pandas): " pip_commands
echo "$pip_commands" | tr ' ' '\n' > requirements.txt
echo "[1/5] Created requirements.txt from input"

# Step 2: Download all packages for offline use
mkdir -p ./pip_packages
pip download -r requirements.txt -d ./pip_packages
echo "[2/5] Downloaded all packages into ./pip_packages"

# Step 3: Create Dockerfile for Offline Setup
cat <<EOL > Dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt ./
COPY pip_packages/ ./pip_packages/
RUN pip install --no-index --find-links=./pip_packages -r requirements.txt
CMD ["python3"]
EOL
echo "[3/5] Created Dockerfile with offline package installation"

# Step 4: Build Docker Image and Package for Sharing
docker build -t offline_ml_env .
docker save offline_ml_env | gzip > offline_ml_env.tar.gz
tar -czvf offline_ml_env_package.zip Dockerfile requirements.txt pip_packages offline_ml_env.tar.gz
echo "[4/5] Packaged Docker image and dependencies into 'offline_ml_env_package.zip'"

# Step 5: Create Installation Script for Target Device
cat <<EOL > install_offline_ml_env.sh
#!/bin/bash
echo "Extracting package..."
unzip offline_ml_env_package.zip
echo "Loading Docker image..."
docker load < offline_ml_env.tar.gz
echo "Running container..."
docker run -it --name ml_container offline_ml_env
EOL
chmod +x install_offline_ml_env.sh
echo "[5/5] Created 'install_offline_ml_env.sh' for quick setup on other devices"

echo "Setup complete! Share 'offline_ml_env_package.zip' and 'install_offline_ml_env.sh' via USB to other devices. No internet required for installation."
