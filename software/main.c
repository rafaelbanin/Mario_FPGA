#include "game.h"
#include "input.h"
#include "hw/timer.h"

#define FRAME_MS 16

static volatile uint32_t frame_count;

int main(void)
{
    InputState input = {0};

    timer_init();
    game_init();

    while (1) {
        input_poll(&input);
        game_update(&input);
        game_render();
        frame_count++;
        timer_delay_ms(FRAME_MS);
    }
    return 0;
}
