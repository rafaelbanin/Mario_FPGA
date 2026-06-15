#include "hw/framebuffer.h"
#include "gfx.h"

static uint8_t fb_mem[FB_PIXELS];
static uint32_t write_addr;

void fb_init(void)
{
    fb_clear(COLOR_SKY);
}

void fb_set_addr(uint32_t addr)
{
    write_addr = addr;
}

void fb_write_pixel(uint8_t color)
{
    if (write_addr < FB_PIXELS) {
        fb_mem[write_addr] = color & 0x0Fu;
        write_addr++;
    }
}

void fb_write_at(uint16_t x, uint16_t y, uint8_t color)
{
    if (x >= FB_WIDTH || y >= FB_HEIGHT)
        return;
    fb_mem[y * FB_WIDTH + x] = color & 0x0Fu;
}

void fb_clear(uint8_t color)
{
    uint32_t i;
    for (i = 0; i < FB_PIXELS; i++)
        fb_mem[i] = color & 0x0Fu;
    write_addr = 0;
}

void fb_fill_rect(uint16_t x, uint16_t y, uint16_t w, uint16_t h, uint8_t color)
{
    uint16_t row, col;
    for (row = y; row < y + h && row < FB_HEIGHT; row++) {
        for (col = x; col < x + w && col < FB_WIDTH; col++)
            fb_write_at(col, row, color);
    }
}

const uint8_t *host_framebuffer_ptr(void)
{
    return fb_mem;
}
