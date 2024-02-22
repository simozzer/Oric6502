
processKeyboardPlayer1
.(
    ldx KEY_PRESS_LOOKUP  

    cpx #KEY_PRESS_NONE
    beq keyboardDone
  
    cpx #KEY_LEFT_ARROW
    bne nextKey0
    lda _player1_direction
    cmp #PLAYER_DIRECTION_RIGHT
    beq nextKey0
    lda #PLAYER_DIRECTION_LEFT
    sta _player1_direction
    jsr _GetRand
    rts

nextKey0
    cpx #KEY_RIGHT_ARROW
    bne nextKey1
    lda _player1_direction
    cmp #PLAYER_DIRECTION_LEFT
    beq nextKey1
    lda #PLAYER_DIRECTION_RIGHT
    sta _player1_direction   
    jsr _GetRand 
    rts

nextKey1
    cpx #KEY_DOWN_ARROW
    bne nextKey2
    lda _player1_direction
    cmp #PLAYER_DIRECTION_UP
    beq nextKey2
    lda #PLAYER_DIRECTION_DOWN
    sta _player1_direction
    jsr _GetRand
    rts

nextKey2
    cpx #KEY_UP_ARROW
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
    ldy _player1_x
    lda (_maze_line_start),Y
    and #127

    cmp #(MAX_NON_FATAL_CHAR_CODE+1)
    bpl playerDead


    ; check for collision with black hole
    ldy _player1_x
    lda (_maze_line_start),Y
    cmp #BLACK_HOLE_TOP_LEFT_CHAR_CODE
    bcc noBlackHole
    cmp #BLACK_HOLE_BOTTOM_RIGHT_CHAR_CODE+1
    bcs noBlackHole

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
    lda #<DeadMessage
    sta loadMessageLoop+1
    lda #>DeadMessage
    sta loadMessageLoop+2
    jsr printStatusMessage

    ; set flag for player dead
    lda #PLAYER_STATUS_DEAD_PLAYER_1
    sta _player_status
    jsr bigDelay
    rts
.)

