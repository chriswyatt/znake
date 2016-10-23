; /////////////////////////////////////////////////////////////////////////////

; Znake (ZX Spectrum 48K)

; -----------------------------------------------------------------------------
; 4_loop_input.asm
; -----------------------------------------------------------------------------

; Copyright (C) 2016, Chris Wyatt

; All rights reserved

; Distributed under the Apache 2 license (see LICENSE)

; /////////////////////////////////////////////////////////////////////////////

next_input_loop:

    call check_input

    ; If the current frame count is less than the previous frame count plus
    ; frame_wait, then continue input loop

    ld hl,previous_frame_count
    ld a,(23672)
    sub (hl)

    ; Snake speed (higher = slower)
    ld hl,no_of_frames_per_update
    sub (hl)

    jr c,next_input_loop

    ; Otherwise, move snake

    ; Store the new frame count
    ld a,(23672)
    ld (previous_frame_count),a

    ; Get highest priority direction
    ld a,(snake_direction_queue)
    ld b,a
    and 0x0f

    ; If no direction queued, continue moving snake in same direction

    jr z,update_head_history

    ; Otherwise, change snake direction

    ld (snake_direction_current),a

    ; Pop the new direction from the direction queue

    ld a,b
    rrca
    rrca
    rrca
    rrca
    and 0x0f
    ld (snake_direction_queue),a
