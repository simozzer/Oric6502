

player1_data
_player1_id .dsb 1
_player1_x .dsb 1
_player1_y .dsb 1
_player1_direction .dsb 1
_player1_effect_type .dsb 1
_player1_effect_cycles_remaining .dsb 1
_player1_trail_data
_player1_trail_data_x
_player1_trail_data_x_lo .dsb 1
_player1_trail_data_x_hi .dsb 1
_player1_trail_data_y
_player1_trail_data_y_lo .dsb 1
_player1_trail_data_y_hi .dsb 1
_player1_trail_data_char
_player1_trail_data_char_lo .dsb 1
_player1_trail_data_char_hi .dsb 1
_player1_trail_index .dsb 1
_player1_char_code .dsb 1


player2_data
_player2_id .dsb 1
_player2_x .dsb 1
_player2_y .dsb 1
_player2_direction .dsb 1
_player2_effect_type .dsb 1
_player2_effect_cycles_remaining .dsb 1
_player2_trail_data
_player2_trail_data_x
_player2_trail_data_x_lo .dsb 1
_player2_trail_data_x_hi .dsb 1
_player2_trail_data_y
_player2_trail_data_y_lo .dsb 1
_player2_trail_data_y_hi .dsb 1
_player2_trail_data_char
_player2_trail_data_char_lo .dsb 1
_player2_trail_data_char_hi .dsb 1
_player2_trail_index .dsb 1
_player2_char_code .dsb 1


processKeyboardPlayer1
.(
    
    ldy key_left_player1_row
    lda _KeyMatrix,y
    beq nextKey0

    and key_left_player1_col_mask
    cmp key_left_player1_col_mask
    bne nextKey0
    lda _player1_direction
    cmp #PLAYER_DIRECTION_RIGHT
    beq nextKey0
    lda #PLAYER_DIRECTION_LEFT
    sta _player1_direction
    jsr _GetRand
    rts

    nextKey0
    ldy key_right_player1_row
    lda _KeyMatrix,y
    beq nextKey1
    and key_right_player1_col_mask
    cmp key_right_player1_col_mask
    bne nextKey1
    lda _player1_direction
    cmp #PLAYER_DIRECTION_LEFT
    beq nextKey1
    lda #PLAYER_DIRECTION_RIGHT
    sta _player1_direction   
    jsr _GetRand 
    rts

    nextKey1
    ldy key_down_player1_row
    lda _KeyMatrix,y
    and key_down_player1_col_mask
    cmp key_down_player1_col_mask
    bne nextKey2
    lda _player1_direction
    cmp #PLAYER_DIRECTION_UP
    beq nextKey2
    lda #PLAYER_DIRECTION_DOWN
    sta _player1_direction
    jsr _GetRand
    rts

    nextKey2
    ldy key_up_player1_row
    lda _KeyMatrix,y
    and key_up_player1_col_mask
    cmp key_up_player1_col_mask
    bne keyboardDone
    lda _player1_direction
    cmp #PLAYER_DIRECTION_DOWN
    beq keyboardDone
    lda #PLAYER_DIRECTION_UP
    sta _player1_direction
    jsr _GetRand

    keyboardDone
    rts
.)


processJoystickPlayer1
.(
    lda joy_Left
    beq done

    and #%00000001
    cmp #%00000001
    bne checkRight
    lda _player1_direction
    cmp #PLAYER_DIRECTION_RIGHT
    beq checkRight
    lda #PLAYER_DIRECTION_LEFT
    sta _player1_direction
    jsr _GetRand
    rts

    checkRight
    lda joy_Left
    and #%000000010
    cmp #%000000010
    bne checkDown
    lda _player1_direction
    cmp #PLAYER_DIRECTION_LEFT
    beq checkDown
    lda #PLAYER_DIRECTION_RIGHT
    sta _player1_direction   
    jsr _GetRand 
    rts

    checkDown
    lda joy_Left
    and #%000001000
    cmp #%000001000
    bne checkUp
    lda _player1_direction
    cmp #PLAYER_DIRECTION_UP
    beq checkUp
    lda #PLAYER_DIRECTION_DOWN
    sta _player1_direction
    jsr _GetRand
    rts

    checkUp
    lda joy_Left
    and #%000010000
    cmp #%000010000
    bne done
    lda _player1_direction
    cmp #PLAYER_DIRECTION_DOWN
    beq done
    lda #PLAYER_DIRECTION_UP
    sta _player1_direction
    jsr _GetRand

    done rts
.)


