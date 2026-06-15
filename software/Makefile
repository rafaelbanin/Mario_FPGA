# Super Mario DE10 - ARM bare-metal build
CROSS ?= arm-none-eabi-
CC = $(CROSS)gcc
AS = $(CROSS)as
OBJCOPY = $(CROSS)objcopy

CFLAGS = -mcpu=cortex-a9 -mfpu=neon -mfloat-abi=hard -O2 -Wall -Wextra \
         -ffreestanding -nostdlib -nostartfiles -I. -Ihw
LDFLAGS = -T linker.ld -nostdlib -nostartfiles

SRCS = startup.S main.c game.c physics.c collision.c camera.c input.c \
       render.c tiles.c tile_gfx_table.c sprites.c gfx.c world.c enemy.c \
       hw/framebuffer.c hw/keys.c hw/timer.c
OBJS = $(SRCS:.c=.o)
OBJS := $(OBJS:.S=.o)

TARGET = supermario
ELF = $(TARGET).elf
BIN = $(TARGET).bin

# Host simulator (PC) - requires libsdl2-dev
HOST_CC ?= gcc
HOST_CFLAGS = -O2 -Wall -Wextra -I. -Ihost
HOST_LIBS = $(shell pkg-config --libs sdl2 2>/dev/null)
HOST_CFLAGS += $(shell pkg-config --cflags sdl2 2>/dev/null)

GAME_SRCS = game.c physics.c collision.c camera.c input.c render.c tiles.c \
            tile_gfx_table.c sprites.c gfx.c world.c enemy.c
HOST_SRCS = host/main_host.c host/framebuffer_host.c host/keys_host.c host/timer_host.c
HOST_TARGET = supermario_host

.PHONY: all host clean host-check

all: $(BIN)

host: $(HOST_TARGET)

$(HOST_TARGET): $(GAME_SRCS) $(HOST_SRCS)
	$(HOST_CC) $(HOST_CFLAGS) -o $@ $(GAME_SRCS) $(HOST_SRCS) $(HOST_LIBS)

$(ELF): $(OBJS) linker.ld
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS)

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.o: %.S
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJS) $(ELF) $(BIN) $(HOST_TARGET)

host-check:
	@echo "Syntax check only - requires $(CROSS)gcc"
	$(CC) $(CFLAGS) -fsyntax-only $(SRCS)
