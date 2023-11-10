
;// THIS IS FOR THE PLAYER CONTROLLED BY THE COMPUTER
updateMovementPlayer2 
.(
    lda _player2_direction
    cmp #PLAYER_DIRECTION_LEFT
    bne checkRight

    ;scroll if we can
    LDA _player2_x
    CMP _scroll_left_maze_x_threshold
    BCS movePlayerLeftOrTurn

    lda _player2_maze_x
    cmp #00 ; left column of maze data
    beq movePlayerLeftOrTurn
    dec _player2_maze_x

    movePlayerLeftOrTurn
    // TODO - if can't move left try up or down
    dec _player2_x

    ldy _player2_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player2_x
    lda (_maze_line_start),y
    cmp #(BRICK_WALL_CHAR_CODE + 128);
    beq hitWallWhilstMovingLeft
    cmp #PLAYER1_SEGEMENT_CHAR_CODE
    beq hitWallWhilstMovingLeft
    cmp #PLAYER2_SEGEMENT_CHAR_CODE
    beq hitWallWhilstMovingLeft
    jmp continueLeft

    // TODO Choose random up/down (for now we'll just go down)
    hitWallWhilstMovingLeft
    inc _player2_x;
    lda #PLAYER_DIRECTION_DOWN
    sta _player2_direction
    inc _player2_y;

    :continueLeft
    jmp renderPlayer

checkRight
    lda _player2_direction
    cmp #PLAYER_DIRECTION_RIGHT
    bne checkUp

    ;scroll if we can
    LDA _player2_x
    CMP _scroll_right_maze_x_threshold
    BCC movePlayerRightOrTurn

    lda _player2_maze_x
    cmp _scroll_right_max_maze_x
    beq movePlayerRightOrTurn
    inc _player2_maze_x

    movePlayerRightOrTurn
    // TODO - if can't move right try up or down
    inc _player2_x

    
    ldy _player2_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player2_x
    lda (_maze_line_start),y
    cmp #(BRICK_WALL_CHAR_CODE + 128);
    beq hitWallWhilstMovingRight
    cmp #PLAYER1_SEGEMENT_CHAR_CODE
    beq hitWallWhilstMovingRight
    cmp #PLAYER2_SEGEMENT_CHAR_CODE
    beq hitWallWhilstMovingRight
    jmp continueRight


    // TODO -- choose direction up/down..If we can't do either then die!
    // if we can do both then use random.

    // for testing we'll just go up ;)
    hitWallWhilstMovingRight
    dec _player2_x
    lda #PLAYER_DIRECTION_UP
    sta _player2_direction
    dec _player2_y;



    :continueRight
    jmp renderPlayer

checkUp
    lda _player2_direction
    cmp #PLAYER_DIRECTION_UP
    bne checkDown

    lda _player2_y ;if player is neear the bottom of the screen then don't scroll
    cmp _scroll_up_maze_y_threshold
    bpl movePlayerUpOrTurn

    lda _player2_maze_y ; don't allow scrolling up past the top of the maze
    cmp #00
    beq movePlayerUpOrTurn
    dec _player2_maze_y

    movePlayerUpOrTurn
    // TODO - if can't move up try left or right
    dec _player2_y


    ldy _player2_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player2_x
    lda (_maze_line_start),y
    cmp #(BRICK_WALL_CHAR_CODE + 128);
    beq hitWallWhilstMovingUp
    cmp #PLAYER1_SEGEMENT_CHAR_CODE
    beq hitWallWhilstMovingUp
    cmp #PLAYER2_SEGEMENT_CHAR_CODE
    beq hitWallWhilstMovingUp
    jmp continueUp
    


    // TODO -- choose direction left/right..If we can't do either then die!
    // if we can do both then use random.

    // for testing we'll just go left ;)
    hitWallWhilstMovingUp
    inc _player2_y;
    lda #PLAYER_DIRECTION_LEFT
    sta _player2_direction
    dec _player2_x;


    :continueUp
    jmp renderPlayer


checkDown
    lda _player2_direction
    cmp #PLAYER_DIRECTION_DOWN
    bne checkDone


    lda _player2_y ;if player is neear the top of the screen then don't scroll
    cmp _scroll_down_maze_y_threshold
    bmi movePlayerDownOrTurn
    ;scroll if we can
    lda _player2_maze_y
    cmp _scroll_down_max_maze_y
    beq movePlayerDownOrTurn
    inc _player2_maze_y

    movePlayerDownOrTurn
    // TODO - if can't move down try left or right
    inc _player2_y

    ldy _player2_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player2_x
    lda (_maze_line_start),y
    cmp #(BRICK_WALL_CHAR_CODE + 128);    
    beq hitWallWhilstMovingDown
    cmp #PLAYER1_SEGEMENT_CHAR_CODE
    beq hitWallWhilstMovingDown
    cmp #PLAYER2_SEGEMENT_CHAR_CODE
    beq hitWallWhilstMovingDown
    jmp renderPlayer

    // TODO -- choose direction left/right..If we can't do either then die!
    // if we can do both then use random.

    // for testing we'll just go right ;)
    hitWallWhilstMovingDown
    dec _player2_y;
    lda #PLAYER_DIRECTION_RIGHT
    sta _player2_direction
    inc _player2_x;

renderPlayer
    ldy _player2_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi

    ; check for collision
    ldy _player2_x
    lda (_maze_line_start),Y
    cmp #(BRICK_WALL_CHAR_CODE + 128)
    beq playerDead 
    cmp #PLAYER1_SEGEMENT_CHAR_CODE
    beq playerDead


    lda #PLAYER2_SEGEMENT_CHAR_CODE ; character code for segment of light trail
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
    lda #PLAYER2_SEGEMENT_CHAR_CODE ; character code for segment of light trail (player 2)
    sta (_maze_line_start),y

    jsr ScreenRender
    
    ; print message on status line
    lda #<DeadMessage
    sta loadMessageLoop+1
    lda #>DeadMessage
    sta loadMessageLoop+2
    jsr printStatusMessage

    ; set flag for player dead
    lda #PLAYER_STATUS_DEAD_PLAYER_2
    sta _player_status
    jsr bigDelay
    rts
.)
