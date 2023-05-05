#!/bin/bash
echo "Creado por Panxos"
echo "Cualquier duda o consulta: faravena@soporteinfo.net"
echo "https://github.com/panxos"

# Instalar netselect-apt
echo -e "\033[1;34mInstalando netselect-apt...\033[0m"
sudo apt update && sudo apt install -y netselect-apt

# Buscar el repositorio más rápido y actualizar sources.list
echo -e "\033[1;34mBuscando el repositorio más rápido de Debian...\033[0m"
sudo netselect-apt -n -o /tmp/sources.list

# Hacer copia de respaldo de sources.list actual
echo -e "\033[1;34mRealizando copia de respaldo del archivo sources.list actual...\033[0m"
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

# Reemplazar sources.list con el nuevo archivo generado
echo -e "\033[1;34mReemplazando sources.list con el repositorio más rápido...\033[0m"
sudo cp /tmp/sources.list /etc/apt/sources.list

# Actualizar el sistema con los nuevos repositorios
echo -e "\033[1;34mActualizando el sistema con los nuevos repositorios...\033[0m"
sudo apt update && sudo apt upgrade -y

echo -e "\033[1;32mRepositorios actualizados con éxito.\033[0m"

# Instalar paquetes necesarios
echo -e "\033[1;34mInstalando paquetes necesarios...\033[0m"
sudo apt-get install -y nano zsh curl wget nmap bat cmake cmake-data pkg-config python3-sphinx build-essential git vim net-tools neofetch ntpdate openssh-server openssh-client zsh-syntax-highlighting zsh-autosuggestions

# Configurar repositorios non-free y contrib
echo -e "\033[1;34mConfigurando repositorios non-free y contrib...\033[0m"
sudo sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list
sudo apt-get update

# Instalar powerlevel10k para todos los usuarios, incluyendo root
echo -e "\033[1;34mInstalando powerlevel10k para todos los usuarios...\033[0m"

for USER in $(awk -F: '{ print $1}' /etc/passwd); do
  if [ $(getent passwd $USER | cut -d: -f3) -ge 1000 -a $(getent passwd $USER | cut -d: -f3) -le 60000 ]; then
    USER_HOME=$(getent passwd $USER | cut -d: -f6)
    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${USER_HOME}/.powerlevel10k"
    sudo chown -R $USER:$USER "${USER_HOME}/powerlevel10k"
  fi
done

# Instalar powerlevel10k para root
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "/root/.powerlevel10k"


# Descargar archivos de configuración desde GitHub
echo -e "\033[1;34mDescargando archivos de configuración...\033[0m"
wget -O ~/.p10k.zsh https://raw.githubusercontent.com/panxos/KaliLinux_BSPWM_BM/master/.p10k.zsh
wget -O ~/.zshrc https://raw.githubusercontent.com/panxos/KaliLinux_BSPWM_BM/master/.zshrc
wget -O /tmp/.p10k.zsh-root https://raw.githubusercontent.com/panxos/KaliLinux_BSPWM_BM/master/.p10k.zsh-root

# Configurar Nano con colores y líneas
echo -e "\033[1;34mConfigurando Nano con colores y líneas...\033[0m"
echo "syntax \"conf\" \"^#.*\" green" | sudo tee -a /etc/nanorc > /dev/null
echo "set linenumbers" | sudo tee -a /etc/nanorc > /dev/null

# Copiar archivos de configuración
echo -e "\033[1;34mCopiando archivos de configuración...\033[0m"
sudo cp /tmp/.p10k.zsh-root /root/.p10k.zsh

# Establecer Zsh como shell predeterminado para todos los usuarios, incluyendo root
echo -e "\033[1;34mEstableciendo Zsh como shell predeterminado para todos los usuarios...\033[0m"
ZSH_PATH=$(which zsh)
for USER in $(awk -F: '{ print $1}' /etc/passwd); do
  if [ $(getent passwd $USER | cut -d: -f3) -ge 1000 -a $(getent passwd $USER | cut -d: -f3) -le 60000 ]; then
    sudo chsh -s $ZSH_PATH $USER
  fi