processKeyboardplayer2
.(
    
    ldy key_left_player2_row
    lda _KeyMatrix,y
    beq nextKey0

    and key_left_player2_col_mask
    cmp key_left_player2_col_mask
    bne nextKey0
    lda _player2_direction
    cmp #PLAYER_DIRECTION_RIGHT
    beq nextKey0
    lda #PLAYER_DIRECTION_LEFT
    sta _player2_direction
    jsr _GetRand
    rts

    nextKey0
    ldy key_right_player2_row
    lda _KeyMatrix,y
    beq nextKey1
    and key_right_player2_col_mask
    cmp key_right_player2_col_mask
    bne nextKey1
    lda _player2_direction
    cmp #PLAYER_DIRECTION_LEFT
    beq nextKey1
    lda #PLAYER_DIRECTION_RIGHT
    sta _player2_direction   
    jsr _GetRand 
    rts

    nextKey1
    ldy key_down_player2_row
    lda _KeyMatrix,y
    and key_down_player2_col_mask
    cmp key_down_player2_col_mask
    bne nextKey2
    lda _player2_direction
    cmp #PLAYER_DIRECTION_UP
    beq nextKey2
    lda #PLAYER_DIRECTION_DOWN
    sta _player2_direction
    jsr _GetRand
    rts

    nextKey2
    ldy key_up_player2_row
    lda _KeyMatrix,y
    and key_up_player2_col_mask
    cmp key_up_player2_col_mask
    bne keyboardDone
    lda _player2_direction
    cmp #PLAYER_DIRECTION_DOWN
    beq keyboardDone
    lda #PLAYER_DIRECTION_UP
    sta _player2_direction
    jsr _GetRand

    keyboardDone
    rts
.)

processJoystickPlayer2
.(
    lda joy_Right
    beq done

    and #%00000001
    cmp #%00000001
    bne checkRight
    lda _player2_direction
    cmp #PLAYER_DIRECTION_RIGHT
    beq checkRight
    lda #PLAYER_DIRECTION_LEFT
    sta _player2_direction
    jsr _GetRand
    rts

    checkRight
    lda joy_Right
    and #%000000010
    cmp #%000000010
    bne checkDown
    lda _player2_direction
    cmp #PLAYER_DIRECTION_LEFT
    beq checkDown
    lda #PLAYER_DIRECTION_RIGHT
    sta _player2_direction   
    jsr _GetRand 
    rts

    checkDown
    lda joy_Right
    and #%000001000
    cmp #%000001000
    bne checkUp
    lda _player2_direction
    cmp #PLAYER_DIRECTION_UP
    beq checkUp
    lda #PLAYER_DIRECTION_DOWN
    sta _player2_direction
    jsr _GetRand
    rts

    checkUp
    lda joy_Right
    and #%000010000
    cmp #%000010000
    bne done
    lda _player2_direction
    cmp #PLAYER_DIRECTION_DOWN
    beq done
    lda #PLAYER_DIRECTION_UP
    sta _player2_direction
    jsr _GetRand

    done rts
.)

