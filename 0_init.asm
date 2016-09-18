; /////////////////////////////////////////////////////////////////////////////

; Znake (ZX Spectrum 48K)

; -----------------------------------------------------------------------------
; 0_init.asm
; -----------------------------------------------------------------------------

; Copyright (C) 2016, Chris Wyatt

; All rights reserved

; Distributed under the Apache 2 license (see LICENSE)

; /////////////////////////////////////////////////////////////////////////////

di

ld hl,0xfe00

; Load high byte of pointer table to interrupt vector register
ld a,h
ld i,a

; Load 257 interrupt routine pointers to memory
ld de,0xfe01
ld bc,256
ld (hl),0x80
ldir

; Initialise IM2 interrupt routine
im 2
ei

jp menu_start
