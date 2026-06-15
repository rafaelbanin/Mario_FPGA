cmake_minimum_required(VERSION 3.16)
project(supermario_host C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

find_package(SDL2 REQUIRED)

set(GAME_SRCS
    game.c
    physics.c
    collision.c
    camera.c
    input.c
    render.c
    tiles.c
    tile_gfx_table.c
    sprites.c
    gfx.c
    world.c
    enemy.c
)

set(HOST_SRCS
    host/main_host.c
    host/framebuffer_host.c
    host/keys_host.c
    host/timer_host.c
)

add_executable(supermario_host ${GAME_SRCS} ${HOST_SRCS})

target_include_directories(supermario_host PRIVATE . host)

if(TARGET SDL2::SDL2)
    target_link_libraries(supermario_host PRIVATE SDL2::SDL2)
else()
    target_include_directories(supermario_host PRIVATE ${SDL2_INCLUDE_DIRS})
    target_link_libraries(supermario_host PRIVATE ${SDL2_LIBRARIES})
endif()

target_compile_options(supermario_host PRIVATE -Wall -Wextra)
