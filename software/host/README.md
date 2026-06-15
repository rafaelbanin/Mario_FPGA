# Simulador PC

Roda o **mesmo código do jogo** da placa, trocando apenas os drivers de hardware.

Suportado em **Linux** e **Windows** (via MSYS2/MinGW).

## Linux

### Dependências

```bash
# Ubuntu / Debian
sudo apt install libsdl2-dev build-essential cmake pkg-config

# Fedora
sudo dnf install SDL2-devel gcc cmake pkgconfig
```

### Compilar e jogar

```bash
cd software
make host              # Makefile
# ou
./build_host.sh        # CMake
./supermario_host      # ou ./build/supermario_host
```

## Windows (MSYS2)

### Dependências

1. Instale [MSYS2](https://www.msys2.org/)
2. Abra o terminal **MSYS2 UCRT64** e instale:

```bash
pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-cmake \
          mingw-w64-ucrt-x86_64-make mingw-w64-ucrt-x86_64-SDL2
```

### Compilar e jogar

```bash
cd /c/caminho/para/Mario_FPGA/software
./build_host.bat
./build/supermario_host.exe
```

Ou com Make:

```bash
make host
./supermario_host.exe
```

### Problemas comuns (Windows)

| Erro | Solução |
|------|---------|
| `cmake not found` | Use o terminal **UCRT64**, não CMD/PowerShell |
| `SDL2 not found` | `pacman -S mingw-w64-ucrt-x86_64-SDL2` |
| Janela não abre | Atualize drivers de vídeo; tente executar de dentro do MSYS2 UCRT64 |

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
| timer | `SDL_Delay` | timer HPS |

## Controles

| PC | Placa | Ação |
|----|-------|------|
| A / ← | KEY[0] | Esquerda |
| D / → | KEY[1] | Direita |
| Space / W | KEY[2] | Pular |
| R | KEY[3] | Reset |
| Esc | — | Sair |
