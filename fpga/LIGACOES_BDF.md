# Ligações do `SuperMario.bdf`

Monte o schematic no Quartus Block Editor seguindo este guia. Alternativamente, use o top Verilog [`hdl/SuperMario_top.v`](hdl/SuperMario_top.v), que implementa as mesmas ligações.

## Pinos do top-level

### Entradas

| Pino BDF   | Placa DE10 | Função                    |
|------------|------------|---------------------------|
| `CLOCK_50` | PIN_AF14   | Clock 50 MHz              |
| `KEY[0]`   | PIN_AJ4    | Esquerda (ativo-baixo)    |
| `KEY[1]`   | PIN_AK4    | Direita (ativo-baixo)     |
| `KEY[2]`   | PIN_AA14   | Pular (ativo-baixo)       |
| `KEY[3]`   | PIN_AA15   | Reset do jogo (ativo-baixo)|

### Saídas VGA

| Pino BDF   | Placa DE10 | Função              |
|------------|------------|---------------------|
| `VGA_HS`   | PIN_AK19   | Horizontal sync     |
| `VGA_VS`   | PIN_AK18   | Vertical sync       |
| `VGA_CLK`  | PIN_AK21   | Pixel clock 25 MHz  |
| `VGA_R`    | PIN_AJ26   | Vermelho (mono MSB) |
| `VGA_G`    | PIN_AH23   | Verde (mono MSB)    |
| `VGA_B`    | PIN_AK16   | Azul (mono MSB)     |

## Blocos a instanciar

| Instância          | Módulo              | Arquivo                |
|--------------------|---------------------|------------------------|
| `inst_soc`         | `soc_system`        | gerado pelo Qsys       |
| `inst_vga`         | `VGA_SYNC`          | `VGA_Sync.vhd`         |
| `inst_scanout`     | `vga_scanout`       | `vga_scanout.v`        |
| `inst_fb`          | `framebuffer_bridge`| `framebuffer_bridge.v` |
| `inst_keys`        | `key_pio`           | `key_pio.v`            |

## Mapa de ligações

### Reset

```
KEY[3] ──► reset (ativo-alto internamente)
reset ──► inst_soc.reset_reset_n (invertido)
```

### Clock

```
CLOCK_50 ──► inst_soc.clk_clk
CLOCK_50 ──► inst_vga.clock_50Mhz
```

### VGA_SYNC

| Porta            | Ligação                              |
|------------------|--------------------------------------|
| `clock_50Mhz`    | ← `CLOCK_50`                         |
| `red/green/blue` | ← `inst_scanout.red/green/blue`      |
| `horiz_sync_out` | → `VGA_HS`                           |
| `vert_sync_out`  | → `VGA_VS`                           |
| `pixel_clock`    | → `VGA_CLK`                          |
| `red/green/blue_out` | → `VGA_R/G/B`                    |
| `pixel_row/col`  | → `inst_scanout`                     |
| `video_on`       | → `inst_scanout`                     |

### vga_scanout

| Porta         | Ligação                         |
|---------------|---------------------------------|
| `pixel_row/col` | ← `inst_vga`                  |
| `video_on`    | ← `inst_vga`                    |
| `color_index` | ← `inst_fb.vga_color`           |
| `fb_addr`     | → `inst_fb.vga_addr`            |
| `red/green/blue` | → `inst_vga`                 |

### framebuffer_bridge

| Porta          | Ligação                              |
|----------------|--------------------------------------|
| `clk/reset`    | ← `inst_soc` (framebuffer_bridge_0)  |
| `avs_*`        | ↔ `inst_soc` (LW bridge)             |
| `vga_clk`      | ← `VGA_CLK`                          |
| `vga_addr`     | ← `inst_scanout.fb_addr`             |
| `vga_color`    | → `inst_scanout.color_index`         |

### key_pio

| Porta       | Ligação                              |
|-------------|--------------------------------------|
| `key_n`     | ← `KEY[3:0]`                         |
| `clk/reset` | ← `inst_soc` (key_pio_0)             |
| `avs_*`     | ↔ `inst_soc` (LW bridge)             |

## Diagrama resumido

```
CLOCK_50 ──┬── soc_system (HPS + LW bridge)
           │       ├── framebuffer_bridge ◄── ARM writes pixels
           │       └── key_pio ◄── KEY[0..3]
           │
           ├── VGA_SYNC ── pixel_row/col, VGA_HS/VS/CLK
           │       ▲
           │       └── vga_scanout ◄── fb_color
           │               │
           │               └── fb_addr ──► framebuffer_bridge (vga port)
           │
KEY[3] ── reset
```

## Compilar

1. Abrir `SuperMario.qpf`
2. **Tools → Platform Designer** → abrir `soc_system.qsys` → adicionar IPs custom em `fpga/ip/`
3. **Generate HDL** no Platform Designer
4. **Processing → Start Compilation**
5. Programar `.sof` e carregar app ARM via preloader
