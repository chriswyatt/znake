; /////////////////////////////////////////////////////////////////////////////

; Znake (ZX Spectrum 48K)

; -----------------------------------------------------------------------------
; vars.asm
; -----------------------------------------------------------------------------

; Copyright (C) 2016, Chris Wyatt

; All rights reserved

; Distributed under the Apache 2 license (see LICENSE)

; /////////////////////////////////////////////////////////////////////////////

menu_last_direction: db 0x00
menu_last_direction_frame_count: db 0x00

str_easier: db "Boring\0"
str_easy:   db " Easy \0"
str_medium: db "Normal\0"
str_hard:   db " Hard \0"
str_harder: db "Insane\0"

str_score_lbl: db "Sc:\0"
str_hi_score_lbl: db "Hi:\0"

difficulty: db 0x02

; string, display location, snake speed
difficulties:

    dw str_easier
    dw 0x0c07
    db 32

    dw str_easy
    dw 0x0c09
    db 16

    dw str_medium
    dw 0x0c0b
    db 8

    dw str_hard
    dw 0x0c0d
    db 4

    dw str_harder
    dw 0x0c0f
    db 2

; Starting offset for snake history
snake_history_tail_offset: db 0x00

; End offset for snake history
snake_history_head_offset: db 0x00

; The length of the clean snake history table (byte per item)
snake_history_clean_length: db 0x00

; The length of both free squares tables (byte per item)
free_squares_bl_length: db 0x00
free_squares_br_length: db 0x00
free_squares_tr_length: db 0x00
free_squares_tl_length: db 0x00

; Low byte of current free squares table
free_squares_low: db 0x00

; Pointer to current free squares table length
free_squares_length_pointer: dw 0x0000

; Current direction of snake (bits: 0000UDLR)
snake_direction_current: db 0x00

; Snake direction queue (bits: UDLRUDLR)
; (low bits have higher priority)
snake_direction_queue: db 0x00

; The current location of the snake's food
current_food_location: db 0x00

; Bit 0: Food eaten
; Bit 1: Reserved
; Bit 2: Reserved
; Bit 3: Reserved
; Bit 4: Invalidate BL free squares table
; Bit 5: Invalidate BR free squares table
; Bit 6: Invalidate TR free squares table
; Bit 7: Invalidate TL free squares table
flags: db 0x00

previous_frame_count: db 0x00

; i.e. snake speed (higher = slower)
no_of_frames_per_update: db 0x00

; Calculating this from snake history would be too expensive
snake_length: db 0

seed: defw 0x0000

; BCD
score: dw 0x0000

str_score db "    \0"

; BCD
hi_score: dw 0x0000

str_hi_score db "0000\0"
