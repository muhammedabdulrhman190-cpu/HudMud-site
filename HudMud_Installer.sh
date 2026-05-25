#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}         HudMod Installer v1.0${NC}"
echo -e "${GREEN}========================================${NC}"

INSTALL_DIR="/opt/HudMod"
DESKTOP_FILE="$HOME/.local/share/applications/hudmod.desktop"
LAUNCHER_SCRIPT="/usr/local/bin/hudmod"


echo -e "${YELLOW}[1/5] Checking HudMud files...${NC}"

if [ ! -f "./HudMod.x86_64" ] || [ ! -f "./HudMod.pck" ]; then
    echo -e "${RED}Error: Required HudMud files not found!${NC}"
    exit 1
fi

echo -e "${GREEN}✓ HudMud files found${NC}"

echo -e "${YELLOW}[2/5] Installing dependencies...${NC}"

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    
    case $OS in
        arch|manjaro)
            sudo pacman -S --needed --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel openal lib32-openal > /dev/null 2>&1
            ;;
        ubuntu|debian|linuxmint|pop)
            sudo apt update > /dev/null 2>&1
            sudo apt install -y mesa-utils libgl1-mesa-glx libgl1-mesa-dri libvulkan1 mesa-vulkan-drivers libopenal1 > /dev/null 2>&1
            ;;
        fedora)
            sudo dnf install -y mesa-libGL mesa-dri-drivers vulkan-loader mesa-vulkan-drivers openal-soft > /dev/null 2>&1
            ;;
        opensuse*)
            sudo zypper install -y Mesa-libGL1 Mesa-dri-vulkan libvulkan1 openal-soft > /dev/null 2>&1
            ;;
    esac
fi

echo -e "${GREEN}✓ Dependencies installed${NC}"

echo -e "${YELLOW}[3/5] Copying game files...${NC}"

sudo mkdir -p "$INSTALL_DIR"
sudo cp -r ./* "$INSTALL_DIR/" 2>/dev/null
sudo chmod +x "$INSTALL_DIR/HudMod.x86_64"

echo -e "${GREEN}✓ Files copied to $INSTALL_DIR${NC}"

echo -e "${YELLOW}[4/5] Creating launcher...${NC}"

sudo bash -c "cat > $LAUNCHER_SCRIPT" << 'EOF'
#!/bin/bash
cd /opt/HudMod
./HudMod.x86_64 --rendering-driver opengl3 --rendering-method gl_compatibility
EOF

sudo chmod +x "$LAUNCHER_SCRIPT"

echo -e "${GREEN}✓ Launcher created${NC}"

echo -e "${YELLOW}[5/5] Creating desktop shortcut...${NC}"

ICON_PATH="applications-games"
for ext in png ico svg jpg jpeg xpm; do
    if [ -f "./hudmod.$ext" ]; then
        sudo cp "./hudmod.$ext" "$INSTALL_DIR/hudmod.$ext" 2>/dev/null
        ICON_PATH="$INSTALL_DIR/hudmod.$ext"
        break
    fi
done

mkdir -p "$HOME/.local/share/applications"

cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=HudMod
Comment=HudMod Game
Exec=$LAUNCHER_SCRIPT
Icon=$ICON_PATH
Terminal=false
Categories=Game;
EOF

chmod +x "$DESKTOP_FILE"
update-desktop-database ~/.local/share/applications/ 2>/dev/null

echo -e "${GREEN}✓ Shortcut created${NC}"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}      Installation Complete! 🎉${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}To run HudMod:${NC}"
echo -e "  • Terminal: ${YELLOW}hudmod${NC}"
echo -e "  • Menu: ${YELLOW}Search for 'HudMod'${NC}"
echo ""
