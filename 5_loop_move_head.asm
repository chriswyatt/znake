; /////////////////////////////////////////////////////////////////////////////

; Znake (ZX Spectrum 48K)

; -----------------------------------------------------------------------------
; 5_loop_move_head.asm
; -----------------------------------------------------------------------------

; Copyright (C) 2016, Chris Wyatt

; All rights reserved

; Distributed under the Apache 2 license (see LICENSE)

; /////////////////////////////////////////////////////////////////////////////

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

    ; Load head location to register b
    ld b,e

    ; Depending on the current direction, the new head location may be placed
    ; to the top or to the bottom ...

    bit 2,d
    jr nz,head_turning_left_down

    bit 3,d
    jr nz,head_turning_left_up

    ; Low bit of graphics
    ld c,0x30

    ; Draw later
    push bc

    ; ... otherwise the head is still moving right

    ; Get head location again and shift it left
    ld a,b
    sub 0x10

    ; Update the existing head location in our table
    ld (hl),a

    ; Push new head location back to b register
    ld b,a

    ; Low bit of graphics
    ld c,0x20

    ; Draw later
    push bc

    jp check_food_eaten

head_turning_left_down:

    ; Low bit of graphics
    ld c,0x38

    ; Draw later
    push bc

    ; Get head location again and shift it down
    inc b

    ; Low bit of graphics
    ld c,0x18

    ; Draw later
    push bc

    ; Move pointer to new head location
    inc l

    ; Add new head location to our table
    ld (hl),b

    ld a,(snake_history_head_offset)
    inc a
    ld (snake_history_head_offset),a

    jp check_food_eaten

head_turning_left_up:

    ; Low bit of graphics
    ld c,0x40

    ; Draw later
    push bc

    ; Get head location again and shift it up
    dec b

    ; Low bit of graphics
    ld c,0x08

    ; Draw later
    push bc

    ; Move pointer to new head location
    inc l

    ; Set new head location up 1 from previous head
    ld (hl),b

    ; Because the snake has turned:
    ld a,(snake_history_head_offset)
    inc a
    ld (snake_history_head_offset),a

    jp check_food_eaten

head_moving_right:

    ; Load head location to register b
    ld b,e

    ; Depending on the current direction, the new head location may be placed
    ; to the top or to the bottom ...

    bit 2,d
    jr nz,head_turning_right_down

    bit 3,d
    jr nz,head_turning_right_up

    ; Low bit of graphics
    ld c,0x30

    ; Draw later
    push bc

    ; ... otherwise the head is still moving right

    ; Get head location again and shift it right
    ld a,b
    add a,0x10

    ; Update the existing head location in our table
    ld (hl),a

    ; Push new head location back to b register
    ld b,a

    ; Low bit of graphics
    ld c,0x10

    ; Draw later
    push bc

    jp check_food_eaten

head_turning_right_down:

    ; Low bit of graphics
    ld c,0x50

    ; Draw later
    push bc

    ; Get head location again and shift it down
    inc b

    ; Low bit of graphics
    ld c,0x18

    ; Draw later
    push bc

    ; Move pointer to new head location
    inc l

    ; Add new head location to our table
    ld (hl),b

    ; Because the snake has turned:
    ld a,(snake_history_head_offset)
    inc a
    ld (snake_history_head_offset),a

    jp check_food_eaten

head_turning_right_up:

    ; Low bit of graphics
    ld c,0x48

    ; Draw later
    push bc

    ; Get head location again and shift it up
    dec b

    ; Low bit of graphics
    ld c,0x08

    ; Draw later
    push bc

    ; Move pointer to new head location
    inc l

    ; Add new head location to our table
    ld (hl),b

    ld a,(snake_history_head_offset)
    inc a
    ld (snake_history_head_offset),a

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

    ; Load head location to register b
    ld b,e

    ; Depending on the current direction, the new head location may be placed
    ; to the right or to the left ...

    bit 0,d
    jr nz,head_turning_up_right

    bit 1,d
    jr nz,head_turning_up_left

    ; Low bit of graphics
    ld c,0x28

    ; Draw later
    push bc

    ; ... otherwise the head is still moving up

    ; Get head location again and shift it up
    dec b

    ; Low bit of graphics
    ld c,0x08

    ; Draw later
    push bc

    ; Update the existing head location in our table
    ld (hl),b

    jp check_food_eaten

head_turning_up_right:

    ; Low bit of graphics
    ld c,0x38

    ; Draw later
    push bc

    ; Get head location again and shift it right
    ld a,b
    add a,0x10

    ; Push new head location back to b register
    ld b,a

    ; Low bit of graphics
    ld c,0x10

    ; Draw later
    push bc

    ; Move pointer to new head location
    inc l

    ; Add new head location to our table
    ld (hl),a

    ld a,(snake_history_head_offset)
    inc a
    ld (snake_history_head_offset),a

    jp check_food_eaten

head_turning_up_left:

    ; Low bit of graphics
    ld c,0x50

    ; Draw later
    push bc

    ; Get head location again and shift it left
    ld a,b
    sub 0x10

    ; Push new head location back to b register
    ld b,a

    ; Low bit of graphics
    ld c,0x20

    ; Draw later
    push bc

    ; Move pointer to new head location
    inc l

    ; Add new head location to our table
    ld (hl),a

    ld a,(snake_history_head_offset)
    inc a
    ld (snake_history_head_offset),a

    jp check_food_eaten

head_moving_down:

    ; Load head location to register b
    ld b,e

    ; Depending on the current direction, the new head location may be placed
    ; to the right or to the left ...

    bit 0,d
    jr nz,head_turning_down_right

    bit 1,d
    jr nz,head_turning_down_left

    ; Low bit of graphics
    ld c,0x28

    ; Draw later
    push bc

    ; ... otherwise the head is still moving up

    ; Get head location again and shift it down
    inc b

    ; Low bit of graphics
    ld c,0x18

    ; Draw later
    push bc

    ; Update the existing head location in our table
    ld (hl),b

    jp check_food_eaten

head_turning_down_right:

    ; Low bit of graphics
    ld c,0x40

    ; Draw later
    push bc

    ; Get head location again and shift it right
    ld a,b
    add a,0x10

    ; Push new head location back to b register
    ld b,a

    ; Low bit of graphics
    ld c,0x10

    ; Draw later
    push bc

    ; Move pointer to new head location
    inc l

    ; Add new head location to our table
    ld (hl),a

    ld a,(snake_history_head_offset)
    inc a
    ld (snake_history_head_offset),a

    jp check_food_eaten

head_turning_down_left:

    ; Low bit of graphics
    ld c,0x48

    ; Draw later
    push bc

    ; Get head location again and shift it left
    ld a,b
    sub 0x10

    ; Push new head location back to b register
    ld b,a

    ; Low bit of graphics
    ld c,0x20

    ; Draw later
    push bc

    ; Move pointer to new head location
    inc l

    ; Add new head location to our table
    ld (hl),a

    ld a,(snake_history_head_offset)
    inc a
    ld (snake_history_head_offset),a

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
