
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

/* currently not working
processJoystickPlayer1
.(
    jsr checkIJKPresent
    bcs getJoystickInfo
    rts

    getJoystickInfo
    jsr GenericReadIJK

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
*/

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




updateMovementPlayer1 
.(
    lda _player1_direction
    cmp #PLAYER_DIRECTION_LEFT
    bne checkRight
    dec _player1_x
    jmp renderPlayer

checkRight
    lda _player1_direction
    cmp #PLAYER_DIRECTION_RIGHT
    bne checkUp
    inc _player1_x
    jmp renderPlayer

checkUp
    lda _player1_direction
    cmp #PLAYER_DIRECTION_UP
    bne checkDown
    dec _player1_y
    jmp renderPlayer


checkDown
    lda _player1_direction
    cmp #PLAYER_DIRECTION_DOWN
    bne checkDone
    movePlayerDown
    inc _player1_y

renderPlayer
    ldy _player1_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi

    ; check for collision with fatal object
    lda _player1_x
    sta temp_param_0
    lda _player1_y
    sta temp_param_1
    jsr getCollisionInfo
    lda temp_result
    cmp #COLLISION_TYPE_FATAL
    beq playerDead


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
        sta _player1_x

        getY
        jsr _GetRand;
        lda rand_low;
        cmp #70
        bcs getY
        clc
        adc #05
        sta _player1_y
    .)

    noBlackHole
    ; check for collision with eraser
    cmp #COLLISION_TYPE_ERASER
    bne storeAndPlot
    jsr eraseTrailPlayer1
    lda _player1_x
    tay
    jmp plot0

    storeAndPlot
    ; store trail data
    lda _player1_y
    sta trailItemY
    lda _player1_x
    sta trailItemX
    tay
    lda (_maze_line_start),Y
    sta trailChar
    tya
    tax
    jsr addTrailItemPlayer1
    txa
    tay

    :plot0
    lda #PLAYER1_SEGEMENT_CHAR_CODE ; character code for segment of light trail
    sta (_maze_line_start),y

checkDone
   rts

:playerDead
    ; update the player position on screen
    ldy _player1_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player1_x
    lda #PLAYER1_SEGEMENT_CHAR_CODE ; character code for segment of light trail
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
.)



updateMovementPlayer2 
.(
    lda _player2_direction
    cmp #PLAYER_DIRECTION_LEFT
    bne checkRight
    dec _player2_x
    jmp renderPlayer

checkRight
    lda _player2_direction
    cmp #PLAYER_DIRECTION_RIGHT
    bne checkUp
    inc _player2_x
    jmp renderPlayer

checkUp
    lda _player2_direction
    cmp #PLAYER_DIRECTION_UP
    bne checkDown
    dec _player2_y
    jmp renderPlayer


checkDown
    lda _player2_direction
    cmp #PLAYER_DIRECTION_DOWN
    bne checkDone
    movePlayerDown
    inc _player2_y

renderPlayer
    ldy _player2_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi

    ; check for collision with fatal object
    lda _player2_x
    sta temp_param_0
    lda _player2_y
    sta temp_param_1
    jsr getCollisionInfo
    lda temp_result
    cmp #COLLISION_TYPE_FATAL
    beq playerDead


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
        sta _player2_x

        getY
        jsr _GetRand;
        lda rand_low;
        cmp #70
        bcs getY
        clc
        adc #05
        sta _player2_y
    .)

    noBlackHole
    ; check for collision with eraser
    cmp #COLLISION_TYPE_ERASER
    bne storeAndPlot
    jsr eraseTrailPlayer2
    lda _player2_x
    tay
    jmp plot0

    storeAndPlot
    ; store trail data
    lda _player2_y
    sta trailItemY
    lda _player2_x
    sta trailItemX
    tay
    lda (_maze_line_start),Y
    sta trailChar
    tya
    tax
    jsr addTrailItemPlayer2
    txa
    tay

    :plot0
    lda #PLAYER2_SEGEMENT_CHAR_CODE + 128; character code for segment of light trail
    sta (_maze_line_start),y

checkDone
   rts

:playerDead
    ; update the player position on screen
    ldy _player2_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player2_x
    lda #PLAYER2_SEGEMENT_CHAR_CODE ; character code for segment of light trail
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
    ; print message on status line
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

