# Build FPGA — Super Mario DE10

## Pré-requisitos

- Quartus Prime 23.1 Lite (mesma versão dos projetos de referência)
- Intel SoC FPGA Embedded Design Suite (para ARM)

## Passo 1 — Registrar IPs custom

No Platform Designer, adicione os componentes em `fpga/ip/`:

- `framebuffer_bridge_hw.tcl`
- `key_pio_hw.tcl`

## Passo 2 — Gerar soc_system

1. Abrir **Tools → Platform Designer**
2. Abrir `soc_system.qsys`
3. Confirmar instâncias: `hps_0`, `clk_0`, `reset_0`, `framebuffer_bridge_0`, `key_pio_0`
4. Mapear endereços no LW bridge:
   - `framebuffer_bridge_0` → `0x00000000`
   - `key_pio_0` → `0x00000010`
5. Exportar conduit `key_pio_0.key_input` para o top
6. **Generate HDL** → cria `soc_system/synthesis/soc_system.v`

## Passo 3 — Compilar

1. Abrir `SuperMario.qpf`
2. Conectar `KEY[]` ao conduit `key_n` do soc_system no top
3. **Processing → Start Compilation**
4. Programar `output_files/SuperMario.sof`

## Passo 4 — Software ARM

```bash
cd software
make
```

Carregar `supermario.bin` via preloader Terasic ou debugger USB-Blaster.

## Arquitetura do top

```
SuperMario_top
├── soc_system (HPS + framebuffer_bridge + key_pio)
├── VGA_SYNC + vga_scanout
└── framebuffer VGA read port (dual-clock RAM)
```
