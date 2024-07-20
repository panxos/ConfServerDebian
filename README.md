# Script de Configuración Automatizada para Debian

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Descripción

Este script automatiza la configuración de sistemas Debian y sus derivados, optimizando el entorno de trabajo con herramientas modernas y personalizaciones útiles. Diseñado para ahorrar tiempo en la configuración inicial de nuevos sistemas, este script instala y configura una variedad de herramientas y utilidades populares.

## Características

- Actualización del sistema
- Instalación de paquetes esenciales
- Configuración de Zsh con Powerlevel10k
- Instalación y configuración de Fastfetch
- Instalación de LSD (LSDeluxe)
- Configuración de plugins para Zsh
- Instalación de Hack Nerd Fonts
- Configuración de SSH
- Personalización de Nano

## Requisitos

- Sistema operativo Debian o derivado (Ubuntu, Linux Mint, etc.)
- Acceso root o permisos sudo
- Conexión a Internet

## Instalación

1. Clona este repositorio o descarga el script directamente:

```bash
git clone https://github.com/PanX0S/debian-setup-script.git
cd debian-setup-script
```

2. Dale permisos de ejecución al script:

```bash
chmod +x setup_script.sh
```

3. Ejecuta el script con privilegios de root:

```bash
sudo ./setup_script.sh
```

## Uso

El script se ejecutará automáticamente una vez iniciado. Seguirá estos pasos:

1. Actualización del sistema
2. Instalación de paquetes necesarios
3. Configuración de Zsh y Powerlevel10k
4. Instalación y configuración de utilidades (Fastfetch, LSD, etc.)
5. Configuración de plugins de Zsh
6. Instalación de fuentes
7. Configuración de SSH

Al finalizar, se recomienda reiniciar el sistema para aplicar todos los cambios.

## Personalización

Puedes personalizar el script editando las variables al inicio del archivo. Por ejemplo, puedes modificar la lista de paquetes a instalar o cambiar la configuración de ciertos elementos.

## Contribución

Las contribuciones son bienvenidas. 

## Licencia

Distribuido bajo la Licencia MIT. Ver `LICENSE` para más información.

## Contacto

PanX0S - faravena@soporteinfo.net

Enlace del proyecto: [https://github.com/PanX0S/debian-setup-script](https://github.com/PanX0S/debian-setup-script)

## Agradecimientos

- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Fastfetch](https://github.com/LinusDierheimer/fastfetch)
- [LSD](https://github.com/Peltoche/lsd)
- [Zsh](https://www.zsh.org/)
- [Hack Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)
