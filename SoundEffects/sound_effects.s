; lookup table for lengths of each sound effect
_sound_effect_lengths 
    .byt SOUND_EFFECT_LENGTH_ERASER
    .byt SOUND_EFFECT_LENGTH_BLACK_HOLE
    .byt SOUND_EFFECT_LENGTH_DEATH
    .byt SOUND_EFFECT_LENGTH_SLOW_RISE
    .byt SOUND_EFFECT_LENGTH_MEDIUM_RISE
    .byt SOUND_EFFECT_LENGTH_FAST_RISE
    .byt SOUND_EFFECT_LENGTH_BLIP_RISE
    .byt SOUND_EFFECT_LENGTH_SLOW_FALL
    .byt SOUND_EFFECT_LENGTH_MEDIUM_FALL
    .byt SOUND_EFFECT_LENGTH_FAST_FALL
    .byt SOUND_EFFECT_LENGTH_BLIP_FALL

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; triggerSoundEffect: start a sound effect running by setting the
; _sound_effect_cycles_remaining to an appropriate length
; for the specified sound effect.
; Params: _sound_effect_id - the id of the effect to be triggered
; Returns: null
; -------------------------------------------------------------------
triggerSoundEffect
.(
    ; disable the interrupt handler which might be running music or doing something with the sound
    sei

    ; Make a copy of any parameters that might be being used for sound
    jsr copySoundParams
    
    ; disable music playback on channel 3 and the noise channel 
    ; so that we can play a sound effect on those whilst the music runs
    jsr silenceForEffect
    
    ; restore any previously established sound parameters
    jsr restoreSoundParams

    ; lookup the length for the triggered sound, from the table above, 
    ; and store value in _sound_effect_cycles_remaining
    ldy _sound_effect_id
    lda _sound_effect_lengths,Y
    sta _sound_effect_cycles_remaining

    :done

    ; reenable the interupt handler
    cli
    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; silenceForEffect: silence tone channel 3 and noise channel, 
; as music may be playing. This will free up the channels for playing 
; a sound effect
; Params: none
; Returns: null
; -------------------------------------------------------------------
silenceForEffect
.(
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
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; lookup table for jumps to the sound effect routines
_sound_effect_routines
    .word playSoundEffectEraser
    .word playSoundEffectBlackHole
    .word playSoundEffectDeath
    .word playSoundEffectSlowRise
    .word playSoundEffectMediumRise 
    .word playSoundEffectFastRise
    .word playSoundEffectBlipRise
    .word playSoundEffectSlowFall
    .word playSoundEffectMediumFall
    .word playSoundEffectFastFall
    .word playSoundEffectBlipFall



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; playSoundEffects: jump to the appopriate routine to play a section
; of a specified sound effect
; Params: _sound_effect_id - the id of the sound effect to be 
; executed
; Returns: null
; -------------------------------------------------------------------
playSoundEffects
.(
    lda _sound_effect_id
    asl
    tay
    lda _sound_effect_routines,y
    sta jumpToSoundEffect+1
    iny
    lda _sound_effect_routines,Y
    sta jumpToSoundEffect+2
    :jumpToSoundEffect   
    jsr $ffff; This value is self modified
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
    lda #6
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