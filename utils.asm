; /////////////////////////////////////////////////////////////////////////////

; Znake (ZX Spectrum 48K)

; -----------------------------------------------------------------------------
; utils.asm
; -----------------------------------------------------------------------------

; Copyright (C) 2016, Chris Wyatt

; All rights reserved

; Distributed under the Apache 2 license (see LICENSE)

; /////////////////////////////////////////////////////////////////////////////

random:

; Simple pseudo-random number generator.
; Steps a pointer through the ROM (held in seed), returning
; the contents of the byte at that location

; Modifies registers af and hl

; (Lifted from How to Write ZX Spectrum Games 1.0 by Jonathan Cauldwell)

    ld hl,(seed)

    ; Keep it within first 8k of ROM.
    ld a,h
    and 31
    ld h,a

    ld a,(hl)

    inc hl
    ld (seed),hl

    ret

modulo:

    ; Modifies registers af and bc

    ; Return if divisor = 0
    ld a,c
    or a
    ret z

    ld a,b

modulo_sub:

    sub c

    jr nc,modulo_sub

    add a,c
    ret

print_next:

    inc hl
    inc d

print:

    ld a,(hl)
    or a
    cp 0
    ret z

    push hl
    push de

print_char:

    ld b,3

    ld h,0
    ld l,a

print_multiply:

    add hl,hl
    djnz print_multiply

    ex de,hl

    ld hl,0x3d00 - (8 * 0x20)
    add hl,de
    pop de
    push de
    call draw_char
    pop de
    pop hl
    jp print_next