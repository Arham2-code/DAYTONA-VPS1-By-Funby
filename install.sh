#!/bin/bash

# Clear terminal for clean dashboard view
clear

# ==========================================
# 🌟 PREMIUM COLOR CODES & FX
# ==========================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# FUNCTION: TYPING EFFECT ANIMATION
type_effect() {
    local text="$1"
    local delay="$2"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

# FUNCTION: LOADING BAR ANIMATION
loading_bar() {
    local title="$1"
    echo -ne "${YELLOW}⏳ $title ${NC}[          ]"
    sleep 0.2
    echo -ne "\b\b\b\b\b\b\b\b\b\b\b[===       ]"
    sleep 0.2
    echo -ne "\b\b\b\b\b\b\b\b\b\b\b[======    ]"
    sleep 0.2
    echo -ne "\b\b\b\b\b\b\b\b\b\b\b[========= ]"
    sleep 0.2
    echo -ne "\b\b\b\b\b\b\b\b\b\b\b[==========]"
    echo -e " ${GREEN}DONE!${NC}"
}

# AUTOMATED ROOT/SUDO PRIVILEGE CHECK
if [ "$(id -u)" -eq 0 ]; then
    SUDO_CMD=""
else
    SUDO_CMD="sudo"
fi

# ==========================================
# MAIN INTERACTIVE LIST MENU
# ==========================================
show_menu() {
    clear
    echo -e "${RED}==========================================================${NC}"
    echo -e "${WHITE}          [👹 DXD LABS PREMIUM VPS DASHBOARD 👹]          ${NC}"
    echo -e "${RED}==========================================================${NC}"
    echo -e "${WHITE}                 ┌─────────────────────────┐               ${NC}"
    echo -e "${WHITE}                 │   ${RED}█▀▀█ █──█ █▄─▄█ █▀▀█${WHITE}  │  <[SUKUNA V2] ${NC}"
    echo -e "${WHITE}                 │   ${RED}█▄▄█ █▄▄█ █ █ █ █▄▄█${WHITE}  │               ${NC}"
    echo -e "${WHITE}                 └─────────────────────────┘               ${NC}"
    echo -e "${PURPLE}                    (█)─(█)     (█)─(█)                    ${NC}"
    echo -e "${PURPLE}                   █████████   █████████                   ${NC}"
    echo -e "${RED}                  ███████████████████████                  ${NC}"
    echo -e "${RED}==========================================================${NC}"
    echo -e "${CYAN}  ____  _____ _   _ ____     ____    _    __  __ ___ _   _  ____ ${NC}"
    echo -e "${CYAN} |  _ \| ____| | | |  _ \   / ___|  / \  |  \/  |_ _| \ | |/ ___|${NC}"
    echo -e "${CYAN} | | | |  _| | | | | |_) | | |  _  / _ \ | |\/| || ||  \| | |  _ ${NC}"
    echo -e "${CYAN} | |_| | |___| |_| |  __/  | |_| |/ ___ \| |  | || || |\  | |_| |${NC}"
    echo -e "${CYAN} |____/|_____|\___/|_|      \____/_/   \_\_|  |_|___|_| \_|\____|${NC}"
    echo -e "${RED}==========================================================${NC}"
    echo ""
    echo -e "${YELLOW}👉 SELECT AN OPTION TO PROCEED FROM LIST:${NC}"
    echo ""
    echo -e "  ${CYAN}[1]${NC} Create & Boot New Ubuntu VPS Instance"
    echo -e "  ${CYAN}[2]${NC} Restart Existing VPS Instance"
    echo -e "  ${CYAN}[3]${NC} Modify TCP Port Forward Rules (Default: 2222)"
    echo -e "  ${CYAN}[4]${NC} Remove/Clean VPS Cache Files"
    echo -e "  ${CYAN}[5]${NC} Exit Dashboard"
    echo ""
    echo -e "${RED}==========================================================${NC}"
    echo -ne "${WHITE}🔹 Enter Choice [1-5]: ${NC}"
    read -r CHOICE
    
    case $CHOICE in
        1) create_vps ;;
        2) restart_vps ;;
        3) configure_tcp ;;
        4) clean_vps ;;
        5) exit 0 ;;
        *) echo -e "${RED}❌ Invalid Choice! Please select 1-5.${NC}"; sleep 2; show_menu ;;
    esac
}

