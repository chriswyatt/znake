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

; Check for input from Kempston joystick port

    ld a,(last_input)
    ld b,a

    ; Map Q, A, O, P to Kempston bits: 000FUDLR

    ld a,0xfb ; 7 R E W Q
    in a,(0xfe)
    cpl
    rlca
    rlca
    rlca
    and 0x08
    ld c,a

    ld a,0xfd ; G F D S A
    in a,(0xfe)
    cpl
    rlca
    rlca
    and 0x04
    or c
    ld c,a

    ld a,0xdf ; Y U I O P
    in a,(0xfe)
    cpl
    and 0x03
    or c
    ld c,a

    ld hl,flags
    bit 1,(hl)
    jr z,skip_check_kempston_input

    in a,(0x1f)
    and 0x0f
    or c
    ld c,a

skip_check_kempston_input:

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

kempston_joy_up_left:

    ; If current direction is up
    bit 3,d
    jr nz,queue_left

    ; If current direction is down
    bit 2,d
    jr nz,queue_left_up

    ; If current direction is left
    bit 1,d
    jr nz,queue_up

    ; Current direction is right
    jp queue_up_left

kempston_joy_down_left:

    ; If current direction is up
    bit 3,d
    jr nz,queue_left_down

    ; If current direction is down
    bit 2,d
    jr nz,queue_left

    ; If current direction is left
    bit 1,d
    jr nz,queue_down

    ; Current direction is right
    jp queue_down_left

kempston_joy_down_right:

    ; If current direction is up
    bit 3,d
    jr nz,queue_right_down

    ; If current direction is down
    bit 2,d
    jr nz,queue_right

    ; If current direction is left
    bit 1,d
    jr nz,queue_down_right

    ; Current direction is right
    jp queue_down

kempston_joy_up_right:

    ; If current direction is up
    bit 3,d
    jr nz,queue_right

    ; If current direction is down
    bit 2,d
    jr nz,queue_right_up

    ; If current direction is left
    bit 1,d
    jr nz,queue_up_right

    ; Current direction is right

queue_up:

    ld a,0x08
    ld (snake_direction_queue),a
    ret

queue_down:

    ld a,0x04
    ld (snake_direction_queue),a
    ret

queue_left:

    ld a,0x02
    ld (snake_direction_queue),a
    ret

queue_right:

    ld a,0x01
    ld (snake_direction_queue),a
    ret

queue_up_left:

    ld a,0x28
    ld (snake_direction_queue),a
    ret

queue_up_right:

    ld a,0x18
    ld (snake_direction_queue),a
    ret

queue_down_left:

    ld a,0x24
    ld (snake_direction_queue),a
    ret

queue_down_right:

    ld a,0x14
    ld (snake_direction_queue),a
    ret

queue_left_up:

    ld a,0x82
    ld (snake_direction_queue),a
    ret

queue_left_down:

    ld a,0x42
    ld (snake_direction_queue),a
    ret

queue_right_up:

    ld a,0x81
    ld (snake_direction_queue),a
    ret

queue_right_down:

    ld a,0x41
    ld (snake_direction_queue),a
    ret

; Deal with queuing horizontal/vertical direction requests
kempston_joy_hv:

    ld a,(snake_direction_queue)
    ld e,a

    or a
    jp po,queue_one

    ; Use current direction as the next queued direction
    ld a,d

queue_one:

    cp 0x04
    jr nc,next_queued_v

; Next queued direction is horizontal

    ; Capture only vertical directions
    ld a,c
    and 0x0c
    ret z

    jp kempston_joy_v_check

next_queued_v:

    ; Capture only horizontal directions
    ld a,c
    and 0x03
    ret z

kempston_joy_h_check:

    ; If left and right pins are both on, return
    cp 0x03
    ret z

    jp check_queue

kempston_joy_v_check:

    ; If up and down pins are both on, return
    cp 0x0c
    ret z

check_queue:

    ld c,a
    ld a,e

    ; If queue contains 1 direction, append
    or a
    jp po,append_to_direction_queue

    ; Otherwise replace
    ld a,c
    ld (snake_direction_queue),a
    ret

append_to_direction_queue:

    ld a,c
    rlca
    rlca
    rlca
    rlca
    and 0xf0
    or e

    ld (snake_direction_queue),a
    ret
