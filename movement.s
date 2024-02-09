
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

    ;scroll if we can
    LDA _player1_x
    CMP _scroll_left_maze_x_threshold
    BCS movePlayerLeft

    lda _player1_maze_x
    cmp #00 ; left column of maze data
    beq movePlayerLeft
    dec _player1_maze_x

    movePlayerLeft
    dec _player1_x
    jmp renderPlayer

checkRight
    lda _player1_direction
    cmp #PLAYER_DIRECTION_RIGHT
    bne checkUp

    ;scroll if we can
    LDA _player1_x
    CMP _scroll_right_maze_x_threshold
    BCC movePlayerRight

    lda _player1_maze_x
    cmp _scroll_right_max_maze_x
    beq movePlayerRight
    inc _player1_maze_x

    movePlayerRight
    inc _player1_x
    jmp renderPlayer

checkUp
    lda _player1_direction
    cmp #PLAYER_DIRECTION_UP
    bne checkDown



    lda _player1_y ;if player is neear the bottom of the screen then don't scroll
    cmp _scroll_up_maze_y_threshold
    bpl movePlayerUp

    lda _player1_maze_y ; don't allow scrolling up past the top of the maze
    cmp #00
    beq movePlayerUp
    dec _player1_maze_y

    movePlayerUp
    dec _player1_y
    jmp renderPlayer


checkDown
    lda _player1_direction
    cmp #PLAYER_DIRECTION_DOWN
    bne checkDone


    lda _player1_y ;if player is neear the top of the screen then don't scroll
    cmp _scroll_down_maze_y_threshold
    bmi movePlayerDown
    ;scroll if we can
    lda _player1_maze_y
    cmp _scroll_down_max_maze_y
    beq movePlayerDown
    inc _player1_maze_y

    movePlayerDown
    inc _player1_y

renderPlayer
    ldy _player1_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi

    ; check for collision
    ldy _player1_x
    lda (_maze_line_start),Y
    and #127

    clc
    cmp #(MAX_NON_FATAL_CHAR_CODE+1)
    bpl playerDead

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

    jsr ScreenRender
    
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

