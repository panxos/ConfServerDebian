# ConfServerDebian: Configuración ZSH Avanzada para Servidores Debian

<div align="center">
  <table border="0" cellspacing="10" cellpadding="10" style="border:none; background:none; margin: 0 auto;">
    <tr style="border:none; background:none;">
      <td align="center" style="border:none; background:none;">
        <img src="https://raw.githubusercontent.com/panxos/ConfServerDebian/main/panxos_logo.png" alt="PanXOS Logo" width="300px">
        <br>
        <b>PanXOS</b>
      </td>
      <td align="center" style="border:none; background:none; font-size: 24px; font-weight: bold;">
        ×
      </td>
      <td align="center" style="border:none; background:none;">
        <img src="https://www.debian.org/logos/openlogo-nd-100.png" alt="Debian Logo" width="100px">
        <br>
        <b>Debian</b>
      </td>
    </tr>
  </table>
</div>

<div align="center">
  
![Version](https://img.shields.io/badge/Versión-1.1.0-blue)
![Compatibilidad](https://img.shields.io/badge/Compatibilidad-Debian%2010%2B-A81D33)
![Licencia](https://img.shields.io/badge/Licencia-MIT-green)
  
</div>

## 📋 Descripción

**ConfServerDebian** es una solución completa para la configuración automatizada de servidores Debian y derivados. Este script transforma tu servidor en un entorno de administración potente con una interfaz ZSH moderna, herramientas optimizadas y configuraciones de seguridad mejoradas. Ideal para desarrolladores, administradores de sistemas y entusiastas de Linux que buscan un entorno de servidor eficiente y visualmente atractivo.

## ⚠️ Disclaimer

**¡ATENCIÓN! Lea esto antes de utilizar el script:**

Este script está diseñado para configurar Debian y sus derivados con un entorno ZSH para servidores internos y de pruebas. **NO SE RECOMIENDA** su uso en servidores de producción, ya que la instalación de herramientas adicionales podría aumentar las brechas de seguridad.

**EL USO DE ESTE SCRIPT ES BAJO SU PROPIO RIESGO.**

Al utilizar este script, usted reconoce que:
1. Ha leído y entendido completamente su funcionamiento.
2. Acepta que el autor no se hace responsable de ningún daño o pérdida de datos.
3. Comprende que este script modifica configuraciones del sistema y instala software adicional.
4. Se compromete a revisar el código antes de ejecutarlo en cualquier sistema crítico.

## ✨ Nuevas características (v1.1.0)

- **Instalación personalizable**: Seleccione qué componentes instalar según sus necesidades
- **Integración con IPTABLES**: Reglas de seguridad de red preconfiguradas
- **Fail2ban integrado**: Protección contra ataques de fuerza bruta
- **Sistema de actualizaciones**: Verificación automática de nuevas versiones
- **Optimizaciones para servidor**: Configuraciones pensadas para entornos de servidor
- **Plugins de productividad**: Herramientas adicionales para ZSH
- **Mejor manejo de errores**: Detección y manejo robusto de errores durante la instalación
- **Copias de seguridad automáticas**: Respaldo de archivos de configuración importantes

## 🚀 Características principales

- **Entorno ZSH completo**: Shell ZSH con Powerlevel10k, plugins y temas
- **Herramientas mejoradas**: Reemplazos modernos para comandos tradicionales (lsd, bat)
- **Visualización de sistema**: Fastfetch para un resumen elegante del sistema
- **Securización básica**: Configuraciones de seguridad fundamentales
- **Fuentes optimizadas**: Hack Nerd Font para una experiencia visual óptima
- **Configuración de tiempo**: Sincronización automática con servidores NTP
- **Personalización completa**: Fácilmente adaptable a diferentes necesidades

## 📋 Requisitos

- Sistema operativo Debian 10+ o derivados (Ubuntu, Linux Mint, etc.)
- Acceso root o sudo
- Conexión a Internet

## ⚙️ Instalación rápida

```bash
# Método 1: Descarga directa y ejecución
wget -O ConfServerDebian.sh https://raw.githubusercontent.com/panxos/ConfServerDebian/main/ConfServerDebian.sh
chmod +x ConfServerDebian.sh
sudo ./ConfServerDebian.sh

# Método 2: Clonando el repositorio
git clone https://github.com/panxos/ConfServerDebian.git
cd ConfServerDebian
chmod +x ConfServerDebian.sh
sudo ./ConfServerDebian.sh
```

## 🛠️ Componentes instalables

Durante la ejecución del script, podrá elegir qué componentes instalar:

| Componente | Descripción |
|------------|-------------|
| **lsd** | Reemplazo moderno para `ls` con iconos y colores |
| **bat** | Alternativa a `cat` con resaltado de sintaxis |
| **fastfetch** | Información del sistema con estilo |
| **Hack Nerd Fonts** | Fuentes optimizadas para terminales |
| **IPTABLES** | Configuración de firewall básica |
| **SSH para root** | Opcional: acceso SSH para el usuario root |

## 🔒 Características de seguridad

- **Firewall IPTABLES**: Reglas básicas de seguridad preconfiguradas
- **Fail2ban**: Protección contra ataques de fuerza bruta
- **Optimizaciones de seguridad**: Configuraciones de timeout, umask y más
- **Copias de seguridad**: Respaldo automático de archivos de configuración importantes
- **Verificación de contraseña**: Comprobación de la seguridad de contraseñas

## 🖥️ Capturas de pantalla

<div align="center">
  <i>Próximamente: Capturas de pantalla del entorno configurado</i>
</div>

## 🔧 Personalización

El script está diseñado para ser altamente personalizable:

- **Archivos de configuración**:
  - `.zshrc`: Configuración principal de ZSH
  - `.p10k.zsh`: Configuración de Powerlevel10k
  - `/etc/iptables/rules.v4`: Reglas de firewall (si se instala IPTABLES)
  - `/etc/fail2ban/jail.local`: Configuración de Fail2ban

- **Modificación del script**:
  Puede editar el script para ajustarlo a sus necesidades específicas antes de ejecutarlo.

## 🤝 Contribución

Las contribuciones son bienvenidas y apreciadas. Siga estos pasos:

1. Fork el repositorio
2. Cree una rama para su característica (`git checkout -b feature/nueva-caracteristica`)
3. Realice sus cambios y haga commit (`git commit -m 'Añadir nueva característica'`)
4. Empuje a la rama (`git push origin feature/nueva-caracteristica`)
5. Abra un Pull Request

Para cambios importantes, abra primero un issue para discutir lo que le gustaría cambiar.

## 📝 Licencia

Este proyecto está licenciado bajo la Licencia MIT. Vea el archivo `LICENSE` para más detalles.

## 👤 Autor

<div align="center">
  <b>Creado por PanXOS</b>
  <br>
  📧 Contacto: <a href="mailto:faravena@soporteinfo.net">faravena@soporteinfo.net</a>
  <br>
  🌐 GitHub: <a href="https://github.com/panxos">https://github.com/panxos</a>
</div>

---

<div align="center">
  <i>Recuerde revisar y entender cualquier script antes de ejecutarlo en su sistema, especialmente con privilegios de root.</i>
</div>
