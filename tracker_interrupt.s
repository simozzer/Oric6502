setupTrackerInterrupt

    lda #0
    sta _tracker_step_index;
    lda #TRACKER_STEP_LENGTH
    sta _tracker_step_cycles_remaining;
    sta _tracker_step_length;
  
    sei

    lda #<trackerInterrupt
    sta INTSL+1
    lda #>trackerInterrupt
    sta INTSL+2 

    lda #$4c
    sta INTSL
    
    cli
    rts
  


trackerInterrupt
.(

    ; store registers
    pha
    txa
    pha
    tya
    pha

    clc
    lda _tracker_step_cycles_remaining
    cmp _tracker_step_length
    beq playNextStep
    jmp countDown

    playNextStep
        lda _tracker_step_index;
        adc #32
        sta $bbac

        
    :countDown
        dec _tracker_step_cycles_remaining
        lda _tracker_step_cycles_remaining
        cmp #00 
        beq loadNextStep
        jmp continue

    loadNextStep    
        lda _tracker_step_length
        sta _tracker_step_cycles_remaining
        inc _tracker_step_index;
        lda _tracker_step_index;
        cmp #64
        beq resetSequence
        jmp continue

    resetSequence
        lda #0
        sta _tracker_step_index
        lda _tracker_step_length
        sta _tracker_step_cycles_remaining
continue
    ;restore reg
    pla
    tay
    pla
    tax
    pla

    rti
.)