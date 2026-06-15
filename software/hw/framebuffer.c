#include "framebuffer.h"

void fb_init(void)
{
    fb_clear(0x02);
}

void fb_set_addr(uint32_t addr)
{
    mmio_write32(FB_BASE + FB_REG_ADDR, addr);
}

void fb_write_pixel(uint8_t color)
{
    mmio_write32(FB_BASE + FB_REG_COLOR, color & 0x0Fu);
}

void fb_write_at(uint16_t x, uint16_t y, uint8_t color)
{
    if (x >= FB_WIDTH || y >= FB_HEIGHT)
        return;
    fb_set_addr((uint32_t)y * FB_WIDTH + x);
    fb_write_pixel(color);
}

void fb_clear(uint8_t color)
{
    uint32_t i;
    fb_set_addr(0);
    for (i = 0; i < FB_PIXELS; i++)
        fb_write_pixel(color);
}

void fb_fill_rect(uint16_t x, uint16_t y, uint16_t w, uint16_t h, uint8_t color)
{
    uint16_t row, col;
    for (row = y; row < y + h && row < FB_HEIGHT; row++) {
        for (col = x; col < x + w && col < FB_WIDTH; col++)
            fb_write_at(col, row, color);
    }
}
