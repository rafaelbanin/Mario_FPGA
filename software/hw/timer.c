#include "timer.h"
#include "hw_regs.h"

#define TIMER_LOAD_OFFSET  0x00u
#define TIMER_VALUE_OFFSET 0x04u
#define TIMER_CTRL_OFFSET  0x08u
#define TIMER_EOI_OFFSET   0x0Cu

#define TIMER_CTRL_EN      (1u << 0)
#define TIMER_CTRL_PERIOD  (1u << 1)

static uint32_t tick_ms;

void timer_init(void)
{
    tick_ms = 0;
    mmio_write32(SP_TIMER0_BASE + TIMER_LOAD_OFFSET, 0xFFFFFFFFu);
    mmio_write32(SP_TIMER0_BASE + TIMER_CTRL_OFFSET, TIMER_CTRL_EN | TIMER_CTRL_PERIOD);
}

uint32_t timer_millis(void)
{
    return tick_ms;
}

void timer_delay_ms(uint32_t ms)
{
    uint32_t start = tick_ms;
    while ((tick_ms - start) < ms) {
        /* Busy-wait calibrated for ~1ms steps at 60fps game loop */
    }
}

void timer_tick_isr(void)
{
    tick_ms++;
    mmio_read32(SP_TIMER0_BASE + TIMER_EOI_OFFSET);
}
