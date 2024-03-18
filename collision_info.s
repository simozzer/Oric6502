#define COLLISION_TYPE_NONE 0
#define COLLISION_TYPE_FATAL 1
#define COLLISION_TYPE_BLACK_HOLE 2
#define COLLISION_TYPE_ERASER 3
#define COLLISION_TYPE_SLOW 4
#define COLLISION_TYPE_RIGHT_ARROW 5
#define COLLISION_TYPE_LEFT_ARROW 6
#define COLLISION_TYPE_UP_ARROW 7
#define COLLISION_TYPE_DOWN_ARROW 8
#define COLLISION_TYPE_FAST 9

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; getCollisionInfo: returns the type of collision, if any, for a point
; in the offscreen maze data. Also triggers the sound effect when 
; a collision occurs.
; Params: 
;   temp_param_0: x position
;   temp_param_1: y position
; Returns:
;   temp_result: the type of collision that has occurred
; -------------------------------------------------------------------
getCollisionInfo
.(
    ; default result is no collision
    lda #COLLISION_TYPE_NONE
    sta temp_result

    ; lookup data for row
    ldy temp_param_1
    lda OffscreenLineLookupLo,y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,Y
    sta _maze_line_start_hi

    ; fetch char from column
    ldy temp_param_0
    lda (_maze_line_start),Y

    ; a should now contain the character for the x,y position;
    tax ;make a copy of the value 
    and #127
    cmp #(MAX_NON_FATAL_CHAR_CODE+1)
    bpl _playerDead
    jmp checkCollisions

    _playerDead
    jmp playerDead

    :checkCollisions
    txa
    cmp #BLACK_HOLE_TOP_LEFT_CHAR_CODE
    bcc noBlackHole
    cmp #BLACK_HOLE_BOTTOM_RIGHT_CHAR_CODE+1
    bcs noBlackHole
    lda #COLLISION_TYPE_BLACK_HOLE
    sta temp_result
    lda #SOUND_EFFECT_BLACK_HOLE
    sta _sound_effect_id
    jsr triggerSoundEffect
    rts

    noBlackHole
    txa 
    cmp #ERASER_CHAR_CODE
    bne noEraser
    lda #COLLISION_TYPE_ERASER
    sta temp_result
    lda #SOUND_EFFECT_ERASER
    sta _sound_effect_id
    jsr triggerSoundEffect
    rts

    noEraser
    txa
    cmp #SLOW_CHAR_CODE_LEFT
    bcc noSlow
    cmp #SLOW_CHAR_CODE_RIGHT+1
    bcs noSlow
    lda #COLLISION_TYPE_SLOW
    sta temp_result
    lda #SOUND_EFFECT_SLOW_FALL
    sta _sound_effect_id
    jsr triggerSoundEffect
    rts

    noSlow
    txa 
    cmp #RIGHT_ARROW_CHAR_CODE
    bne noRightArrow
    lda #COLLISION_TYPE_RIGHT_ARROW
    sta temp_result
    lda #SOUND_EFFECT_FAST_FALL
    sta _sound_effect_id
    jsr triggerSoundEffect
    rts

    noRightArrow
    txa 
    cmp #LEFT_ARROW_CHAR_CODE
    bne noLeftArrow
    lda #COLLISION_TYPE_LEFT_ARROW
    sta temp_result
    lda #SOUND_EFFECT_FAST_FALL
    sta _sound_effect_id
    jsr triggerSoundEffect
    rts

    noLeftArrow
    txa 
    cmp #UP_ARROW_CHAR_CODE
    bne noUpArrow
    lda #COLLISION_TYPE_UP_ARROW
    sta temp_result
    lda #SOUND_EFFECT_FAST_FALL
    sta _sound_effect_id
    jsr triggerSoundEffect
    rts

    noUpArrow
    txa 
    cmp #DOWN_ARROW_CHAR_CODE
    bne noDownArrow
    lda #COLLISION_TYPE_DOWN_ARROW
    sta temp_result
    lda #SOUND_EFFECT_FAST_FALL
    sta _sound_effect_id
    jsr triggerSoundEffect
    rts

    noDownArrow
    txa
    cmp #FAST_CHAR_CODE_LEFT
    bcc done
    cmp #FAST_CHAR_CODE_RIGHT+1
    bcs done
    lda #COLLISION_TYPE_FAST
    sta temp_result
    lda #SOUND_EFFECT_SLOW_RISE
    sta _sound_effect_id
    jsr triggerSoundEffect
    rts


    playerDead
    lda #SOUND_EFFECT_DEATH
    sta _sound_effect_id
    jsr triggerSoundEffect
    lda #COLLISION_TYPE_FATAL
    sta temp_result

    done
      rts

.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
