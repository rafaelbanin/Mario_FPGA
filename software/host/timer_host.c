#include "hw/timer.h"
#include <SDL.h>

static uint32_t tick_ms;

void timer_init(void)
{
    tick_ms = 0;
}

uint32_t timer_millis(void)
{
    return tick_ms;
}

void timer_delay_ms(uint32_t ms)
{
    tick_ms += ms;
    SDL_Delay(ms);
}

void timer_tick_isr(void)
{
    tick_ms++;
}
