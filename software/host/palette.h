#ifndef PALETTE_H
#define PALETTE_H

#include <stdint.h>

/* RGB888 matching software/palette.h indices */
static const uint32_t palette_rgb[16] = {
    0x000000, /* 0 transparent/black */
    0x000000, /* 1 black */
    0x5C94FC, /* 2 sky */
    0x0000BC, /* 3 mario blue */
    0xFC0000, /* 4 red */
    0xFCFC00, /* 5 yellow */
    0x00B800, /* 6 green light */
    0xFCB800, /* 7 goomba tan */
    0xB82800, /* 8 brown dark */
    0xFC9838, /* 9 ground orange */
    0xFCB800, /* A brick light */
    0xB82800, /* B brick dark */
    0xFCFCFC, /* C white */
    0x00A800, /* D pipe green */
    0xFCBC98, /* E skin */
    0x00FCFC  /* F reserved */
};

#endif