# STEP 1: CONFIGURE STORAGE & DOWNLOAD CLOUD ARCHITECTURE
create_vps() {
    clear
    echo -e "${RED}==========================================================${NC}"
    echo -e "${WHITE}⚙️  CONFIGURE YOUR VIRTUAL MACHINE SPECIFICATIONS${NC}"
    echo -e "${RED}==========================================================${NC}"
    echo ""
    
    echo -ne "${BLUE}🔹 Enter RAM Size in GB (Default: 4): ${NC}"
    read -r RAM_INPUT
    RAM_GB=${RAM_INPUT:-4}

    echo -ne "${BLUE}🔹 Enter CPU Cores (Default: 2): ${NC}"
    read -r CPU_INPUT
    CPU_CORES=${CPU_INPUT:-2}

    echo -ne "${BLUE}🔹 Enter Disk Space to ADD in GB (Default: 10): ${NC}"
    read -r DISK_INPUT
    DISK_ADD=${DISK_INPUT:-10}

    echo -ne "${BLUE}🔹 Create Username (Default: ubuntu): ${NC}"
    read -r USER_NAME
    USER_NAME=${USER_NAME:-ubuntu}

    echo -ne "${BLUE}🔹 Create Password (Default: 1234): ${NC}"
    read -r USER_PASS
    USER_PASS=${USER_PASS:-1234}
    
    TCP_HOST_PORT=${TCP_HOST_PORT:-2222}
    TCP_GUEST_PORT=22

    echo ""
    echo -e "${YELLOW}⏳ Background dependencies verifying... Please wait.${NC}"
    echo ""
    
    $SUDO_CMD apt-get update -y > /dev/null 2>&1
    $SUDO_CMD apt-get install -y qemu-system-x86 qemu-utils wget cloud-image-utils genisoimage curl > /dev/null 2>&1
    
    $SUDO_CMD mkdir -p /home/daytona > /dev/null 2>&1
    $SUDO_CMD chmod 777 /home/daytona > /dev/null 2>&1
    
    FRESH_IMAGE=false
    if [ ! -f "/home/daytona/ubuntu24.qcow2" ]; then
        echo -e "${YELLOW}📥 Downloading Ubuntu 24.04 Cloud Image to /home/daytona/...${NC}"
        $SUDO_CMD wget -q --show-progress https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img -O /home/daytona/ubuntu24.qcow2
        $SUDO_CMD chmod 666 /home/daytona/ubuntu24.qcow2
        FRESH_IMAGE=true
    else
        echo -e "${GREEN}✅ Existing Ubuntu Image Cache Detected at /home/daytona/.${NC}"
    fi
    
    loading_bar "Generating Cloud-Init Matrix"
    
    # Write persistent network layout fixes directly into cloud-config
    cat <<EOF > /home/daytona/user-data
#cloud-config
disable_root: false
ssh_pwauth: True
chpasswd:
  list: |
    ${USER_NAME}:${USER_PASS}
  expire: False
write_files:
  - path: /etc/systemd/system/vps-net-fix.service
    permissions: '0644'
    content: |
      [Unit]
      Description=VPS Persistent Network Fix Matrix
      After=network.target network-online.target systemd-resolved.service
      Before=rc-local.service
      
      [Service]
      Type=oneshot
      ExecStart=/bin/bash -c "sysctl -w net.ipv6.conf.all.disable_ipv6=1; sysctl -w net.ipv6.conf.default.disable_ipv6=1; sysctl -w net.ipv6.conf.lo.disable_ipv6=1; ip link set dev eth0 mtu 1400 || true; ip link set dev enp0s3 mtu 1400 || true; ip link set dev ens3 mtu 1400 || true; systemctl stop systemd-resolved || true; systemctl disable systemd-resolved || true; rm -f /etc/resolv.conf; echo 'nameserver 8.8.8.8' > /etc/resolv.conf; echo 'nameserver 8.8.4.4' >> /etc/resolv.conf"
      RemainAfterExit=yes
      
      [Install]
      WantedBy=multi-user.target
runcmd:
  - systemctl daemon-reload
  - systemctl enable vps-net-fix.service
  - systemctl start vps-net-fix.service
EOF
    touch /home/daytona/meta-data

    # 🛠️ FAILSAFE ISO COMPILER
    $SUDO_CMD rm -f /home/daytona/seed.img
    if command -v cloud-localds &> /dev/null; then
        $SUDO_CMD cloud-localds /home/daytona/seed.img /home/daytona/user-data /home/daytona/meta-data > /dev/null 2>&1
    elif command -v genisoimage &> /dev/null; then
        $SUDO_CMD genisoimage -output /home/daytona/seed.img -volid cidata -joliet -rock /home/daytona/user-data /home/daytona/meta-data > /dev/null 2>&1
    elif command -v mkisofs &> /dev/null; then
        $SUDO_CMD mkisofs -output /home/daytona/seed.img -volid cidata -joliet -rock /home/daytona/user-data /home/daytona/meta-data > /dev/null 2>&1
    fi
    
    $SUDO_CMD chmod 666 /home/daytona/seed.img > /dev/null 2>&1

    # ERROR DIAGNOSTIC VERIFICATION
    if [ ! -f "/home/daytona/seed.img" ]; then
        echo -e "${RED}❌ SYSTEM ERROR: Configuration block build failed (/home/daytona/seed.img missing).${NC}"
        echo -ne "${WHITE}Press Enter to return to menu... ${NC}"
        read -r
        show_menu
        return
    fi

    if [ "$FRESH_IMAGE" = true ]; then
        loading_bar "Expanding Server Hard Disk Allocation"
        $SUDO_CMD qemu-img resize /home/daytona/ubuntu24.qcow2 +${DISK_ADD}G > /dev/null 2>&1
    fi
    
    save_env
    boot_qemu
}

