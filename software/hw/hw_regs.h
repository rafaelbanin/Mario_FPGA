#ifndef HW_REGS_H
#define HW_REGS_H

#include <stdint.h>

#define LW_BRIDGE_BASE        0xFF200000u
#define FB_BASE               (LW_BRIDGE_BASE + 0x0000u)
#define KEY_PIO_BASE          (LW_BRIDGE_BASE + 0x0010u)

#define FB_REG_ADDR           0x00u
#define FB_REG_COLOR          0x04u
#define FB_REG_STATUS         0x08u

#define KEY_REG_DATA          0x00u

#define HPS_PERIPH_BASE       0xFFC00000u
#define SP_TIMER0_BASE        (HPS_PERIPH_BASE + 0x2000u)

static inline void mmio_write32(uint32_t addr, uint32_t val)
{
    *(volatile uint32_t *)addr = val;
}

static inline uint32_t mmio_read32(uint32_t addr)
{
    return *(volatile uint32_t *)addr;
}

#endif
