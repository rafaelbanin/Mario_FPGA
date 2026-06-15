# Super Mario DE10 — Fase 1

Projeto SoC para **Terasic DE10-Standard** (Cyclone V `5CSXFC6D6F31C6`) com:
- **ARM Cortex-A9** bare-metal: física, colisão, câmera e renderização
- **FPGA**: VGA 640×480, framebuffer dual-port, leitura de botões

## Estrutura

- `fpga/` — Quartus + Platform Designer + HDL VGA
- `software/` — jogo em C bare-metal
- `tools/` — conversão de assets

## Controles (KEY)

| Botão | Ação |
|-------|------|
| KEY[0] | Esquerda |
| KEY[1] | Direita |
| KEY[2] | Pular |
| KEY[3] | Reset |

## Build FPGA

1. Abrir `fpga/SuperMario.qpf` no Quartus Prime 23.1
2. **Tools → Platform Designer** → abrir `soc_system.qsys`
3. Adicionar IPs custom: `fpga/ip/framebuffer_bridge_hw.tcl`, `fpga/ip/key_pio_hw.tcl`
4. Gerar HDL do sistema
5. **Processing → Start Compilation**
6. Programar `output_files/SuperMario.sof`

## Testar no PC antes da placa (simulador)

O mesmo código do jogo pode rodar na sua máquina com SDL2 (Linux ou Windows).

### Linux

```bash
sudo apt install libsdl2-dev build-essential cmake pkg-config   # Ubuntu/Debian
cd software
make host                    # ou: ./build_host.sh
./supermario_host
```

Com CMake:

```bash
cd software
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
./build/supermario_host
```

### Windows (MSYS2)

1. Instale [MSYS2](https://www.msys2.org/)
2. No terminal **UCRT64**:

```bash
pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-cmake mingw-w64-ucrt-x86_64-make mingw-w64-ucrt-x86_64-SDL2
cd /c/caminho/para/Mario_FPGA/software
./build_host.bat
./build/supermario_host.exe
```

Alternativa com Make (MSYS2):

```bash
make host
./supermario_host.exe
```

| Tecla PC | Ação |
|----------|------|
| A / ← | Esquerda |
| D / → | Direita |
| Space / W / ↑ | Pular |
| R | Reset |
| Esc | Sair |

O simulador usa os mesmos `game.c`, `physics.c`, `collision.c`, `render.c`, etc. Só troca os drivers de hardware (`host/` em vez de `hw/`).

## Build ARM (placa)

Requer `arm-none-eabi-gcc` (SoC EDS ou toolchain ARM):

```bash
cd software
make
```

## Arte gráfica (indexada 16×16)

Sprites e tiles usam **16×16 pixels, 4-bit por pixel** (128 bytes). Edite os arquivos ASCII em `assets/gfx/` e regenere:

```bash
python3 tools/gfx_to_c.py assets/gfx/mario_idle.txt mario_idle -o software/mario_idle_gfx.h
```

Mapa de cores: [`assets/PALETTE.txt`](assets/PALETTE.txt)

## Goomba inimigo

- Patrulha horizontal no chão (inverte em paredes e bordas)
- **Pisar em cima** → Goomba morre, Mario quica
- **Encostar pelo lado** → respawn no início (igual cair no buraco)
- Spawns configurados em `software/enemy_spawns.h`

## Marcos de validação (M1–M5)

| Marco | Teste |
|-------|-------|
| M1 | VGA exibe céu azul após boot |
| M2 | Alterar cor de fundo em `fb_clear()` |
| M3 | Cenário com chão, blocos e cano visíveis |
| M4 | Mario responde a KEY[0]/KEY[1], câmera segue |
| M5 | Pulo, gravidade, colisão e respawn em buracos |

## Referências reutilizadas

- `VGA_Sync.vhd`, `Video_PLL.vhd` — projetos Jogo da Vida e Prática BDF
- Padrão dual-port RAM de `game.v`
- Viewport/escala de `imagem_vga.v` e `mascara.v`
