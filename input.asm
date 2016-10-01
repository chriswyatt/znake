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

    in a,(0x1f)
    and 0x0f

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

    ; Horizontal/vertical logic relies on last queued direction(s)

    ; Get last direction(s)
    ld a,e
    or a
    jr z,direction_not_queued

    ; Otherwise, direction queued
    ld b,a
    jp read_kempston_hv

direction_not_queued:

    ld b,d

; Check for horizontal/vertical input from Kempston joystick port
read_kempston_hv:

    in a,(0x1f)

    bit 3,a ; up
    jr nz,kempston_joy_up
    bit 0,a ; right
    jr nz,kempston_joy_right
    bit 2,a ; down
    jr nz,kempston_joy_down
    bit 1,a ; left
    jr nz,kempston_joy_left

    ; If no bits are on, make sure that only one direction is queued;
    ; otherwise the snake may veer off in an unintended direction

    ld a,e
    or a

    ; If queue contains 1 direction, jump to next input loop
    ret po

    ; If queue is empty, jump to next input loop
    ret z

    ; Otherwise only keep the highest priority direction
    ld a,e
    and 0x0f
    ld e,a

    jp save_direction_queue

; The following bitmasks could also allow the opposite directions too, e.g.
; if the bitmask is left, it could also accept right. This would make the
; controls more sensitive at the expense of accidentally turning the snake
; in an unintentional direction. This also helps with the ZX Vega D-pad's
; tendency to lean in a diagonal direction, when the user intended a
; horizontal/vertical direction. We could consider allowing this to be user
; configurable.

kempston_joy_up_right:

    ; If current direction is left
    bit 1,d
    jr nz,queue_up_right

    ; If current direction is down
    bit 2,d
    jr nz,queue_right_up

    ; Else ignore
    ret

kempston_joy_down_right:

    ; If current direction is left
    bit 1,d
    jr nz,queue_down_right

    ; If current direction is up
    bit 3,d
    jr nz,queue_right_down

    ; Else ignore
    ret

kempston_joy_down_left:

    ; If current direction is right
    bit 0,d
    jr nz,queue_down_left

    ; If current direction is up
    bit 3,d
    jr nz,queue_left_down

    ; Else ignore
    ret

kempston_joy_up_left:

    ; If current direction is right
    bit 0,d
    jr nz,queue_up_left

    ; If current direction is down
    bit 2,d
    jr nz,queue_left_up

    ; Else ignore
    ret

queue_up_right:

    ld e,0x18

    jp save_direction_queue

queue_right_up:

    ld e,0x81

    jp save_direction_queue

queue_right_down:

    ld e,0x41

    jp save_direction_queue

queue_down_right:

    ld e,0x14

    jp save_direction_queue

queue_down_left:

    ld e,0x24

    jp save_direction_queue

queue_left_down:

    ld e,0x42

    jp save_direction_queue

queue_left_up:

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
    ld a,b

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