; disable music playback on channel 3 and the noise channel 
; so that we can play a sound effect on those whilst the music runs
triggerSoundEffect
.(
    sei
    jsr copySoundParams
    jsr silenceForEffect
    jsr restoreSoundParams

    lda _sound_effect_id
    cmp #00
    bne n1
    lda #31
    sta _sound_effect_cycles_remaining

    n1 
    cmp #01
    bne n2
    lda #62
    sta _sound_effect_cycles_remaining

    n2
    cmp #02
    bne done
    lda #40
    sta _sound_effect_cycles_remaining

    done
    cli
    rts
.)


silenceForEffect
; silence channel 3
    jsr WipeParams
    lda #03
    sta PARAMS_1
    lda #00
    sta PARAMS_3
    sta PARAMS_7
    lda #01
    sta PARAMS_5
    jsr independentMusic

    ;silence noise
    lda #7
    sta PARAMS_1
    lda #0
    sta PARAMS_3
    sta PARAMS_5
    sta PARAMS_7
    jsr independentPlay
rts

playSoundEffects
.(
    lda _sound_effect_id
    cmp #00
    beq p1
    cmp #01
    beq p2
    cmp #02
    beq p3
    rts

    p1
    jsr playSoundEffect1
    rts

    p2
    jsr playSoundEffect2
    rts

    p3 
    jsr playSoundEffect3
    rts
.)

playSoundEffect1
.(
    lda _sound_effect_cycles_remaining
    cmp #01
    bne play
    jsr silenceForEffect
    rts
    play

    lda #03
    sta PARAMS_1
    lda #255
    clc
    sbc _sound_effect_cycles_remaining
    sta PARAMS_3
    lda _sound_effect_cycles_remaining
    lsr
    sta PARAMS_5
    jsr independentSound

    lda #06
    sta PARAMS_1;
    lda _sound_effect_cycles_remaining
    sta PARAMS_3
    lsr
    lsr
    lda #10
    sta PARAMS_5
    jsr independentSound

    lda #7
    sta PARAMS_1
    lda #4
    sta PARAMS_3
    lda #0
    sta PARAMS_5
    lda #0
    sta PARAMS_7
    jsr independentPlay
    rts
.)


playSoundEffect2
.(
    lda _sound_effect_cycles_remaining
    cmp #01
    bne play
    jsr silenceForEffect
    rts
    play
    lda #06
    sta PARAMS_1;
    clc

    lda _sound_effect_cycles_remaining
    cmp #32
    bpl secondHalf
    lda #31
    sbc _sound_effect_cycles_remaining
    jmp storeParam
    
    
    secondHalf
    lda _sound_effect_cycles_remaining

    :storeParam
    sta PARAMS_3
    lda _sound_effect_cycles_remaining
    lsr
    sta PARAMS_5
    jsr independentSound

    lda #7
    sta PARAMS_1
    lda #4
    sta PARAMS_3
    lda #0
    sta PARAMS_5
    lda #0
    sta PARAMS_7
    jsr independentPlay
    rts
.)



playSoundEffect3
.(
    lda _sound_effect_cycles_remaining
    cmp #01
    bne play
    jsr silenceForEffect
    rts
    play
    lda #06
    sta PARAMS_1;
    jsr _GetRand
    lda rand_low
    sta PARAMS_3
    lda #10
    sta PARAMS_5
    jsr independentSound

    lda #7
    sta PARAMS_1
    lda #4
    sta PARAMS_3
    lda #0
    sta PARAMS_5
    lda #0
    sta PARAMS_7
    jsr independentPlay
    rts
.)
