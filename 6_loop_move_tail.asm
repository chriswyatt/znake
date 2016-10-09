; /////////////////////////////////////////////////////////////////////////////

; Znake (ZX Spectrum 48K)

; -----------------------------------------------------------------------------
; 6_loop_move_tail.asm
; -----------------------------------------------------------------------------

; Copyright (C) 2016, Chris Wyatt

; All rights reserved

; Distributed under the Apache 2 license (see LICENSE)

; /////////////////////////////////////////////////////////////////////////////

update_tail_history:

    ; Move pointer to start of snake history
    ld h,(TBL_SNAKE_HISTORY >> 8) & $FF
    ld a,(snake_history_tail_offset)
    ld l,a

    ; Load current tail location to register b
    ld d,(hl)

    ; Low bit of graphics (blank)
    ld e,0x00

    ; Draw later
    push de

    ; Move pointer to turn (or head) before tail
    inc l

    ; Load current turn location to register e
    ld e,(hl)

    ld a,e

    xor d
    cp 0x10
    jr c,tail_moving_vertically

    ; Tail moving horizontally

    ; Restore current turn location
    xor d

    and 0xf0
    ld c,a
    ld a,d
    and 0xf0
    sub c
    jr c,tail_moving_right
    jp tail_moving_left

tail_moving_vertically:

    ; Restore current turn location
    xor d

    and 0x0f
    ld c,a
    ld a,d
    and 0x0f
    sub c
    jr c,tail_moving_down

macro move_tail, chop_comparitor, graphics_low_addr, direction

    cp chop_comparitor
    jr z,chop_off_tail

    if direction = 0x08
        ; Shift location up
        dec d
    endif
    if direction = 0x04
        ; Shift location down
        inc d
    endif
    if direction = 0x02
        ; Get tail location again and shift it left
        ld a,d
        sub 0x10
        ld d,a
    endif
    if direction = 0x01
        ; Get tail location again and shift it right
        ld a,d
        add a,0x10
        ld d,a
    endif

    ; Low bit of graphics
    ld e,graphics_low_addr

    ; Draw later
    push de

    ; Move pointer back to tail
    dec l

    ; And update the existing tail location in our table
    ld (hl),d

endm

; Tail moving up

    move_tail 0x01, 0x68, 0x08

    jp collision_detection

tail_moving_right:

    move_tail 0xf0, 0x70, 0x01

    jp collision_detection

tail_moving_left:

    move_tail 0x10, 0x60, 0x02

    jp collision_detection

tail_moving_down:

    move_tail 0xff, 0x58, 0x04

    jp collision_detection

chop_off_tail:

    ; Remove the reference to the old tail, and let the next turn in the
    ; snake's body be the new tail
    ld a,(snake_history_tail_offset)
    inc a
    ld (snake_history_tail_offset),a

    ; Load new tail location to register d
    ld d,e

    ; Move pointer to the turn after the new tail
    inc l

    ; Load current turn location to register e
    ld e,(hl)

    ld a,e

    xor d
    cp 16
    jr c,new_tail_moving_vertically

    ; New tail moving horizontally

    ; Restore current turn location
    xor d

    and 0xf0
    ld e,a
    ld a,d
    and 0xf0
    sub e
    jr c,new_tail_moving_right
    jp new_tail_moving_left

new_tail_moving_vertically:

    ; Restore current turn location
    xor d

    and 0x0f
    ld e,a
    ld a,d
    and 0x0f
    sub e
    jr c,new_tail_moving_down

; New tail moving up

    ; Low bit of graphics
    ld e,0x68

    ; Draw later
    push de

    jp collision_detection

new_tail_moving_right:

    ; Low bit of graphics
    ld e,0x70

    ; Draw later
    push de

    jp collision_detection

new_tail_moving_down:

    ; Low bit of graphics
    ld e,0x58

    ; Draw later
    push de

    jp collision_detection

new_tail_moving_left:

    ; Low bit of graphics
    ld e,0x60

    ; Draw later
    push de