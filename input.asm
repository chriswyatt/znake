; /////////////////////////////////////////////////////////////////////////////

; Znake (ZX Spectrum 48K)

; -----------------------------------------------------------------------------
; input.asm
; -----------------------------------------------------------------------------

; Copyright (C) 2016, Chris Wyatt

; All rights reserved

; Distributed under the Apache 2 license (see LICENSE)

; /////////////////////////////////////////////////////////////////////////////

check_input:

    ld a,(snake_direction_current)
    ld d,a

    ld a,(snake_direction_queue)
    ld e,a

; Check for diagonal input from Kempston joystick port
read_kempston_d:

    ld a,(last_input)
    ld b,a

    in a,(0x1f)
    and 0x0f
    ld c,a

    ld (last_input),a

    ; Filter out high bits that have not changed from the last input
    xor b
    and c

    jp po,read_kempston_hv

    ; up-right (bits 0 and 3)
    cp 0x09
    jr z,kempston_joy_up_right

    ; down-right (bits 0 and 2)
    cp 0x05
    jr z,kempston_joy_down_right

    ; down-left (bits 1 and 2)
    cp 0x06
    jr z,kempston_joy_down_left

    ; up-left (bits 1 and 3)
    cp 0x0a
    jr z,kempston_joy_up_left

read_kempston_hv:

    ; Horizontal/vertical logic relies on last queued direction(s)

    ; Get last direction(s)
    ld a,e
    or a
    jr z,direction_not_queued

    ; Otherwise, direction queued
    ld c,a
    jp direction_queued

direction_not_queued:

    ld c,d

; Check for horizontal/vertical input from Kempston joystick port
direction_queued:

    in a,(0x1f)

    cp 0x08 ; up
    jr z,kempston_joy_up

    cp 0x04 ; down
    jr z,kempston_joy_down

    cp 0x02 ; left
    jr z,kempston_joy_left

    cp 0x01 ; right
    jr z,kempston_joy_right

    ; Restore last input
    ld a,b
    ld (last_input),a

    ret

kempston_joy_up_right:

    ; If current direction is left/right
    ld a,d
    and 0x03
    jr nz,queue_up_right

    ; Else, current direction is up/down

; Queue right-up

    ld e,0x81

    jp save_direction_queue

queue_up_right:

    ld e,0x18

    jp save_direction_queue

kempston_joy_down_right:

    ; If current direction is left/right
    ld a,d
    and 0x03
    jr nz,queue_down_right

    ; Else, current direction is up/down

; Queue right-down

    ld e,0x41

    jp save_direction_queue

queue_down_right:

    ld e,0x14

    jp save_direction_queue

kempston_joy_down_left:

    ; If current direction is left/right
    ld a,d
    and 0x03
    jr nz,queue_down_left

    ; Else, current direction is up/down

; Queue left-down

    ld e,0x42

    jp save_direction_queue

queue_down_left:

    ld e,0x24

    jp save_direction_queue

kempston_joy_up_left:

    ; If current direction is left/right
    ld a,d
    and 0x03
    jr nz,queue_up_left

    ; Else, current direction is up/down

; Queue left-up

    ld e,0x82

    jp save_direction_queue

queue_up_left:

    ld e,0x28

    jp save_direction_queue

kempston_joy_up:

    ; Direction requested, bitmask for left and right
    ld hl,0x0803

    jp kempston_joy_hv

kempston_joy_right:

    ; Direction requested, bitmask for up and down
    ld hl,0x010c

    jp kempston_joy_hv

kempston_joy_down:

    ; Direction requested, bitmask for left and right
    ld hl,0x0403

    jp kempston_joy_hv

kempston_joy_left:

    ; Direction requested, bitmask for up and down
    ld hl,0x020c

; Deal with queuing horizontal/vertical direction requests
kempston_joy_hv:

    ; Load last requested direction into accumulator
    ld a,c

    ; If 0 or 1 last requested directions, jump

    or a
    jp po,kempston_joy_hv_part_2
    jr z,kempston_joy_hv_part_2

    ; Otherwise, use the higher bits, as these contain the last requested
    ; direction

    rrca
    rrca
    rrca
    rrca
    and 0x0f

kempston_joy_hv_part_2:

    ; If last direction requested is not in bitmask, ignore
    and l
    jr z,save_direction_queue

    ld a,e

    ; If queue contains 0 or 2 directions, replace
    or a
    jp pe,replace_direction_queue

    ; Otherwise append

    ld a,h
    rlca
    rlca
    rlca
    rlca
    and 0xf0
    or e
    ld e,a

    jp save_direction_queue

replace_direction_queue:

    ld e,h

save_direction_queue:

    ld a,e
    ld (snake_direction_queue),a
    ret