; /////////////////////////////////////////////////////////////////////////////

; Znake (ZX Spectrum 48K)

; -----------------------------------------------------------------------------
; 5_loop_move_head.asm
; -----------------------------------------------------------------------------

; Copyright (C) 2016, Chris Wyatt

; All rights reserved

; Distributed under the Apache 2 license (see LICENSE)

; /////////////////////////////////////////////////////////////////////////////

macro move_head_hv, direction

    ; Load head location to register b
    ld b,e

    ; Depending on the current direction, the new head location may be placed
    ; to the right or to the left ...

    if direction = 0x08
        bit 0,d
        jr nz,head_turning_up_right

        bit 1,d
        jr nz,head_turning_up_left
    endif
    if direction = 0x04
        bit 0,d
        jr nz,head_turning_down_right

        bit 1,d
        jr nz,head_turning_down_left
    endif
    if direction = 0x02
        bit 2,d
        jr nz,head_turning_left_down

        bit 3,d
        jr nz,head_turning_left_up
    endif
    if direction = 0x01
        bit 2,d
        jr nz,head_turning_right_down

        bit 3,d
        jr nz,head_turning_right_up
    endif

    ; Low bit of neck graphics
    if direction = 0x08 || direction = 0x04
        ld c,0x28
    endif
    if direction = 0x02 || direction = 0x01
        ld c,0x30
    endif

    ; Draw later
    push bc

    ; ... otherwise the head is still moving vertically

    ; Get head location again and ...
    if direction = 0x08
        ; shift it up
        dec b
    endif
    if direction = 0x04
        ; shift it down
        inc b
    endif
    if direction = 0x02
        ; shift it left
        ld a,b
        sub 0x10
        ld b,a
    endif
    if direction = 0x01
        ; shift it right
        ld a,b
        add a,0x10
        ld b,a
    endif

    ; Low bit of head graphics
    if direction = 0x08
        ld c,0x08
    endif
    if direction = 0x04
        ld c,0x18
    endif
    if direction = 0x02
        ld c,0x20
    endif
    if direction = 0x01
        ld c,0x10
    endif

    ; Draw later
    push bc

    ; Update the existing head location in our table
    ld (hl),b

endm

macro turn_head, prev_direction, new_direction

    ; Low bit of neck graphics
    if prev_direction = 0x08
        if new_direction = 0x02
            ld c,0x50
        endif
        if new_direction = 0x01
            ld c,0x38
        endif
    endif
    if prev_direction = 0x04
        if new_direction = 0x02
            ld c,0x48
        endif
        if new_direction = 0x01
            ld c,0x40
        endif

    endif
    if prev_direction = 0x02
        if new_direction = 0x08
            ld c,0x40
        endif
        if new_direction = 0x04
            ld c,0x38
        endif

    endif
    if prev_direction = 0x01
        if new_direction = 0x08
            ld c,0x48
        endif
        if new_direction = 0x04
            ld c,0x50
        endif
    endif

    ; Draw later
    push bc

    ; Move head
    if prev_direction = 0x08 || prev_direction = 0x04
        ld a,b
        if new_direction = 0x02
            sub 0x10
        endif
        if new_direction = 0x01
            add a,0x10
        endif
        ld b,a
    endif
    if prev_direction = 0x02 || prev_direction = 0x01
        if new_direction = 0x08
            dec b
        endif
        if new_direction = 0x04
            inc b
        endif
    endif

    ; Low bit of head graphics
    if prev_direction = 0x08 || prev_direction = 0x04
        if new_direction = 0x02
            ld c,0x20
        endif
        if new_direction = 0x01
            ld c,0x10
        endif
    endif
    if prev_direction = 0x02 || prev_direction = 0x01
        if new_direction = 0x08
            ld c,0x08
        endif
        if new_direction = 0x04
            ld c,0x18
        endif
    endif

    ; Draw later
    push bc

    ; Move pointer to new head location
    inc l

    ; Add new head location to our table
    ld (hl),b

    ld a,(snake_history_head_offset)
    inc a
    ld (snake_history_head_offset),a

endm

update_head_history:

    ld h,(TBL_SNAKE_HISTORY >> 8) & $FF

    ; Move pointer to end of snake history
    ld a,(snake_history_head_offset)
    ld l,a

    ; Load current head location to register e
    ld e,(hl)

    ; Move pointer to turn (or tail) before head
    dec l

    ; Load current turn location to register b
    ld b,(hl)

    ; Move pointer back to head
    inc l

    ; Subtract turn location from head location

    ld a,e
    xor b
    cp 0x10
    jp c,head_moving_vertically

    ; Head moving horizontally

    ; Restore head location
    xor b

    and 0xf0
    ld c,a
    ld a,b
    and 0xf0
    sub c
    jr c,head_moving_right

; Head moving left

    move_head_hv 0x02

    jp check_food_eaten

head_turning_left_down:

    turn_head 0x02, 0x04

    jp check_food_eaten

head_turning_left_up:

    turn_head 0x02, 0x08

    jp check_food_eaten

head_moving_right:

    move_head_hv 0x01

    jp check_food_eaten

head_turning_right_down:

    turn_head 0x01, 0x04

    jp check_food_eaten

head_turning_right_up:

    turn_head 0x01, 0x08

    jp check_food_eaten

head_moving_vertically:

    ; Restore head location
    xor b

    and 0x0f
    ld c,a
    ld a,b
    and 0x0f
    sub c
    jr c,head_moving_down

; Head moving up

    move_head_hv 0x08

    jp check_food_eaten

head_turning_up_right:

    turn_head 0x08, 0x01

    jp check_food_eaten

head_turning_up_left:

    turn_head 0x08, 0x02

    jp check_food_eaten

head_moving_down:

    move_head_hv 0x04

    jp check_food_eaten

head_turning_down_right:

    turn_head 0x04, 0x01

    jp check_food_eaten

head_turning_down_left:

    turn_head 0x04, 0x02

check_food_eaten:

    ld a,(current_food_location)
    cp (hl)

    ; If location of head does not equal current food location, continue to
    ; update tail history routine
    jr nz,update_tail_history

    ; Otherwise, set food eaten flag ...
    ld hl,flags
    set 0,(hl)

    ; Record snake length increase
    ld hl,snake_length
    inc (hl)

    ; Increase score by 10

    ld hl,score

    ld a,10
    add a,(hl)
    daa
    ld (hl),a

    inc hl

    ld a,0
    adc a,(hl)
    daa
    ld (hl),a

    dec hl ; hl = hi_score
    ld de,str_score
    call gen_score_str

    ; Skip tail update (i.e. grow snake)
    jp collision_detection
