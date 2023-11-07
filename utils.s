; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Print a message on the status line at the top of the screen
; ------------------------------------------------------------------------------
printStatusMessage
    jsr clearStatusLine
    ldy 0
    :loadMessageLoop    
    lda $ffff,Y
    beq messagePrinted
    sta $bb82,y
    iny
    jmp loadMessageLoop
    messagePrinted
    rts
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Clear text from the status line at the top of the screen
; ------------------------------------------------------------------------------
clearStatusLine
    ldy #0                      
    lda #32
.(
Loop
    cpy #38 ;
    beq ExitClear                        
    sta $BB82,Y                     
    iny                             
    jmp Loop
    ExitClear 
    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Perform a short delay (currently used to slow to down the game a bit)
; ------------------------------------------------------------------------------
smallDelay
.(
    txa
    pha
    ldx #$10

    outer_loop
    
    ; a small delay
    ldy #255
    loop
    dey
    nop
    cpy #00
    Bne loop
    dex
    cpx #00 
    bpl outer_loop

    pla
    tax
    rts    
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<




; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Perform a big delay (currently used to wait a while before restarting the game
; ------------------------------------------------------------------------------
bigDelay
.(
    txa
    pha
    ldx #$ff

    outer_loop
    
    ; a small delay
    ldy #255
    loop
    dey
    nop
    cpy #00
    Bne loop
    dex
    cpx #00 
    bne outer_loop

    pla
    tax
    rts    
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;// Taken from Kong source code 
;// Calculate some RANDOM values
;// Not accurate at all, but who cares ?
;// For what I need it's enough.
; ------------------------------------------------------------------------------
_GetRand
	lda rand_high
	sta b_tmp1
	lda rand_low
	asl 
	rol b_tmp1
	asl 
	rol b_tmp1
	asl
	rol b_tmp1
	asl
	rol b_tmp1
	clc
	adc rand_low
	pha
	lda b_tmp1
	adc rand_high
	sta rand_high
	pla
	adc #$11
	sta rand_low
	lda rand_high
	adc #$36
	sta rand_high
	rts
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    
