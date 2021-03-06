; /////////////////////////////////////////////////////////////////////////////

; Znake (ZX Spectrum 48K)

; -----------------------------------------------------------------------------
; 8_loop_draw_graphics.asm
; -----------------------------------------------------------------------------

; Copyright (C) 2016, Chris Wyatt

; All rights reserved

; Distributed under the Apache 2 license (see LICENSE)

; /////////////////////////////////////////////////////////////////////////////

update_graphics_init:

    ld hl,str_score
    ld de,0x0b02
    call print

    ; If food eaten flag is not set, loop 4 times to update grid locations:
    ; new head, existing head, new tail, existing tail (c = 5)

    ; Otherwise, draw current score and loop 2 times to update grid locations:
    ; new head, existing head (c = 3)

    ld a,(flags)
    cpl
    and 0x01
    add a,a
    add a,3
    ld c,a

    ld iy,draw_line

    halt

update_graphics_next:

    dec c
    jp z,next_game_loop

    pop hl

    ld b,0x0f

    ; Load x-coordinate into register d
    ld a,h
    rrca
    rrca
    rrca
    rrca
    and b
    add a,8
    ld d,a

    ; Load y-coordinate into register e
    ld a,h
    and b
    add a,4
    ld e,a

    ld h,0x81

    call draw_char

    jp update_graphics_next