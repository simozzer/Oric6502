; disable music playback on channel 3 and the noise channel 
; so that we can play a sound effect on those whilst the music runs
triggerSoundEffect
.(
    sei
    jsr copySoundParams
    jsr silenceForEffect
    jsr restoreSoundParams

    lda _sound_effect_id
    cmp #SOUND_EFFECT_ERASER
    bne n1
    lda #SOUND_EFFECT_LENGTH_ERASER
    sta _sound_effect_cycles_remaining

    n1 
    cmp #SOUND_EFFECT_BLACK_HOLE
    bne n2
    lda #SOUND_EFFECT_LENGTH_BLACK_HOLE
    sta _sound_effect_cycles_remaining

    n2
    cmp #SOUND_EFFECT_DEATH
    bne n3
    lda #SOUND_EFFECT_LENGTH_DEATH
    sta _sound_effect_cycles_remaining

    n3 
    cmp #03
    bne done
    lda #16
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
    sta PARAMS_5
    sta PARAMS_7
    jsr independentMusic

    ;silence noise
    jsr WipeParams
    lda #06
    sta PARAMS_1
    lda #00
    sta PARAMS_3
    lda #00
    sta PARAMS_5
    jsr independentSound

    jsr WipeParams
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
    cmp #SOUND_EFFECT_ERASER
    beq p1
    cmp #SOUND_EFFECT_BLACK_HOLE
    beq p2
    cmp #SOUND_EFFECT_DEATH
    beq p3
    cmp #03
    beq p4
    rts

    p1
    jsr playSoundEffectEraser
    rts

    p2
    jsr playSoundEffectBlackHole
    rts

    p3 
    jsr playSoundEffectDeath
    rts

    p4
    jsr playSoundEffect4
.)

playSoundEffectEraser
.(
    lda _sound_effect_cycles_remaining
    cmp #01
    bne play
    jsr silenceForEffect
    rts
    play

    jsr WipeParams
    lda #03
    sta PARAMS_1
    lda _sound_effect_cycles_remaining
    asl
    clc
    adc #150
    sta PARAMS_3
    lda #10
    sta PARAMS_5
    jsr independentSound


    jsr WipeParams
    lda #06
    sta PARAMS_1;
    lda _sound_effect_cycles_remaining
    sta PARAMS_3
    lda #8
    sta PARAMS_5
    jsr independentSound

    lda #7
    sta PARAMS_1
    lda #4
    sta PARAMS_3
    lda #0
    sta PARAMS_5
    sta PARAMS_7
    jsr independentPlay
    rts
.)



playSoundEffectBlackHole
.(
    lda _sound_effect_cycles_remaining
    cmp #01
    bne play
    jsr silenceForEffect
    rts
    play

    jsr WipeParams
    lda #03
    sta PARAMS_1
    lda #200
    clc
    sbc _sound_effect_cycles_remaining
    asl
    sta PARAMS_3
    lda #10
    sta PARAMS_5
    jsr independentSound


    jsr WipeParams
    lda #06
    sta PARAMS_1;
    lda #15
    clc
    sbc _sound_effect_cycles_remaining
    sta PARAMS_3
    lda #8
    sta PARAMS_5
    jsr independentSound

    lda #7
    sta PARAMS_1
    lda #4
    sta PARAMS_3
    lda #0
    sta PARAMS_5
    sta PARAMS_7
    jsr independentPlay
    rts
.)


// similar to explode
playSoundEffectDeath
.(
    lda _sound_effect_cycles_remaining
    cmp #01
    bne play
    jsr silenceForEffect
    rts
    play
    jsr WipeParams
    lda #06
    sta PARAMS_1;
    jsr _GetRand
    lda rand_low
    sta PARAMS_3
    lda _sound_effect_cycles_remaining
    lsr
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

playSoundEffect4 
.(
    lda _sound_effect_cycles_remaining
    cmp #01
    bne play
    jsr silenceForEffect
    rts
    play

    jsr WipeParams
    lda #03
    sta PARAMS_1
    lda _sound_effect_cycles_remaining
    asl
    sta PARAMS_3
    lda #8
    sta PARAMS_5
    jsr independentSound

    lda #06
    sta PARAMS_1
    lda #00
    sta PARAMS_3
    sta PARAMS_5
    jsr independentSound

        
    jsr WipeParams
    lda #7
    sta PARAMS_1
    lda #0
    sta PARAMS_3
    lda #0
    sta PARAMS_5
    lda #0
    sta PARAMS_7
    jsr independentPlay
    rts
.)
