#include "hw/keys.h"

static uint8_t host_keys_state;

void host_keys_set(uint8_t pressed)
{
    host_keys_state = pressed;
}

uint8_t keys_read_raw(void)
{
    return (uint8_t)(~host_keys_state & 0x0Fu);
}

uint8_t keys_read_pressed(void)
{
    return host_keys_state & 0x0Fu;
}