# STEP 2: NETWORK CONTROL MODIFIER
configure_tcp() {
    clear
    echo -e "${YELLOW}==========================================================${NC}"
    echo -e "${WHITE}🔄⚙️  MANAGE CUSTOM TCP PORT FORWARDING RULES ${NC}"
    echo -e "${YELLOW}==========================================================${NC}"
    echo ""
    if [ -f "/home/daytona/.vps_env" ]; then
        source /home/daytona/.vps_env
    fi
    echo -e "Current Target Host Port  : ${CYAN}${TCP_HOST_PORT:-2222}${NC}"
    echo -e "Current Guest VM Port     : ${CYAN}${TCP_GUEST_PORT:-22}${NC}"
    echo ""
    echo -ne "${BLUE}🔹 Enter NEW External Host Port (Default base: 2222): ${NC}"
    read -r NEW_HOST_PORT
    TCP_HOST_PORT=${NEW_HOST_PORT:-2222}
    
    echo -ne "${BLUE}🔹 Enter Internal Guest Port (Default SSH: 22): ${NC}"
    read -r NEW_GUEST_PORT
    TCP_GUEST_PORT=${NEW_GUEST_PORT:-22}
    
    save_env
    echo ""
    echo -e "${GREEN}✅ TCP Rule Updated Successfully!${NC}"
    sleep 2
    show_menu
}

save_env() {
    echo "RAM_GB=${RAM_GB:-4}" > /home/daytona/.vps_env
    echo "CPU_CORES=${CPU_CORES:-2}" >> /home/daytona/.vps_env
    echo "USER_NAME=${USER_NAME:-ubuntu}" >> /home/daytona/.vps_env
    echo "USER_PASS=${USER_PASS:-1234}" >> /home/daytona/.vps_env
    echo "TCP_HOST_PORT=${TCP_HOST_PORT:-2222}" >> /home/daytona/.vps_env
    echo "TCP_GUEST_PORT=${TCP_GUEST_PORT:-22}" >> /home/daytona/.vps_env
    chmod 666 /home/daytona/.vps_env > /dev/null 2>&1
}

