# ConfServerDebian

![PanXOS Logo](https://raw.githubusercontent.com/panxos/ConfServerDebian/main/panxos_logo.png)

## Descripción

ConfServerDebian es un script de configuración automatizada para servidores Debian y sus derivados. Este script está diseñado para configurar rápidamente un entorno de servidor con ZSH, herramientas útiles y una configuración optimizada para desarrolladores y administradores de sistemas.

## ⚠️ Disclaimer

**¡ATENCIÓN! Lea esto antes de utilizar el script:**

Este script está diseñado para configurar Debian y sus derivados con un entorno ZSH para servidores internos y de pruebas. **NO SE RECOMIENDA** su uso en servidores de producción, ya que la instalación de herramientas adicionales podría aumentar las brechas de seguridad.

**EL USO DE ESTE SCRIPT ES BAJO SU PROPIO RIESGO.**

Al utilizar este script, usted reconoce que:
1. Ha leído y entendido completamente su funcionamiento.
2. Acepta que el autor no se hace responsable de ningún daño o pérdida de datos.
3. Comprende que este script modifica configuraciones del sistema y instala software adicional.
4. Se compromete a revisar el código antes de ejecutarlo en cualquier sistema crítico.

## Características

- Actualización del sistema
- Instalación de paquetes esenciales
- Configuración de ZSH como shell predeterminada
- Instalación y configuración de Powerlevel10k
- Configuración de Nano con colores y números de línea
- Instalación de Fastfetch para un resumen del sistema
- Configuración de NTP para sincronización de tiempo
- Instalación de fuentes Hack Nerd Font
- Configuración de SSH
- Instalación de plugins útiles para ZSH

## Requisitos

- Sistema operativo Debian o derivado (Ubuntu, Linux Mint, etc.)
- Acceso root o sudo
- Conexión a Internet

## Instalación

1. Clone este repositorio:
   ```
   git clone https://github.com/panxos/ConfServerDebian.git
   ```

2. Navegue al directorio del script:
   ```
   cd ConfServerDebian
   ```

3. Haga el script ejecutable:
   ```
   chmod +x ConfServerDebian.sh
   ```

4. Ejecute el script como root:
   ```
   sudo ./ConfServerDebian.sh
   ```

## Uso

Siga las instrucciones en pantalla durante la ejecución del script. Se le pedirá confirmar ciertas acciones y proporcionar información cuando sea necesario.

## Qué hace el script

1. Actualiza el sistema
2. Instala paquetes necesarios
3. Configura ZSH y Powerlevel10k
4. Instala y configura Fastfetch
5. Configura Nano con colores y números de línea
6. Instala y configura plugins de ZSH
7. Configura SSH
8. Instala fuentes Hack Nerd Font
9. Configura NTP para sincronización de tiempo

## Personalización

Puede personalizar la configuración editando los siguientes archivos:
- `.zshrc`: Configuración principal de ZSH
- `.p10k.zsh`: Configuración de Powerlevel10k
- `ConfServerDebian.sh`: El script principal, si desea modificar el proceso de instalación

## Contribución

Las contribuciones son bienvenidas. Por favor, abra un issue para discutir cambios importantes antes de crear un pull request.

## Soporte

Si encuentra algún problema o tiene alguna pregunta, por favor abra un issue en este repositorio.

## Licencia

Este proyecto está licenciado bajo la Licencia MIT. Vea el archivo `LICENSE` para más detalles.

## Autor

Creado por PanXOS

Contacto: faravena@soporteinfo.net

GitHub: [https://github.com/panxos](https://github.com/panxos)

---

**Nota**: Recuerde siempre revisar y entender cualquier script antes de ejecutarlo en su sistema, especialmente con privilegios de root.
