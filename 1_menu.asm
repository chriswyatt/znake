; /////////////////////////////////////////////////////////////////////////////

; Znake (ZX Spectrum 48K)

; -----------------------------------------------------------------------------
; 1_menu.asm
; -----------------------------------------------------------------------------

; Copyright (C) 2016, Chris Wyatt

; All rights reserved

; Distributed under the Apache 2 license (see LICENSE)

; /////////////////////////////////////////////////////////////////////////////

select_difficulty_draw:

    ld b,6

select_difficulty_draw_next:

    push hl
    push de
    push bc
    call draw_char
    pop bc
    pop de
    pop hl
    inc d
    djnz select_difficulty_draw_next
    ret

select_difficulty:

    ld hl,difficulties
    ld de,DIFFICULTIES_ROW_LENGTH
    or a ; Reset carry flag
    sbc hl,de

select_difficulty_move_pointer:

    add hl,de
    djnz select_difficulty_move_pointer

    push hl
    pop ix

    ld d,(ix + 3)
    ld e,(ix + 2)

    ld hl,0x81c0

    call select_difficulty_draw
    ret

menu_start:

    ld a,(23672)
    ld (menu_last_direction_frame_count),a

    ; Set border color to black
    xor a ; a = 0
    call $229B

    ; Clear screen
    ld hl,0x4000
    ld de,0x4001
    ld bc,0x17ff
    ld (hl),0
    ldir

    ld hl,flags
    set 1,(hl)

    ld ix,difficulties
    ld iy,draw_line_xor

    ld h,(ix + 1)
    ld l,(ix)
    ld d,(ix + 3)
    ld e,(ix + 2)
    call print

    ld h,(ix + DIFFICULTIES_ROW_LENGTH + 1)
    ld l,(ix + DIFFICULTIES_ROW_LENGTH)
    ld d,(ix + DIFFICULTIES_ROW_LENGTH + 3)
    ld e,(ix + DIFFICULTIES_ROW_LENGTH + 2)
    call print

    ld h,(ix + DIFFICULTIES_ROW_LENGTH * 2 + 1)
    ld l,(ix + DIFFICULTIES_ROW_LENGTH * 2)
    ld d,(ix + DIFFICULTIES_ROW_LENGTH * 2 + 3)
    ld e,(ix + DIFFICULTIES_ROW_LENGTH * 2 + 2)
    call print

    ld h,(ix + DIFFICULTIES_ROW_LENGTH * 3 + 1)
    ld l,(ix + DIFFICULTIES_ROW_LENGTH * 3)
    ld d,(ix + DIFFICULTIES_ROW_LENGTH * 3 + 3)
    ld e,(ix + DIFFICULTIES_ROW_LENGTH * 3 + 2)
    call print

    ld h,(ix + DIFFICULTIES_ROW_LENGTH * 4 + 1)
    ld l,(ix + DIFFICULTIES_ROW_LENGTH * 4)
    ld d,(ix + DIFFICULTIES_ROW_LENGTH * 4 + 3)
    ld e,(ix + DIFFICULTIES_ROW_LENGTH * 4 + 2)
    call print

    ld a,(difficulty)
    inc a
    ld b,a

    ld de,DIFFICULTIES_ROW_LENGTH
    ld ix,difficulties - 5

select_difficulty_offset_increment:

    add ix,de

    djnz select_difficulty_offset_increment

    ld hl,0x81c0
    ld d,(ix + 1)
    ld e,(ix)
    call select_difficulty_draw

input_loop:

    ; Kempston
    in a,(0x1f)

    ; Only capture up/down/fire
    and 0x1c

    ld b,a

    ld hl,menu_last_direction
    cp (hl)

    jr nz,menu_change_direction

    ; Same direction

    bit 4,a
    jr nz,init

    ld a,(23672)
    ld hl,menu_last_direction_frame_count
    sub (hl)
    sub 20
    jr c,input_loop

menu_change_direction:

    ld a,b
    ld (menu_last_direction),a
    ld a,(23672)
    ld (menu_last_direction_frame_count),a

    ld hl,difficulty

    ld a,b

    bit 3,a
    jr nz,menu_kempston_joy_up

    bit 2,a
    jr nz,menu_kempston_joy_down

    jr input_loop

menu_kempston_joy_up:

    ld a,(hl)
    dec a
    jp p,unselect_current_difficulty

    ld a,4

    jp unselect_current_difficulty

menu_kempston_joy_down:

    ld a,(hl)
    inc a
    cp 5
    jr nz,unselect_current_difficulty

    xor a

unselect_current_difficulty:

    ld d,a

    push de

    ld b,(hl)
    inc b

    call select_difficulty

; Select new difficulty

    pop af

    ; Store new difficulty
    ld hl,difficulty
    ld (hl),a

    ld b,a
    inc b

    call select_difficulty

    jr input_loop
