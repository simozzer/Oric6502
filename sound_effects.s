; disable music playback on channel 3 and the noise channel 
; so that we can play a sound effect on those whilst the music runs
; TODO:: setting up the length would be better with a simple lookup table
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
    jmp done

    n2
    cmp #SOUND_EFFECT_DEATH
    bne n3
    lda #SOUND_EFFECT_LENGTH_DEATH
    sta _sound_effect_cycles_remaining
    jmp done

    n3 
    cmp #SOUND_EFFECT_SLOW_RISE
    bne n4
    lda #SOUND_EFFECT_LENGTH_SLOW_RISE
    sta _sound_effect_cycles_remaining
    jmp done

    n4 
    cmp #SOUND_EFFECT_MEDIUM_RISE
    bne n5
    lda #SOUND_EFFECT_LENGTH_MEDIUM_RISE
    sta _sound_effect_cycles_remaining
    jmp done

    n5
    cmp #SOUND_EFFECT_FAST_RISE
    bne n6
    lda #SOUND_EFFECT_LENGTH_FAST_RISE
    sta _sound_effect_cycles_remaining
    jmp done

    n6
    cmp #SOUND_EFFECT_BLIP_RISE
    bne n7
    lda #SOUND_EFFECT_LENGTH_BLIP_RISE
    sta _sound_effect_cycles_remaining
    jmp done

    n7 
    cmp #SOUND_EFFECT_SLOW_FALL
    bne n8
    lda #SOUND_EFFECT_LENGTH_SLOW_FALL
    sta _sound_effect_cycles_remaining
    jmp done

    n8
    cmp #SOUND_EFFECT_MEDIUM_FALL
    bne n9
    lda #SOUND_EFFECT_LENGTH_MEDIUM_FALL
    sta _sound_effect_cycles_remaining
    jmp done

    n9
    cmp #SOUND_EFFECT_FAST_FALL
    bne n10
    lda #SOUND_EFFECT_LENGTH_FAST_FALL
    sta _sound_effect_cycles_remaining
    jmp done

    n10
    cmp #SOUND_EFFECT_BLIP_FALL
    bne done
    lda #SOUND_EFFECT_LENGTH_BLIP_FALL
    sta _sound_effect_cycles_remaining

    :done
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
    cmp #SOUND_EFFECT_SLOW_RISE
    beq p4
    cmp #SOUND_EFFECT_MEDIUM_RISE
    beq p5
    cmp #SOUND_EFFECT_FAST_RISE
    beq p6
    cmp #SOUND_EFFECT_BLIP_RISE
    beq p7
    cmp #SOUND_EFFECT_SLOW_FALL
    beq p8
    cmp #SOUND_EFFECT_MEDIUM_FALL
    beq p9
    cmp #SOUND_EFFECT_FAST_FALL
    beq p10
    cmp #SOUND_EFFECT_BLIP_FALL
    beq p11
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
    jsr playSoundEffectSlowRise
    rts

    p5 
    jsr playSoundEffectMediumRise
    rts

    p6 
    jsr playSoundEffectFastRise
    rts

    p7
    jsr playSoundEffectBlipRise
    rts

    p8
    jsr playSoundEffectSlowFall
    rts

    p9 
    jsr playSoundEffectMediumFall
    rts

    p10 
    jsr playSoundEffectFastFall
    rts

    p11
    jsr playSoundEffectBlipFall
    rts
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

playSoundEffectSlowRise
.(
    lda _sound_effect_cycles_remaining
    cmp #01
    bne play
    jsr silenceForEffect

    ;silence noise
    jsr WipeParams
    lda #06
    sta PARAMS_1
    lda #00
    sta PARAMS_3
    sta PARAMS_5
    jsr independentSound
    rts

    play
    jsr WipeParams
    lda #03
    sta PARAMS_1
    ldy _sound_effect_cycles_remaining
    lda slidePitchData,y
    sta PARAMS_4
    sta PARAMS_3
    lda #12
    sta PARAMS_5
    jsr independentSound
    rts
.)


playSoundEffectMediumRise
.(
    lda _sound_effect_cycles_remaining
    cmp #01
    bne play
    jsr silenceForEffect

    ;silence noise
    jsr WipeParams
    lda #06
    sta PARAMS_1
    lda #00
    sta PARAMS_3
    sta PARAMS_5
    jsr independentSound
    rts

    play
    jsr WipeParams
    lda #03
    sta PARAMS_1
    lda _sound_effect_cycles_remaining
    asl
    tay
    lda slidePitchData,y
    sta PARAMS_4
    sta PARAMS_3
    lda #12
    sta PARAMS_5
    jsr independentSound
    rts
.)

