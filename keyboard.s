#define        via_portb               $0300 
#define        via_porta               $030f
#define        via_pcr                 $030c 

values_code .byt $df,$7f,$f7,$bf,$fe,$ef,$fd,$fb
    
    

:ReadKeyboard
.(

    ; save all registers
    pha
    txa
    pha
    tya
    pha

    lda #00
    sta _gKey

    ; Select the bottom row of the keyboard
    ldy #04
    sty via_portb

    ldx #7
loop_read
brk

    ; Write Column Register Number to PortA
    ldy #$0e
    sty via_porta

    ; Tell AY this is Register Number
    ldy #$ff
    sty via_pcr

    ; Clear CB2, as keeping it high hangs on some orics.
    ; Pitty, as all this code could be run only once, otherwise
    ldy #$dd
    sty via_pcr

    ; Write to Column Register 
    lda values_code,x
    sta via_porta
    lda #$fd
    sta via_pcr
    sty via_pcr

    lda via_portb
    and #08
    beq key_not_pressed

    lda values_code,x
    eor #$ff
    ora _gKey 
    sta _gKey

key_not_pressed    
    dex
    bpl loop_read
    
    ;restore all registers
    pla
    tay
    pla
    txa
    pla
    
    rts
.)





