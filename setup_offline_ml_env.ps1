Here is the **Windows PowerShell version** of your Universal Offline ML Environment Setup Script:

### 📂 **Step 1: Save the Script**
- Open Notepad and paste the following script:
```powershell
# Universal Offline ML Environment Setup Script (PowerShell for Windows)

# Step 1: Create requirements.txt from provided pip commands
$pipCommands = Read-Host "Enter pip install commands (e.g., numpy pandas)"
$pipCommands -split ' ' | ForEach-Object { $_ } | Set-Content -Path requirements.txt
Write-Output "[1/5] Created requirements.txt from input"

# Step 2: Download all packages for offline use
New-Item -ItemType Directory -Force -Path .\pip_packages | Out-Null
pip download -r requirements.txt -d .\pip_packages
Write-Output "[2/5] Downloaded all packages into .\pip_packages"

# Step 3: Create Dockerfile for Offline Setup
@"
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt ./
COPY pip_packages/ ./pip_packages/
RUN pip install --no-index --find-links=./pip_packages -r requirements.txt
CMD ["python3"]
"@ | Set-Content -Path Dockerfile
Write-Output "[3/5] Created Dockerfile with offline package installation"

# Step 4: Build Docker Image and Package for Sharing
docker build -t offline_ml_env .
docker save offline_ml_env | gzip > offline_ml_env.tar.gz
Compress-Archive -Path Dockerfile, requirements.txt, .\pip_packages, offline_ml_env.tar.gz -DestinationPath offline_ml_env_package.zip
Write-Output "[4/5] Packaged Docker image and dependencies into 'offline_ml_env_package.zip'"

# Step 5: Create Installation Script for Target Device
@"
@echo off
echo Extracting package...
powershell -Command "Expand-Archive -Path offline_ml_env_package.zip -DestinationPath ."
echo Loading Docker image...
docker load < offline_ml_env.tar.gz
echo Running container...
docker run -it --name ml_container offline_ml_env
pause
"@ | Set-Content -Path install_offline_ml_env.bat
Write-Output "[5/5] Created 'install_offline_ml_env.bat' for quick setup on other devices"

Write-Output "✅ Setup complete! Share 'offline_ml_env_package.zip' and 'install_offline_ml_env.bat' via USB to other devices. No internet required for installation."
```

---

### 💻 **Step 2: Save the Script as** `setup_offline_ml_env.ps1`  
- Save the file as **`setup_offline_ml_env.ps1`** in your desired directory.

---

### 🚀 **Step 3: Run the Script in PowerShell**
1. **Open PowerShell as Administrator.**  
2. **Enable PowerShell Scripts (if not already enabled):**
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope Process
   ```
3. **Run the script:**
   ```powershell
   .\setup_offline_ml_env.ps1
   ```
---

### 💾 **Step 4: Transfer to Another Device**
- Transfer:
  - `offline_ml_env_package.zip`  
  - `install_offline_ml_env.bat`  
to the target device via USB.

---

### 🛠️ **Step 5: Install on Target Device (Offline)**
1. **Copy Files** from USB to any folder.  
2. **Run** `install_offline_ml_env.bat` (Double-click it).

---

### ✅ **Done!**
- A Docker container named `ml_container` will start with your ML environment.  
- To restart later:
  ```cmd
  docker start -ai ml_container
  ```
---
Would you like me to further optimize this script or explain any part of it? 😊🚀
