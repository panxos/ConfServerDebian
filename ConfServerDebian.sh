#!/bin/bash

# ConfServerDebian.sh
# Creado por PanXOS
# https://github.com/panxos/ConfServerDebian

# Colores para mejor legibilidad
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con formato
print_message() {
    echo -e "${BLUE}[*] $1${NC}"
}

# Función para imprimir errores
print_error() {
    echo -e "${RED}[!] Error: $1${NC}"
}

# Función para imprimir advertencias
print_warning() {
    echo -e "${YELLOW}[!] Advertencia: $1${NC}"
}

# Función para imprimir éxito
print_success() {
    echo -e "${GREEN}[+] $1${NC}"
}

# Disclaimer
print_message "================================================================================"
print_message "DISCLAIMER:"
print_message "Este script está diseñado para configurar Debian y sus derivados con entorno ZSH"
print_message "para servidores internos y de pruebas. NO SE RECOMIENDA su uso en servidores de"
print_message "producción, ya que la instalación de herramientas adicionales podría aumentar"
print_message "las brechas de seguridad. EL USO DE ESTE SCRIPT ES BAJO SU PROPIO RIESGO."
print_message "================================================================================"
echo ""
read -p "¿Está de acuerdo y desea continuar? (s/n): " agree
if [[ ! $agree =~ ^[Ss]$ ]]; then
    print_error "Script cancelado."
    exit 1
fi

print_message "Creado por PanXOS"
print_message "Cualquier duda o consulta: faravena@soporteinfo.net"
print_message "https://github.com/panxos/ConfServerDebian"

# Verificar si se ejecuta como root
if [[ $EUID -ne 0 ]]; then
   print_error "Este script debe ser ejecutado como root"
   exit 1
fi

# Verificar si el usuario root tiene contraseña
if passwd -S root | grep -q NP; then
    print_warning "El usuario root no tiene contraseña. Por favor, configure una:"
    passwd root
fi

# Actualizar el sistema
print_message "Actualizando el sistema..."
apt update && apt upgrade -y

# Instalar paquetes necesarios
print_message "Instalando paquetes necesarios..."
apt-get install -y nano zsh curl wget nmap bat cmake cmake-data pkg-config python3-sphinx build-essential git vim net-tools ntpdate openssh-server openssh-client unzip fontconfig

# Instalar Fastfetch
print_message "Instalando Fastfetch..."
wget -O /tmp/fastfetch.deb https://github.com/fastfetch-cli/fastfetch/releases/download/2.18.1/fastfetch-linux-amd64.deb
dpkg -i /tmp/fastfetch.deb