playSoundEffectFastRise
.(
    lda _sound_effect_cycles_remaining
    cmp #01
    bne play
    jsr silenceForEffect

    ;silence noise
    jsr WipeParams
    lda #06
    sta PARAMS_1
    lda #00
    sta PARAMS_3
    sta PARAMS_5
    jsr independentSound
    rts

    play
    jsr WipeParams
    lda #03
    sta PARAMS_1
    lda _sound_effect_cycles_remaining
    asl
    asl
    tay
    lda slidePitchData,y
    sta PARAMS_4
    sta PARAMS_3
    lda #12
    sta PARAMS_5
    jsr independentSound
    rts
.)


playSoundEffectBlipRise
.(
    lda _sound_effect_cycles_remaining
    cmp #01
    bne play
    jsr silenceForEffect

    ;silence noise
    jsr WipeParams
    lda #06
    sta PARAMS_1
    lda #00
    sta PARAMS_3
    sta PARAMS_5
    jsr independentSound
    rts

    play
    jsr WipeParams
    lda #03
    sta PARAMS_1
    lda _sound_effect_cycles_remaining
    asl
    asl
    asl
    tay
    lda slidePitchData,y
    sta PARAMS_4
    sta PARAMS_3
    lda #12
    sta PARAMS_5
    jsr independentSound

    rts
.)

playSoundEffectSlowFall
.(
    lda _sound_effect_cycles_remaining
    cmp #01
    bne play
    jsr silenceForEffect

    ;silence noise
    jsr WipeParams
    lda #06
    sta PARAMS_1
    lda #00
    sta PARAMS_3
    sta PARAMS_5
    jsr independentSound
    rts

    play
    jsr WipeParams
    lda #03
    sta PARAMS_1
    clc
    lda #32
    sbc _sound_effect_cycles_remaining
    tay
    lda slidePitchData,y
    sta PARAMS_4
    sta PARAMS_3
    lda #12
    sta PARAMS_5
    jsr independentSound
    rts
.)


playSoundEffectMediumFall
.(
    lda _sound_effect_cycles_remaining
    cmp #01
    bne play
    jsr silenceForEffect

    ;silence noise
    jsr WipeParams
    lda #06
    sta PARAMS_1
    lda #00
    sta PARAMS_3
    sta PARAMS_5
    jsr independentSound
    rts

    play
    jsr WipeParams
    lda #03
    sta PARAMS_1
    clc
    lda #32
    sbc _sound_effect_cycles_remaining
    tay
    lda slidePitchData,y
    asl
    sta PARAMS_4
    sta PARAMS_3
    lda #12
    sta PARAMS_5
    jsr independentSound
    rts
.)


playSoundEffectFastFall
.(
    lda _sound_effect_cycles_remaining
    cmp #01
    bne play
    jsr silenceForEffect

    ;silence noise
    jsr WipeParams
    lda #06
    sta PARAMS_1
    lda #00
    sta PARAMS_3
    sta PARAMS_5
    jsr independentSound
    rts

    play
    jsr WipeParams
    lda #03
    sta PARAMS_1
    clc
    lda #32
    sbc _sound_effect_cycles_remaining
    tay
    lda slidePitchData,y
    asl
    asl
    sta PARAMS_4
    sta PARAMS_3
    lda #12
    sta PARAMS_5
    jsr independentSound
    rts
.)

playSoundEffectBlipFall
.(
    lda _sound_effect_cycles_remaining
    cmp #01
    bne play
    jsr silenceForEffect

    ;silence noise
    jsr WipeParams
    lda #06
    sta PARAMS_1
    lda #00
    sta PARAMS_3
    sta PARAMS_5
    jsr independentSound
    rts

    play
    jsr WipeParams
    lda #03
    sta PARAMS_1
    clc
    lda #32
    sbc _sound_effect_cycles_remaining
    tay
    lda slidePitchData,y
    asl
    asl
    asl
    sta PARAMS_4
    sta PARAMS_3
    lda #12
    sta PARAMS_5
    jsr independentSound
    rts
.)




:slidePitchData
.byt 16,24,32,40,48,56,64,72,80
.byt 88,96,104,112,120,128,136,144,152,160
.byt 168,176,184,192,200,208,216,224,232,240,248,255