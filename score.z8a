gen_score_str:

; Converts a BCD encoded score (word) to a fixed length, ASCII encoded score
; (double word)

; Modifies registers a, f, b, d, e

; de register pair must be set to the destination memory address (double word)

; hl register pair must be set to the memory address of the score
; (word, encoded as BCD, little endian)

    ld b,0x30

    inc hl

    ld a,(hl) ; score + 1
    and 0xf0
    rrca
    rrca
    rrca
    rrca
    add a,b ; 0x30
    ld (de),a ; str_score

    inc de

    ld a,(hl) ; score + 1
    and 0x0f
    add a,b ; 0x30
    ld (de),a ; str_score + 1

    dec hl
    inc de

    ld a,(hl) ; score
    and 0xf0
    rrca
    rrca
    rrca
    rrca
    add a,b ; 0x30
    ld (de),a ; str_score + 2

    inc de

    ld a,(hl) ; score
    and 0x0f
    add a,b ; 0x30
    ld (de),a ; str_score + 3

    ret
