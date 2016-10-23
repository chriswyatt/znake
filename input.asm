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

; Check for input from Kempston joystick port

    ld a,(last_input)
    ld b,a

    in a,(0x1f)
    and 0x0f
    ld c,a

    cp b
    ret z

    ld (last_input),a

    or a
    jp po,kempston_joy_hv

; Kempston diagonal

    jp po,kempston_joy_hv

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

; Deal with queuing horizontal/vertical direction requests
kempston_joy_hv:

    ld a,e
    or a
    jr z,queue_empty
    jp po,queue_one

    ; If 2 directions in queue, use the higher bits, as these contain the last
    ; requested direction

    rrca
    rrca
    rrca
    rrca
    and 0x0f

    jp queue_one

queue_empty:

    ld a,d

queue_one:

    cp 0x04
    jr nc,last_req_v

; Last requested direction is horizontal

    ; Bitmask for vertical directions
    ld a,c
    and 0x0c
    ret z

    jp kempston_joy_hv_part_2

last_req_v:

    ; Bitmask for horizontal directions
    ld a,c
    and 0x03
    ret z

kempston_joy_hv_part_2:

    ld a,e

    ; If queue contains 0 or 2 directions, replace
    or a
    jp pe,replace_direction_queue

    ; Otherwise append

    ld a,c
    rlca
    rlca
    rlca
    rlca
    and 0xf0
    or e
    ld e,a

    jp save_direction_queue

replace_direction_queue:

    ld e,c

save_direction_queue:

    ld a,e
    ld (snake_direction_queue),a
    ret
