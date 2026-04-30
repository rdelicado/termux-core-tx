# AGENTS.md - CORE-TX

## Proyecto
Toolkit modular para Termux (Android) + Linux/WSL2.

## Branding
- **Nombre**: CORE-TX
- **Banner**: ASCII con gradiente Cyan→Magenta

## Estructura
```
bin/main.sh
core/
├── detection.sh   # SO: android/linux/darwin
├── utils.sh       # colores, banner(), install_package()
├── menu.sh        # submenús con clear + estado real
├── backup.sh      # backups automática
├── logger.sh      # logs
modules/
├── 01-appearance/
├── 02-base-tools/
└── 03-dev-env/
```

## Ejecutar
```bash
./bin/main.sh
```

## Menú Principal
1. Apariencia → submenú
2. Herramientas Base → submenú
3. Entornos Dev → submenú
4. Instalar Todo
5. Ver Estado
6. Ver Logs
0. Salir

## Submenús
- clear antes de mostrar
- Estado en tiempo real: [INSTALADO] / [FALTA]
- A) Instalar todas, B) Volver

## Deploy
```bash
scp -r termux-toolkit/ user@android:/ruta/
./bin/main.sh
```