done
sudo chsh -s $ZSH_PATH root

# Instalar lsd
echo -e "\033[1;34mInstalando lsd...\033[0m"
wget -O /tmp/lsd.deb https://github.com/lsd-rs/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb
sudo dpkg -i /tmp/lsd.deb

# Configurar neofetch en zsh
echo -e "\033[1;34mConfigurando neofetch en zsh...\033[0m"
echo "neofetch" >> ~/.zshrc

# Configurar ntpdate
echo -e "\033[1;34mConfigurando ntpdate...\033[0m"
sudo sh -c "echo '0 */6 * * * root ntpdate ntp.shoa.cl' > /etc/cron.d/ntpdate"

# Configurar SSH
echo -e "\033[1;34mConfigurando SSH...\033[0m"
sudo systemctl enable ssh
sudo systemctl start ssh

# Instalar y configurar zsh-autosuggestions, zsh-syntax-highlighting y plugin sudo
echo -e "\033[1;34mConfigurando plugins de Zsh...\033[0m"
echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
echo "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
sudo mkdir -p /usr/share/zsh-sudo
sudo wget -O /usr/share/zsh-sudo/sudo.plugin.zsh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
echo "source /usr/share/zsh-sudo/sudo.plugin.zsh" >> ~/.zshrc

# Instalar Hack Nerd Fonts
echo -e "\033[1;34mInstalando Hack Nerd Fonts...\033[0m"
wget -O /tmp/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
unzip /tmp/Hack.zip -d /tmp/HackNerdFont
mkdir -p ~/.local/share/fonts
cp /tmp/HackNerdFont/*.ttf ~/.local/share/fonts/
fc-cache -fv

# Cambiando de SHELL a zsh
sudo rm -rf /root/.zshrc
sudo ln -s -fv ~/.zshrc /root/.zshrc

# Habilitar SSH para root
echo -e "\033[1;34mHabilitando SSH para root...\033[0m"
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo systemctl restart ssh

echo ""
echo "  ____                       _       _"
echo " |  _ \ __ _ _ __  _ __   __| |_ __ (_)_ __  _   ___  __"
echo " | |_) / _\` | '_ \| '_ \ / _\` | '_ \| | '_ \| | | \ \/ /"
echo " |  __/ (_| | | | | | | | (_| | | | | | | | | |_| |>  <"
echo " |_|   \__,_|_| |_|_| |_|\__,_|_| |_|_|_| |_|\__,_/_/\_\\"
echo ""
echo "Creado por Panxos"
echo "Cualquier duda o consulta: faravena@soporteinfo.net"
echo "https://github.com/panxos"

echo -e "\033[1;32mScript completado con éxito:\033[0m"
echo -e "\033[1;32m- Usario agregado a Sudooes\033[0m"
echo -e "\033[1;32m- Repositorios mas Rapidos\033[0m"
echo -e "\033[1;32m- Sourcelist actualizado al mas rapido\033[0m"
echo -e "\033[1;32m- Sistema actualizado\033[0m"
echo -e "\033[1;32m- Paquetes necesarios instalados\033[0m"
echo -e "\033[1;32m- Repositorios non-free y contrib configurados\033[0m"
echo -e "\033[1;32m- Archivos de configuración descargados y copiados\033[0m"
echo -e "\033[1;32m- Powerlevel10k instalado y configurado\033[0m"
echo -e "\033[1;32m- Zsh configurado como terminal predeterminada\033[0m"
echo -e "\033[1;32m- Neofetch configurado en zsh\033[0m"
echo -e "\033[1;32m- Ntpdate configurado como cron\033[0m"
echo -e "\033[1;32m- Plugins zsh configurados\033[0m"
echo -e "\033[1;32m- Hack Nerd Fonts instalado\033[0m"
echo -e "\033[1;32m- SSH habilitado para root y usuarios\033[0m"