updateMovement
.( 
    ldy #PLAYER_DATA_OFFSET_EFFECT_TYPE
    lda (_player_data),y
    beq doMove

    cmp #PLAYER_EFFECT_TYPE_SLOW
    beq processSlow1
    jmp doMove

    processSlow1
    ldy #PLAYER_DATA_OFFSET_CYCLES_REMAINING
    lda (_player_data),y
    sec
    sbc #01
    sta (_player_data),y
    beq stopSlow
    and #01
    cmp #01
    beq doMove
    rts

    stopSlow
    ldy #PLAYER_DATA_OFFSET_EFFECT_TYPE
    lda #PLAYER_EFFECT_TYPE_NONE
    sta (_player_data),y

    :doMove
    ldy #PLAYER_DATA_OFFSET_DIRECTION
    lda (_player_data),y
    cmp #PLAYER_DIRECTION_LEFT
    bne checkRight
    ldy #PLAYER_DATA_OFFSET_X
    lda (_player_data),y
    sec
    sbc #01
    sta (_player_data),y
    jmp renderPlayer

    :checkRight
    ldy #PLAYER_DATA_OFFSET_DIRECTION
    lda (_player_data),y
    cmp #PLAYER_DIRECTION_RIGHT
    bne checkUp
    ldy #PLAYER_DATA_OFFSET_X
    lda (_player_data),y
    clc
    adc #01
    sta (_player_data),y
    jmp renderPlayer

    :checkUp
    ldy #PLAYER_DATA_OFFSET_DIRECTION
    lda (_player_data),y
    cmp #PLAYER_DIRECTION_UP
    bne checkDown
    ldy #PLAYER_DATA_OFFSET_Y
    lda (_player_data),y
    sec
    sbc #01
    sta (_player_data),y
    jmp renderPlayer


    :checkDown
    ldy #PLAYER_DATA_OFFSET_DIRECTION
    lda (_player_data),y
    cmp #PLAYER_DIRECTION_DOWN
    beq movePlayerDown
    jmp checkDone
    movePlayerDown
    ldy #PLAYER_DATA_OFFSET_Y
    lda (_player_data),y
    clc
    adc #01
    sta (_player_data),y

    :renderPlayer
    ldy #PLAYER_DATA_OFFSET_Y
    lda (_player_data),y
    tay
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi

    ; check for collision with fatal object
    ldy #PLAYER_DATA_OFFSET_X
    lda (_player_data),y
    sta temp_param_0
    ldy #PLAYER_DATA_OFFSET_Y
    lda (_player_data),y
    sta temp_param_1
    jsr getCollisionInfo
    lda temp_result
    cmp #COLLISION_TYPE_FATAL
    bne checkBlackHole
    jmp playerDead


    checkBlackHole
    ; check for collision with black hole
    cmp #COLLISION_TYPE_BLACK_HOLE
    bne noBlackHole
    
    ;process black hole collision
    .(
    getX
        jsr _GetRand; get random x position
        lda rand_low;
        cmp #245
        bcs getX
        clc
        adc #05
        ldy #PLAYER_DATA_OFFSET_X
        sta (_player_data),y

        getY
        jsr _GetRand;
        lda rand_low;
        cmp #70
        bcs getY
        clc
        adc #05
        ldy #PLAYER_DATA_OFFSET_Y
        sta (_player_data),y
    .)

    noBlackHole
    ; check for collision with eraser
    cmp #COLLISION_TYPE_ERASER
    bne noEraser
    jsr eraseTrail
    ldy #PLAYER_DATA_OFFSET_X
    lda (_player_data),y
    tay
    jmp storeAndPlot

    noEraser
    cmp #COLLISION_TYPE_SLOW
    bne noSlow
    jsr slowdownPlayer

    noSlow
    cmp #COLLISION_TYPE_RIGHT_ARROW
    bne noRightArrow
    ldy #PLAYER_DATA_OFFSET_X
    lda (_player_data),Y
    clc
    adc #ARROW_JUMP_DISTANCE
    sta trailItemX
    sta (_player_data),Y
    jmp storeAndPlot

    noRightArrow
    cmp #COLLISION_TYPE_LEFT_ARROW
    bne noLeftArrow
    ldy #PLAYER_DATA_OFFSET_X
    lda (_player_data),Y
    sec
    sbc #ARROW_JUMP_DISTANCE
    sta trailItemX
    sta (_player_data),Y
    jmp storeAndPlot

    noLeftArrow 
    cmp #COLLISION_TYPE_UP_ARROW
    bne noUpArrow
    ldy #PLAYER_DATA_OFFSET_Y
    lda (_player_data),Y
    sec
    sbc #ARROW_JUMP_DISTANCE
    sta trailItemY
    sta (_player_data),Y
    jmp storeAndPlot

    noUpArrow
    cmp #COLLISION_TYPE_DOWN_ARROW
    bne storeAndPlot
    ldy #PLAYER_DATA_OFFSET_Y
    lda (_player_data),Y
    clc
    adc #ARROW_JUMP_DISTANCE
    sta trailItemY
    sta (_player_data),Y
    ;jmp storeAndPlot

    :storeAndPlot
    ; store trail data
    ldy #PLAYER_DATA_OFFSET_Y
    lda (_player_data),y
    sta trailItemY
    ldy #PLAYER_DATA_OFFSET_X
    lda (_player_data),y
    sta trailItemX
    tay
    lda (_maze_line_start),Y
    cmp #ERASER_CHAR_CODE
    bne storeTrailChar
    lda #97 ; 1st grain char code
    storeTrailChar
    sta trailChar
    jsr addTrailItem
    

    :plot0
    ldy #PLAYER_DATA_OFFSET_CHAR_CODE
    lda (_player_data),y ; character code for segment of light trail
    ldy trailItemX
    sta (_maze_line_start),y

    :checkDone
    rts

:playerDead
    ; update the player position on screen
    ldy #PLAYER_DATA_OFFSET_Y
    lda (_player_data),y
    tay
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy #PLAYER_DATA_OFFSET_X
    lda (_player_data),y
    tay
    ldy #PLAYER_DATA_OFFSET_CHAR_CODE
    lda (_player_data),y ; character code for segment of light trail
    sta (_maze_line_start),y

    ; Set metrics based on screen mode
    lda _display_mode
    cmp #DISPLAY_MODE_SIDE_BY_SIDE
    beq updateSideBySide
    cmp #DISPLAY_MODE_FULLSCREEN
    beq updateStatusLine

    jsr setMetricsForTopScreen
    jsr plotArea
    jsr setMetricsForBottomScreen
    jsr plotArea
    jmp updateStatusLine

    updateSideBySide
    jsr setMetricsForLeftScreen
    jsr plotArea
    jsr setMetricsForRightScreen
    jsr plotArea

    :updateStatusLine
    ldy #PLAYER_DATA_OFFSET_ID
    lda (_player_data),Y
    cmp #01
    bne showPlayer2Death
    
    ; detect which player died and update accordingly
    ; print message on status line
    lda #<Player1DeadMessage
    sta loadMessageLoop+1
    lda #>Player1DeadMessage
    sta loadMessageLoop+2
    jsr printStatusMessage

    ; set flag for player dead
    lda #PLAYER_STATUS_DEAD_PLAYER_1
    sta _player_status
    jsr bigDelay
    rts

    showPlayer2Death
    lda #<Player2DeadMessage
    sta loadMessageLoop+1
    lda #>Player2DeadMessage
    sta loadMessageLoop+2
    jsr printStatusMessage

    ; set flag for player dead
    lda #PLAYER_STATUS_DEAD_PLAYER_2
    sta _player_status
    jsr bigDelay
    rts
.)


