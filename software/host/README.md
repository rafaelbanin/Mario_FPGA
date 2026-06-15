# Simulador PC

Roda o **mesmo código do jogo** da placa, trocando apenas os drivers de hardware.

## Instalação

```bash
# Ubuntu / Debian
sudo apt install libsdl2-dev build-essential

# Fedora
sudo dnf install SDL2-devel gcc
```

## Compilar e jogar

```bash
cd software
make host
./supermario_host
```

## O que é reutilizado vs. mockado

| Módulo | PC (`host/`) | Placa (`hw/`) |
|--------|--------------|---------------|
| `game.c` | igual | igual |
| `physics.c` | igual | igual |
| `collision.c` | igual | igual |
| `camera.c` | igual | igual |
| `render.c` | igual | igual |
| `tiles.c` / `sprites.c` | igual | igual |
| framebuffer | RAM local | MMIO FPGA |
| teclado | SDL | KEY[] da DE10 |
| timer | `usleep` | timer HPS |

## Controles

| PC | Placa | Ação |
|----|-------|------|
| A / ← | KEY[0] | Esquerda |
| D / → | KEY[1] | Direita |
| Space / W | KEY[2] | Pular |
| R | KEY[3] | Reset |
| Esc | — | Sair |
