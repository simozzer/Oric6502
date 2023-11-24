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

    ; store registers (push a, x, y)
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


        jsr WipeParams;

        ldy _tracker_step_index;

        lda trackerMusicDataLo,Y
        sta _playback_music_info_byte_lo
        lda trackerMusicDataHi,Y
        sta _playback_music_info_byte_hi

        ; TEST - print something to represent step index
        lda _tracker_step_index
        adc #32
        sta $bbaa
        ; end test

        // extract notes from both channels and send the appopriate music instructions

        // --- start channel 1 ---
        ; fixed channel
        lda #01
        sta PARAMS_1

        ldy #0 ; Load 1st byte of line
        lda (_playback_music_info_byte_addr),y
        tax ; store value to later extract octave

        ; extract note
        and #$0f
        sta PARAMS_5 ; store note param

        ; extract octave
        txa
        and #$f0  
        clc      
        lsr
        lsr
        lsr
        lsr
        sta PARAMS_3

        ;extract volume
        ldy #1 ;; load 2nd byte of line
        lda (_playback_music_info_byte_addr),y
        tax ; store value to later extract length
        and #$f0
        lsr
        lsr
        lsr
        lsr
        sta PARAMS_7

        ; extract length
        ;tax
       ; and #$f0
        ; TODO -- store length
        
        jsr MUSIC_ATMOS ; call MUSIC

        // --- start channel 2 ---
        ; fixed channel
        jsr WipeParams
        lda #02
        sta PARAMS_1

        ldy #2 ; Load 1st byte of line
        lda (_playback_music_info_byte_addr),y
        tax ; store value to later extract octave

        ; extract note
        clc
        and #$0f
        sta PARAMS_5 ; store note param

        ; extract octave
        txa
        and #$f0        
        lsr
        lsr
        lsr
        lsr
        sta PARAMS_3

        ;extract volume
        ldy #3 ;; load 2nd byte of line
        lda (_playback_music_info_byte_addr),y
        tax ; store value to later extract length
        and #$f0
        lsr
        lsr
        lsr
        lsr
        sta PARAMS_7

        ; extract length
        ;tax
        ;and #$f0

        jsr MUSIC_ATMOS



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
        cmp #16
        beq resetSequence
        jmp continue

    resetSequence
        lda #0
        sta _tracker_step_index
        lda _tracker_step_length
        sta _tracker_step_cycles_remaining
continue
    ;restore reg (pull y,x,a)
    pla
    tay
    pla
    tax
    pla

    rti
.)


clearSound
.(
    jsr WipeParams
    lda #01
    sta PARAMS_1
    sta PARAMS_3
    sta PARAMS_5
    lda #00
    lda PARAMS_7
    JSR MUSIC_ATMOS

jsr WipeParams
    lda #02
    sta PARAMS_1
    lda #01
    sta PARAMS_3
    sta PARAMS_5
    lda #00
    lda PARAMS_7
    JSR MUSIC_ATMOS

jsr WipeParams
    lda #03
    sta PARAMS_1
    lda #01
    sta PARAMS_3
    sta PARAMS_5
    lda #00
    lda PARAMS_7
    JSR MUSIC_ATMOS

jsr WipeParams
    lda #07
    sta PARAMS_1
    lda #00
    sta PARAMS_3
    lda #01
    sta PARAMS_5
    lda #100
    sta PARAMS_7
    ; call play
    JSR $FBd0

    rts
.)