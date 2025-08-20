# 🚀 Setup Guide: Docker + Networking + Home Assistant  

This guide explains how to install Docker, configure networking (Ethernet + Wi-Fi), and run **Home Assistant** on three different environments:  

1. **Ubuntu Laptop**  
2. **Raspberry Pi (RPI)**  
3. **Proxmox Server with VM**  

---

## 1️⃣ Ubuntu Laptop  

### Install Docker  
```bash
# Update and install prerequisites
sudo apt update && sudo apt upgrade -y
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repo
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Verify
docker --version
```

### Add User to Docker Group  
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Run Home Assistant in Docker  
```bash
docker run -d   --name homeassistant   --restart unless-stopped   --privileged   --network=host   -v ~/homeassistant:/config   ghcr.io/home-assistant/home-assistant:stable
```
### Simple Run the start case in the homeassistant.sh file
```bash
./homeassistant.sh run
```

Access at: `http://localhost:8123` or `<pc_inet_address>:8123`

---

## 2️⃣ Raspberry Pi (RPI)  
### Getting started
1. Ensure that an ubuntu os is the base os of the rpi. You can use a rpi imager to do this.
2. Get the IP of the rpi, either by connecting to a screen or connecting through an eth cable to a LAN and checking the IP Address from the WiFi.


### Install Docker  
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker using convenience script
curl -fsSL https://get.docker.com | sh

# Add user to Docker group
sudo usermod -aG docker $USER
newgrp docker

# Verify
docker --version
```

### Configure Wi-Fi (Netplan)  

Edit Netplan config (usually `/etc/netplan/50-cloud-init.yaml`):  
```yaml
network:
  version: 2
  ethernets:
    eth0:
      optional: true
      dhcp4: true
  wifis:
    wlan0:
      optional: true
      dhcp4: true
      access-points:
        "<your_wifi_name>":
          password: "<your_wifi_password>"
        "<your_wifi_name>":
          password: "<your_wifi_password>"
```

Apply:  
```bash
sudo netplan apply
```

Check:  
```bash
ip addr show wlan0
```

### Run Home Assistant in Docker  
```bash
docker run -d   --name homeassistant   --restart unless-stopped   --privileged   --network=host   -v /home/pi/homeassistant:/config   ghcr.io/home-assistant/home-assistant:stable
```

### Simple Run the start case in the homeassistant.sh file
```bash
./homeassistant.sh run
```

Access at: `http://<raspberrypi-ip>:8123` or `homeassistant:8123`

---

## 3️⃣ Proxmox Server with VM  

### VM Setup  
- Use **Ubuntu Server** as VM OS.  
- Configure **Bridged networking** so the VM gets its own LAN IP.  

### Install Docker (inside VM)  
Follow the same steps as **Ubuntu Laptop** above.  

### Configure Networking (Optional Static IP)  

Edit `/etc/netplan/50-cloud-init.yaml`:  
```yaml
network:
  version: 2
  ethernets:
    ens18:
      dhcp4: no
      addresses: [192.168.1.150/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]
```

Apply:  
```bash
sudo netplan apply
```

Check:  
```bash
ip addr show ens18
```

### Run Home Assistant in Docker  
```bash
docker run -d   --name homeassistant   --restart unless-stopped   --privileged   --network=host   -v ~/homeassistant:/config   ghcr.io/home-assistant/home-assistant:stable
```

Access at: `http://<vm-ip>:8123`

---

## ✅ Verification Checklist  

- **Docker test**:  
```bash
docker run hello-world
```

- **Check IP addresses**:  
```bash
ip addr
```

- **Access Home Assistant**:  
  - Ubuntu Laptop → `http://localhost:8123`  
  - Raspberry Pi → `http://<raspberrypi-ip>:8123`  
  - Proxmox VM → `http://<vm-ip>:8123`  