setupDefaultKeys
.(
    lda #LEFT_KEY_PLAYER1_ROW
    sta key_left_player1_row

    lda #RIGHT_KEY_PLAYER1_ROW
    sta key_right_player1_row

    lda #UP_KEY_PLAYER1_ROW
    sta key_up_player1_row

    lda #DOWN_KEY_PLAYER1_ROW
    sta key_down_player1_row

    lda #LEFT_KEY_PLAYER1_COL_MASK
    sta key_left_player1_col_mask

    lda #RIGHT_KEY_PLAYER1_COL_MASK
    sta key_right_player1_col_mask

    lda #UP_KEY_PLAYER1_COL_MASK
    sta key_up_player1_col_mask

    lda #DOWN_KEY_PLAYER1_COL_MASK
    sta key_down_player1_col_mask


    lda #LEFT_KEY_PLAYER2_ROW
    sta key_left_player2_row

    lda #RIGHT_KEY_PLAYER2_ROW
    sta key_right_player2_row

    lda #UP_KEY_PLAYER2_ROW
    sta key_up_player2_row

    lda #DOWN_KEY_PLAYER2_ROW
    sta key_down_player2_row

    lda #LEFT_KEY_PLAYER2_COL_MASK
    sta key_left_player2_col_mask

    lda #RIGHT_KEY_PLAYER2_COL_MASK
    sta key_right_player2_col_mask

    lda #UP_KEY_PLAYER2_COL_MASK
    sta key_up_player2_col_mask

    lda #DOWN_KEY_PLAYER2_COL_MASK
    sta key_down_player2_col_mask
    rts
.)


slowdownPlayer
.(
    ldy #PLAYER_DATA_OFFSET_Y
    lda (_player_data),Y
    tay
    lda OffscreenLineLookupLo,Y
    sta _line_start_lo
    lda OffscreenLineLookupHi,y
    sta _line_start_hi
    ldy #PLAYER_DATA_OFFSET_X
    lda (_player_data),Y
    tay
    lda (_line_start),Y
    cmp #SLOW_CHAR_CODE_RIGHT
    bne checkMid
    dey
    dey
    checkMid
    cmp #SLOW_CHAR_CODE_MID
    bne atLeft
    dey
    atLeft
    // fill in background with 'grains'
    tya
    pha
    jsr _GetRand
    pla
    tay
    lda rand_low;
    and #15
    adc #97
    sta (_line_start),y
    iny
    tya
    pha
    jsr _GetRand
    pla
    tay
    lda rand_low;
    and #15
    adc #97
    sta (_line_start),y
    iny
    tya
    pha
    jsr _GetRand
    pla
    tay
    lda rand_low;
    and #15
    adc #97
    sta (_line_start),y

    ;set player motion state to slow
    ldy #PLAYER_DATA_OFFSET_EFFECT_TYPE
    lda #PLAYER_EFFECT_TYPE_SLOW
    sta (_player_data),y
    ldy #PLAYER_DATA_OFFSET_CYCLES_REMAINING
    lda #MAX_CYCLES_SLOW_EFFECT
    sta (_player_data),y


    rts
.)

