
processKeyboardPlayer1
.(
    
    lda _KeyRowArrows
    beq keyboardDone

    tax
    and #$20
    cmp #$20; #KEY_LEFT_ARROW
    bne nextKey0
    lda _player1_direction
    cmp #PLAYER_DIRECTION_RIGHT
    beq nextKey0
    lda #PLAYER_DIRECTION_LEFT
    sta _player1_direction
    jsr _GetRand
    rts

nextKey0
    txa
    and #$80; #KEY_RIGHT_ARROW
    cmp #$80
    bne nextKey1
    lda _player1_direction
    cmp #PLAYER_DIRECTION_LEFT
    beq nextKey1
    lda #PLAYER_DIRECTION_RIGHT
    sta _player1_direction   
    jsr _GetRand 
    rts

nextKey1
    txa
    and #$40; #KEY_DOWN_ARROW
    cmp #$40
    bne nextKey2
    lda _player1_direction
    cmp #PLAYER_DIRECTION_UP
    beq nextKey2
    lda #PLAYER_DIRECTION_DOWN
    sta _player1_direction
    jsr _GetRand
    rts

nextKey2
    txa
    and #$08;#KEY_UP_ARROW
    cmp #$08
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