# STEP 3: POPOUT LINK AND RUN THE MASTER EXECUTION COMMAND
boot_qemu() {
    if [ -f "/home/daytona/.vps_env" ]; then
        source /home/daytona/.vps_env
    fi

    TCP_HOST_PORT=${TCP_HOST_PORT:-2222}
    TCP_GUEST_PORT=${TCP_GUEST_PORT:-22}
    RAM_VALUE="${RAM_GB:-4}G"

    clear
    echo -e "${GREEN}==========================================================${NC}"
    type_effect "👹 DATA SYSTEM SYNCHRONIZED! PIPING TERMINAL CHANNELS..." 0.02
    echo -e "${GREEN}==========================================================${NC}"
    echo ""
    
    sshx_log=$(mktemp)
    curl -sSf https://sshx.io/get 2>/dev/null | sh -s run > "$sshx_log" 2>/dev/null &
    SSHX_PID=$!
    
    sleep 4
    SSHX_URL=$(grep -o 'https://sshx.io/s/[a-zA-Z0-9]*' "$sshx_log" | head -n 1)
    rm -f "$sshx_log"

    clear
    echo -e "${GREEN}==========================================================${NC}"
    echo -e "🎉        DEUP GAMING & DXD LABS - VM NETWORK ACTIVE        "
    echo -e "${GREEN}==========================================================${NC}"
    echo -e "${WHITE}👤 Username : ${CYAN}${USER_NAME:-ubuntu}${NC}"
    echo -e "${WHITE}🔑 Password : ${CYAN}${USER_PASS:-1234}${NC}"
    echo -e "${WHITE}⚙️  Resources: ${CYAN}${RAM_VALUE} RAM | ${CPU_CORES:-2} Cores${NC}"
    echo -e "${WHITE}🚀 Port Rule : ${YELLOW}Host Port ${TCP_HOST_PORT} -> VM Port ${TCP_GUEST_PORT}${NC}"
    echo -e "${RED}----------------------------------------------------------${NC}"
    if [ ! -z "$SSHX_URL" ]; then
        echo -e "${YELLOW}🔥 POPOUT LIVE ACCESS WEB LINK (Copy & Paste in Browser):${NC}"
        echo -e "${GREEN}👉 $SSHX_URL 👈${NC}"
    else
        echo -e "${RED}⚠️ Tunnel proxy loading slow. Direct local network port is listening.${NC}"
    fi
    echo -e "${RED}----------------------------------------------------------${NC}"
    echo -e "${WHITE}👉 Connection Command : ssh ${USER_NAME:-ubuntu}@localhost -p ${TCP_HOST_PORT}${NC}"
    echo -e "${GREEN}==========================================================${NC}"
    echo ""
    
    # KVM ACCELERATION DETECTION
    ACCEL_FLAG=""
    if [ -e /dev/kvm ]; then
        ACCEL_FLAG="-enable-kvm"
    fi

    # EXECUTING ENVIRONMENT
    qemu-system-x86_64 \
        $ACCEL_FLAG \
        -hda /home/daytona/ubuntu24.qcow2 \
        -m "$RAM_VALUE" \
        -smp "${CPU_CORES:-2}" \
        -drive file=/home/daytona/seed.img,format=raw \
        -nographic \
        -netdev user,id=net0,hostfwd=tcp::"${TCP_HOST_PORT}"-:"${TCP_GUEST_PORT}" \
        -device e1000,netdev=net0

    # Kill background sshx proxy when QEMU stops
    kill "$SSHX_PID" >/dev/null 2>&1
}

# RESTART PIPELINE
restart_vps() {
    if [ -f "/home/daytona/ubuntu24.qcow2" ] && [ -f "/home/daytona/seed.img" ]; then
        echo -e "${GREEN}🔄 Restarting existing server architecture...${NC}"
        sleep 1
        boot_qemu
    else
        echo -e "${RED}❌ No active configuration blocks found! Build module using Option 1.${NC}"
        sleep 3
        show_menu
    fi
}

# CLEAN PIPELINE
clean_vps() {
    echo -e "${RED}⚠️ Purging system storage components and configurations...${NC}"
    sudo pkill -9 -f qemu-system-x86_64 > /dev/null 2>&1
    $SUDO_CMD rm -rf /home/daytona/user-data /home/daytona/meta-data /home/daytona/seed.img /home/daytona/ubuntu24.qcow2 /home/daytona/.vps_env
    pkill sshx > /dev/null 2>&1
    sleep 1
    echo -e "${GREEN}✅ Workspace successfully wiped fresh!${NC}"
    sleep 2
    show_menu
}

# EXECUTE TRIGGER
show_menu
