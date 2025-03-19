#!/bin/bash

# ConfServerDebian.sh
# Creado por PanXOS
# Mejorado con nuevas funcionalidades
# https://github.com/panxos/ConfServerDebian

# Versión del script
VERSION="1.1.0"

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

# Función para manejar errores
handle_error() {
    print_error "Error en la línea $1: Comando fallido: $2"
    read -p "¿Desea continuar? (s/n): " continue_after_error
    if [[ ! $continue_after_error =~ ^[Ss]$ ]]; then
        print_error "Script cancelado debido a errores."
        exit 1
    fi
}

# Añadir trap para capturar errores
trap 'handle_error ${LINENO} "$BASH_COMMAND"' ERR

# Función para hacer backup de archivos
backup_file() {
    if [ -f "$1" ]; then
        cp "$1" "$1.bak.$(date +%Y%m%d%H%M%S)"
        print_message "Copia de seguridad creada: $1.bak.$(date +%Y%m%d%H%M%S)"
    fi
}

# Verificar versión de Debian
check_debian_version() {
    if ! command -v lsb_release &> /dev/null; then
        apt-get update
        apt-get install -y lsb-release
    fi
    
    debian_version=$(lsb_release -rs)
    if [[ $(echo "$debian_version < 10" | bc 2>/dev/null || echo "1") -eq 1 ]]; then
        print_warning "Este script está optimizado para Debian 10+ (versión actual: $debian_version)"
        read -p "¿Desea continuar de todos modos? (s/n): " continue_anyway
        if [[ ! $continue_anyway =~ ^[Ss]$ ]]; then
            print_error "Script cancelado."
            exit 1
        fi
    fi
}

