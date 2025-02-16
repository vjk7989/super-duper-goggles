#!/bin/bash
# Step 1: Create requirements.txt
cat <<EOL > requirements.txt
numpy
pandas
scikit-learn
tensorflow
torch
matplotlib
seaborn
EOL

echo "[1/4] Created requirements.txt"

# Step 2: Download packages
mkdir -p /opt/pip_packages
pip download -r requirements.txt -d /opt/pip_packages
echo "[2/4] Downloaded packages to /opt/pip_packages"

# Step 3: Install packages locally
pip install --no-index --find-links=/opt/pip_packages -r requirements.txt
echo "[3/4] Installed packages from local directory"

# Step 4: (Optional) Start local PyPI server
read -p "Do you want to start a local PyPI server for LAN? (y/n): " start_server
if [ "$start_server" == "y" ]; then
    pip install pypiserver
    pypi-server run -p 8080 /opt/pip_packages &
    echo "[4/4] Local PyPI server running at http://$(hostname -I | awk '{print $1}'):8080"
else
    echo "[4/4] Skipped local PyPI server setup."
fi

echo "Setup complete!"