# Función para instalar powerlevel10k
install_powerlevel10k() {
    local USER_HOME=$1
    local USER=$2
    if [ ! -d "${USER_HOME}/.powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${USER_HOME}/.powerlevel10k"
        chown -R $USER:$USER "${USER_HOME}/.powerlevel10k"
    fi
}

# Instalar powerlevel10k para todos los usuarios, incluyendo root
print_message "Instalando powerlevel10k para todos los usuarios..."
for USER in $(awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd); do
    USER_HOME=$(getent passwd $USER | cut -d: -f6)
    install_powerlevel10k $USER_HOME $USER
done
install_powerlevel10k /root root

# Descargar archivos de configuración desde GitHub
print_message "Descargando archivos de configuración..."
wget -O /tmp/.p10k.zsh https://raw.githubusercontent.com/panxos/ConfServerDebian/main/.p10k.zsh
wget -O /tmp/.zshrc https://raw.githubusercontent.com/panxos/ConfServerDebian/main/.zshrc
wget -O /tmp/.p10k.zsh-root https://raw.githubusercontent.com/panxos/ConfServerDebian/main/.p10k.zsh-root

# Configurar Nano con colores y líneas
print_message "Configurando Nano con colores y líneas..."
cat << EOF > /etc/nanorc
set linenumbers
include "/usr/share/nano/*.nanorc"
EOF

# Copiar archivos de configuración
print_message "Copiando archivos de configuración..."
cp /tmp/.p10k.zsh-root /root/.p10k.zsh
cp /tmp/.zshrc /root/.zshrc

# Establecer Zsh como shell predeterminado para todos los usuarios, incluyendo root
print_message "Estableciendo Zsh como shell predeterminado para todos los usuarios..."
ZSH_PATH=$(which zsh)
for USER in $(awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd); do
    chsh -s $ZSH_PATH $USER
    USER_HOME=$(getent passwd $USER | cut -d: -f6)
    cp /tmp/.zshrc $USER_HOME/.zshrc
    cp /tmp/.p10k.zsh $USER_HOME/.p10k.zsh
    chown $USER:$USER $USER_HOME/.zshrc $USER_HOME/.p10k.zsh
done
chsh -s $ZSH_PATH root

# Instalar lsd
print_message "Instalando lsd..."
wget -O /tmp/lsd.deb https://github.com/lsd-rs/lsd/releases/download/v1.1.2/lsd_1.1.2_amd64.deb
dpkg -i /tmp/lsd.deb

# Configurar fastfetch en zsh
print_message "Configurando fastfetch en zsh..."
echo "fastfetch" >> /root/.zshrc
for USER in $(awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd); do
    USER_HOME=$(getent passwd $USER | cut -d: -f6)
    echo "fastfetch" >> $USER_HOME/.zshrc
done

# Configurar ntpdate
print_message "Configurando ntpdate..."
echo "0 */6 * * * root ntpdate ntp.shoa.cl" > /etc/cron.d/ntpdate

# Configurar SSH
print_message "Configurando SSH..."
systemctl enable ssh
systemctl start ssh

# Instalar y configurar zsh-autosuggestions, zsh-syntax-highlighting y plugin sudo
print_message "Configurando plugins de Zsh..."
apt-get install -y zsh-autosuggestions zsh-syntax-highlighting
mkdir -p /usr/share/zsh-sudo
wget -O /usr/share/zsh-sudo/sudo.plugin.zsh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh

# Función para añadir fuente a .zshrc si no existe
add_to_zshrc() {
    local file=$1
    local source_line=$2
    if ! grep -q "$source_line" "$file"; then
        echo "$source_line" >> "$file"
    fi
}

for USER in $(awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd) root; do
    USER_HOME=$([ "$USER" = "root" ] && echo "/root" || echo "/home/$USER")
    add_to_zshrc $USER_HOME/.zshrc "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    add_to_zshrc $USER_HOME/.zshrc "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    add_to_zshrc $USER_HOME/.zshrc "source /usr/share/zsh-sudo/sudo.plugin.zsh"
done

# Instalar Hack Nerd Fonts
print_message "Instalando Hack Nerd Fonts..."
wget -O /tmp/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
unzip /tmp/Hack.zip -d /tmp/HackNerdFont
mkdir -p /usr/local/share/fonts/
cp /tmp/HackNerdFont/*.ttf /usr/local/share/fonts/ || print_warning "No se encontraron archivos .ttf en /tmp/HackNerdFont/"
fc-cache -fv

# Habilitar SSH para root
print_message "Habilitando SSH para root..."
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart ssh

# Limpiar archivos temporales
print_message "Limpiando archivos temporales..."
rm -rf /tmp/Hack.zip /tmp/HackNerdFont /tmp/fastfetch.deb /tmp/lsd.deb /tmp/.p10k.zsh /tmp/.zshrc /tmp/.p10k.zsh-root

print_success "Script completado con éxito:"
print_success "- Sistema actualizado"
print_success "- Paquetes necesarios instalados"
print_success "- Archivos de configuración descargados y copiados"
print_success "- Powerlevel10k instalado y configurado"
print_success "- Zsh configurado como terminal predeterminada"
print_success "- Fastfetch configurado en zsh"
print_success "- Ntpdate configurado como cron"
print_success "- Plugins zsh configurados"
print_success "- Hack Nerd Fonts instalado"
print_success "- SSH habilitado para root y usuarios"
print_success "- Contraseña de root verificada/configurada"

cat << "EOF"

  ____               __  __  ___  ____
 |  _ \ __ _ _ __   \ \/ / / _ \/ ___|
 | |_) / _` | '_ \   \  / | | | \___ \
 |  __/ (_| | | | |  /  \ | |_| |___) |
 |_|   \__,_|_| |_| /_/\_\ \___/|____/

EOF

print_message "Creado por PanXOS"
print_message "Cualquier duda o consulta: faravena@soporteinfo.net"
print_message "https://github.com/panxos/ConfServerDebian"

print_warning "Se recomienda reiniciar el sistema para aplicar todos los cambios."
read -p "¿Desea reiniciar ahora? (s/n): " reboot_now
if [[ $reboot_now =~ ^[Ss]$ ]]; then
    print_message "Reiniciando el sistema..."
    reboot
else
    print_message "No se reiniciará el sistema. Recuerde reiniciar manualmente para aplicar todos los cambios."
fi