# Comprobar actualizaciones del script
check_for_updates() {
    print_message "Comprobando actualizaciones del script..."
    if command -v curl &> /dev/null; then
        latest_version=$(curl -s https://raw.githubusercontent.com/panxos/ConfServerDebian/main/VERSION 2>/dev/null || echo "0.0.0")
        
        if [[ "$latest_version" != "$VERSION" && "$latest_version" != "0.0.0" ]]; then
            print_warning "Hay una nueva versión disponible: $latest_version (actual: $VERSION)"
            read -p "¿Desea actualizar antes de continuar? (s/n): " update_script
            if [[ $update_script =~ ^[Ss]$ ]]; then
                curl -s https://raw.githubusercontent.com/panxos/ConfServerDebian/main/ConfServerDebian.sh -o /tmp/ConfServerDebian_new.sh
                chmod +x /tmp/ConfServerDebian_new.sh
                print_success "Script actualizado. Por favor, ejecute el nuevo script:"
                echo "bash /tmp/ConfServerDebian_new.sh"
                exit 0
            fi
        else
            print_success "El script está actualizado."
        fi
    else
        print_warning "curl no está instalado. No se pueden comprobar actualizaciones."
    fi
}

# Función para seleccionar componentes a instalar
select_components() {
    print_message "Seleccione los componentes a instalar (predeterminado: N):"
    read -p "¿Instalar lsd (reemplazo mejorado para ls)? (s/N): " install_lsd
    read -p "¿Instalar bat (reemplazo mejorado para cat)? (s/N): " install_bat
    read -p "¿Instalar fastfetch (información del sistema)? (s/N): " install_fastfetch
    read -p "¿Instalar Hack Nerd Fonts? (s/N): " install_fonts
    read -p "¿Configurar iptables? (s/N): " configure_iptables
}

# Instalar powerlevel10k
install_powerlevel10k() {
    local USER_HOME=$1
    local USER=$2
    if [ ! -d "${USER_HOME}/.powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${USER_HOME}/.powerlevel10k"
        chown -R $USER:$USER "${USER_HOME}/.powerlevel10k"
    fi
}

# Añadir línea a zshrc si no existe
add_to_zshrc() {
    local file=$1
    local source_line=$2
    if ! grep -q "$source_line" "$file"; then
        echo "$source_line" >> "$file"
    fi
}

# Configurar iptables
setup_iptables() {
    print_message "Configurando iptables..."
    
    # Instalar iptables
    apt-get install -y iptables iptables-persistent
    
    # Hacer backup del archivo de reglas si existe
    if [ -f "/etc/iptables/rules.v4" ]; then
        backup_file "/etc/iptables/rules.v4"
    fi
    
    # Crear reglas básicas de seguridad
    cat > /etc/iptables/rules.v4 << EOF
# Política predeterminada - Denegar todo el tráfico entrante y permitir el saliente
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]

# Permitir tráfico establecido y relacionado
-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Permitir loopback
-A INPUT -i lo -j ACCEPT

# Permitir ping (opcional)
-A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Permitir SSH
-A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT

# Registrar los paquetes rechazados
-A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

COMMIT
EOF

    # Activar las reglas
    iptables-restore < /etc/iptables/rules.v4
    
    # Asegurar que las reglas se cargan en el inicio
    systemctl enable netfilter-persistent.service
    
    print_success "Iptables configurado con reglas básicas de seguridad."
    print_warning "Se ha habilitado el acceso SSH en el puerto 22."
    print_warning "Modifique /etc/iptables/rules.v4 si necesita permitir más puertos."
}

# Instalar plugins adicionales para ZSH
install_additional_plugins() {
    print_message "Instalando plugins adicionales para ZSH..."
    
    # Plugin para historial mejorado
    if [ ! -d "/usr/share/zsh-history-substring-search" ]; then
        git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search /usr/share/zsh-history-substring-search
    fi
    
    # Añadir a zshrc para todos los usuarios
    for USER in $(awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd) root; do
        USER_HOME=$([ "$USER" = "root" ] && echo "/root" || echo "/home/$USER")
        add_to_zshrc $USER_HOME/.zshrc "source /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
        add_to_zshrc $USER_HOME/.zshrc "bindkey '^[[A' history-substring-search-up"
        add_to_zshrc $USER_HOME/.zshrc "bindkey '^[[B' history-substring-search-down"
    done
    
    print_success "Plugins adicionales instalados y configurados."
}

# Optimizaciones para servidor
optimize_for_server() {
    print_message "Optimizando configuraciones para servidor..."
    
    # Limitar el tamaño del historial para evitar archivos enormes
    for USER in $(awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd) root; do
        USER_HOME=$([ "$USER" = "root" ] && echo "/root" || echo "/home/$USER")
        sed -i 's/HISTSIZE=1000/HISTSIZE=500/g' $USER_HOME/.zshrc
        sed -i 's/SAVEHIST=1000/SAVEHIST=500/g' $USER_HOME/.zshrc
    done
    
    # Configurar umask más restrictivo para mayor seguridad
    if ! grep -q "umask 027" /etc/zsh/zshrc; then
        echo "umask 027" >> /etc/zsh/zshrc
    fi
    
    # Configurar timeout de sesión para seguridad
    if ! grep -q "TMOUT=1800" /etc/zsh/zshrc; then
        echo "TMOUT=1800" >> /etc/zsh/zshrc
        echo "readonly TMOUT" >> /etc/zsh/zshrc
    fi
    
    print_success "Optimizaciones para servidor aplicadas."
}

# Configurar reglas específicas para servidores
configure_server_security() {
    print_message "Configurando reglas de seguridad adicionales..."
    
    # Instalar fail2ban para protección contra ataques de fuerza bruta
    apt-get install -y fail2ban
    
    # Configuración básica de fail2ban
    cat > /etc/fail2ban/jail.local << EOF
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
EOF

    # Activar fail2ban
    systemctl enable fail2ban
    systemctl restart fail2ban
    
    print_success "Configuración de seguridad adicional aplicada."
    print_message "Fail2ban configurado para proteger contra ataques de fuerza bruta SSH."
}

# INICIO DEL SCRIPT PRINCIPAL

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
print_message "Versión: $VERSION"

# Verificar si se ejecuta como root
if [[ $EUID -ne 0 ]]; then
   print_error "Este script debe ser ejecutado como root"
   exit 1
fi

# Verificar versión de Debian
check_debian_version

# Comprobar actualizaciones
check_for_updates

# Seleccionar componentes
select_components

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
apt-get install -y nano zsh curl wget nmap cmake cmake-data pkg-config python3-sphinx build-essential git vim net-tools ntpdate openssh-server openssh-client unzip fontconfig bc

# Instalar paquetes según selección
if [[ $install_bat =~ ^[Ss]$ ]]; then
    print_message "Instalando bat..."
    apt-get install -y bat || apt-get install -y batcat
fi

# Instalar Fastfetch
if [[ $install_fastfetch =~ ^[Ss]$ ]]; then
    print_message "Instalando Fastfetch..."
    wget -O /tmp/fastfetch.deb https://github.com/fastfetch-cli/fastfetch/releases/download/2.18.1/fastfetch-linux-amd64.deb
    dpkg -i /tmp/fastfetch.deb
    if [ $? -ne 0 ]; then
        apt-get install -f -y
        dpkg -i /tmp/fastfetch.deb
    fi
fi

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
if [[ $install_lsd =~ ^[Ss]$ ]]; then
    print_message "Instalando lsd..."
    wget -O /tmp/lsd.deb https://github.com/lsd-rs/lsd/releases/download/v1.1.2/lsd_1.1.2_amd64.deb
    dpkg -i /tmp/lsd.deb
    if [ $? -ne 0 ]; then
        apt-get install -f -y
        dpkg -i /tmp/lsd.deb
    fi
fi

# Configurar fastfetch en zsh si se seleccionó
if [[ $install_fastfetch =~ ^[Ss]$ ]]; then
    print_message "Configurando fastfetch en zsh..."
    echo "fastfetch" >> /root/.zshrc
    for USER in $(awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd); do
        USER_HOME=$(getent passwd $USER | cut -d: -f6)
        echo "fastfetch" >> $USER_HOME/.zshrc
    done
fi

# Configurar ntpdate
print_message "Configurando ntpdate..."
echo "0 */6 * * * root ntpdate ntp.shoa.cl" > /etc/cron.d/ntpdate

# Configurar SSH
print_message "Configurando SSH..."
backup_file /etc/ssh/sshd_config
systemctl enable ssh
systemctl start ssh

# Instalar y configurar zsh-autosuggestions, zsh-syntax-highlighting y plugin sudo
print_message "Configurando plugins de Zsh..."
apt-get install -y zsh-autosuggestions zsh-syntax-highlighting
mkdir -p /usr/share/zsh-sudo
wget -O /usr/share/zsh-sudo/sudo.plugin.zsh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh

for USER in $(awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd) root; do
    USER_HOME=$([ "$USER" = "root" ] && echo "/root" || echo "/home/$USER")
    add_to_zshrc $USER_HOME/.zshrc "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    add_to_zshrc $USER_HOME/.zshrc "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    add_to_zshrc $USER_HOME/.zshrc "source /usr/share/zsh-sudo/sudo.plugin.zsh"
done

# Instalar plugins adicionales
install_additional_plugins

# Instalar Hack Nerd Fonts si se seleccionó
if [[ $install_fonts =~ ^[Ss]$ ]]; then
    print_message "Instalando Hack Nerd Fonts..."
    wget -O /tmp/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
    unzip /tmp/Hack.zip -d /tmp/HackNerdFont
    mkdir -p /usr/local/share/fonts/
    cp /tmp/HackNerdFont/*.ttf /usr/local/share/fonts/ || print_warning "No se encontraron archivos .ttf en /tmp/HackNerdFont/"
    fc-cache -fv
fi

# Configurar iptables si se seleccionó
if [[ $configure_iptables =~ ^[Ss]$ ]]; then
    setup_iptables
fi

# Aplicar optimizaciones para servidor
optimize_for_server

# Configurar seguridad adicional
configure_server_security

# Preguntar sobre SSH para root
print_message "¿Desea habilitar SSH para el usuario root? (No recomendado en producción) (s/n): "
read enable_root_ssh
if [[ $enable_root_ssh =~ ^[Ss]$ ]]; then
    backup_file /etc/ssh/sshd_config
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
    systemctl restart ssh
    print_warning "SSH para root habilitado. Considere deshabilitarlo en producción."
else
    print_success "SSH para root no habilitado (más seguro)."
fi

# Limpiar archivos temporales
print_message "Limpiando archivos temporales..."
rm -rf /tmp/Hack.zip /tmp/HackNerdFont /tmp/fastfetch.deb /tmp/lsd.deb /tmp/.p10k.zsh /tmp/.zshrc /tmp/.p10k.zsh-root

print_success "Script completado con éxito:"
print_success "- Sistema actualizado"
print_success "- Paquetes necesarios instalados"
print_success "- Archivos de configuración descargados y copiados"
print_success "- Powerlevel10k instalado y configurado"
print_success "- Zsh configurado como terminal predeterminada"
if [[ $install_fastfetch =~ ^[Ss]$ ]]; then
    print_success "- Fastfetch configurado en zsh"
fi
print_success "- Ntpdate configurado como cron"
print_success "- Plugins zsh configurados"
if [[ $install_fonts =~ ^[Ss]$ ]]; then
    print_success "- Hack Nerd Fonts instalado"
fi
print_success "- SSH configurado"
if [[ $configure_iptables =~ ^[Ss]$ ]]; then
    print_success "- Iptables configurado con reglas básicas de seguridad"
fi
print_success "- Configuraciones de seguridad aplicadas"
print_success "- Contraseña de root verificada/configurada"

cat << "EOF"

  ____               __  __  ___  ____
 |  _ \ __ _ _ __   \ \/ / / _ \/ ___|
 | |_) / _` | '_ \   \  / | | | \___ \
 |  __/ (_| | | | |  /  \ | |_| |___) |
 |_|   \__,_|_| |_| /_/\_\ \___/|____/

EOF

print_message "Creado por PanXOS"
print_message "Mejorado con nuevas funcionalidades"
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
