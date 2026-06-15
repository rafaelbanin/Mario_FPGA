#include <SDL.h>
#include <stdio.h>
#include <stdint.h>

#include "game.h"
#include "input.h"
#include "host/framebuffer_host.h"
#include "host/keys_host.h"
#include "host/palette.h"
#include "hw/framebuffer.h"
#include "hw/keys.h"
#include "hw/timer.h"

#define SCALE       2
#define WIN_W       (FB_WIDTH * SCALE)
#define WIN_H       (FB_HEIGHT * SCALE)
#define FRAME_MS    16

static void blit_framebuffer(SDL_Renderer *renderer, SDL_Texture *texture)
{
    const uint8_t *fb = host_framebuffer_ptr();
    uint32_t pixels[FB_WIDTH * FB_HEIGHT];
    uint32_t i;

    for (i = 0; i < FB_PIXELS; i++)
        pixels[i] = palette_rgb[fb[i] & 0x0Fu] | 0xFF000000u;

    SDL_UpdateTexture(texture, NULL, pixels, FB_WIDTH * (int)sizeof(uint32_t));
    SDL_RenderClear(renderer);
    SDL_RenderCopy(renderer, texture, NULL, NULL);
    SDL_RenderPresent(renderer);
}

static uint8_t poll_keys(void)
{
    SDL_Event event;
    const uint8_t *kbd;
    uint8_t pressed = 0;

    while (SDL_PollEvent(&event)) {
        if (event.type == SDL_QUIT)
            return 0xFF;
        if (event.type == SDL_KEYDOWN && event.key.keysym.sym == SDLK_ESCAPE)
            return 0xFF;
    }

    kbd = SDL_GetKeyboardState(NULL);
    if (kbd[SDL_GetScancodeFromKey(SDLK_LEFT)] || kbd[SDL_GetScancodeFromKey(SDLK_a)])
        pressed |= KEY_LEFT;
    if (kbd[SDL_GetScancodeFromKey(SDLK_RIGHT)] || kbd[SDL_GetScancodeFromKey(SDLK_d)])
        pressed |= KEY_RIGHT;
    if (kbd[SDL_GetScancodeFromKey(SDLK_SPACE)] || kbd[SDL_GetScancodeFromKey(SDLK_UP)] ||
        kbd[SDL_GetScancodeFromKey(SDLK_w)])
        pressed |= KEY_JUMP;
    if (kbd[SDL_GetScancodeFromKey(SDLK_r)])
        pressed |= KEY_RESET;

    return pressed;
}

int main(int argc, char *argv[])
{
    SDL_Window *window;
    SDL_Renderer *renderer;
    SDL_Texture *texture;
    InputState input = {0};
    uint8_t keys;

    (void)argc;
    (void)argv;

    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        fprintf(stderr, "SDL_Init failed: %s\n", SDL_GetError());
        return 1;
    }

    window = SDL_CreateWindow(
        "Super Mario DE10 - Simulador PC",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        WIN_W, WIN_H, SDL_WINDOW_SHOWN);
    if (!window) {
        fprintf(stderr, "SDL_CreateWindow failed: %s\n", SDL_GetError());
        return 1;
    }

    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
    texture = SDL_CreateTexture(
        renderer, SDL_PIXELFORMAT_ARGB8888,
        SDL_TEXTUREACCESS_STREAMING, FB_WIDTH, FB_HEIGHT);

    timer_init();
    game_init();

    printf("Controles: A/Left=esquerda  D/Right=direita  Space/W/Up=pular  R=reset  Esc=sair\n");

    for (;;) {
        keys = poll_keys();
        if (keys == 0xFF)
            break;

        host_keys_set(keys);
        input_poll(&input);
        game_update(&input);
        game_render();
        blit_framebuffer(renderer, texture);
        timer_delay_ms(FRAME_MS);
    }

    SDL_DestroyTexture(texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}
