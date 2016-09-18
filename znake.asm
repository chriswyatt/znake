; /////////////////////////////////////////////////////////////////////////////

; Znake (ZX Spectrum 48K)

; -----------------------------------------------------------------------------
; main.asm
; -----------------------------------------------------------------------------

; Copyright (C) 2016, Chris Wyatt

; All rights reserved

; Distributed under the Apache 2 license (see LICENSE)

; /////////////////////////////////////////////////////////////////////////////

include const.asm

org 0x8000

include vars.asm

org 0x8080

include im2_routine.asm

org 0x8100

include graphics.asm

include utils.asm

include draw.asm

include find_free_space.asm

include input.asm

include score.asm

start:

include 0_init.asm

include 1_menu.asm

include 2_game_init.asm

include 3_loop_create_food.asm

include 4_loop_input.asm

include 5_loop_move_head.asm

include 6_loop_move_tail.asm

include 7_loop_collision_detection.asm

include 8_loop_draw_graphics.asm

end start
