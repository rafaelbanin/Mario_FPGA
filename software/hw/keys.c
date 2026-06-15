#include "keys.h"

uint8_t keys_read_raw(void)
{
    return (uint8_t)(mmio_read32(KEY_PIO_BASE + KEY_REG_DATA) & 0x0Fu);
}

uint8_t keys_read_pressed(void)
{
    return (uint8_t)(~keys_read_raw() & 0x0Fu);
}
