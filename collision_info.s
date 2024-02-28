#define COLLISION_TYPE_NONE 0
#define COLLISION_TYPE_FATAL 1
#define COLLISION_TYPE_BLACK_HOLE 2
#define COLLISION_TYPE_ERASER 3

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; getCollisionInfo: returns the type of collision, if any, for a point
; in the offscreen maze data.
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
    bpl playerDead

    txa
    cmp #BLACK_HOLE_TOP_LEFT_CHAR_CODE
    bcc noBlackHole
    cmp #BLACK_HOLE_BOTTOM_RIGHT_CHAR_CODE+1
    bcs noBlackHole
    lda #COLLISION_TYPE_BLACK_HOLE
    sta temp_result
    lda #SOUND_EFFECT_ERASER
    sta _sound_effect_id
    jsr triggerSoundEffect
    rts

    noBlackHole
    txa 
    cmp #ERASER_CHAR_CODE
    bne done
    lda #COLLISION_TYPE_ERASER
    sta temp_result
    lda #SOUND_EFFECT_BLACK_HOLE
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
