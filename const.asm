; /////////////////////////////////////////////////////////////////////////////

; Znake (ZX Spectrum 48K)

; -----------------------------------------------------------------------------
; const.asm
; -----------------------------------------------------------------------------

; Copyright (C) 2016, Chris Wyatt

; All rights reserved

; Distributed under the Apache 2 license (see LICENSE)

; /////////////////////////////////////////////////////////////////////////////

; Every time the snake changes direction, the turning point location will
; be appended to the following table, and snake_history_head_offset (end)
; offset) will be incremented by 1

; Once the tail has completed a turn, the snake_history_tail_offset (start)
; will be incremented by 1

; Both tables are purposefully 256 bytes, so that the offsets will wrap
; around to 0 whenever they exceed 255. Also the play field is 16 x 16 and
; theoretically the snake could turn at every location in the grid;
; however, this is rather unlikely.

; Data that does not lie within start and end offset will remain in the
; table; there is no need to null it

; Initially the tables contain the snake's tail and head (in that order)

; The high byte contains the X coordinate, and the low byte contains the Y
; coordinate

TBL_SNAKE_HISTORY: EQU 0xfd00

; Note: The food routine relies on the following tables being consecutive and
;       in a specific order:

TBL_SNAKE_HISTORY_CLEAN: EQU 0xfa00

; The following tables hold the top-left and bottom-right coordinates of each
; free square: i.e., each square that does not contain any snake. This is
; required to be able to pick the location of new food

; Due to the algorithm that calculates free squares, it is impossible for there
; to be more than 192 squares required. In reality, this would be even less due
; to the snake not being able to chop itself into small pieces, but I have no
; idea how to calculate the actual space required.

; The high bytes contain the X coordinates, and the low bytes contain the Y
; coordinates

TBL_FREE_SQUARES_BL_TL_TABLE: EQU 0xfb00
TBL_FREE_SQUARES_BL_BR_TABLE: EQU 0xfc00

TBL_FREE_SQUARES_BR_TL_TABLE: EQU 0xfb30
TBL_FREE_SQUARES_BR_BR_TABLE: EQU 0xfc30

TBL_FREE_SQUARES_TR_TL_TABLE: EQU 0xfb60
TBL_FREE_SQUARES_TR_BR_TABLE: EQU 0xfc60

TBL_FREE_SQUARES_TL_TL_TABLE: EQU 0xfb90
TBL_FREE_SQUARES_TL_BR_TABLE: EQU 0xfc90

DIFFICULTIES_ROW_LENGTH: EQU 7
