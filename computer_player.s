
;/ THIS COULD BE SIMPLIFIED with getCharAbove, getCharBelow, getCharToLeft, getCharToRight
; or GetCanMoveUp, GetCanMoveDown, GetCanMoveLeft, GetCanMoveRight
;/ WHICH MIGHT BE EASIER TO READ AND MAINTAIN (but would probably be less performant)

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
    clc
    sbc #(MAX_NON_FATAL_CHAR_CODE+1)
    bmi continueLeft

    // TODO Choose random up/down (for now we'll just go down)
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
    clc
    sbc #(MAX_NON_FATAL_CHAR_CODE+1)
    bmi continueRight


    // TODO -- choose direction up/down..If we can't do either then die!
    // if we can do both then use random.

    // for testing we'll just go up ;)
    dec _player2_x
    lda #PLAYER_DIRECTION_UP
    sta _player2_direction
    dec _player2_y;



    :continueRight
    jmp renderPlayer
checkUp
.(
    lda _player2_direction
    cmp #PLAYER_DIRECTION_UP
    beq processCheckUp
    jmp checkDown

    :processCheckUp
    lda #POSSIBLE_DIRECTION_NONE
    sta _possible_directions

    ; // Keep the maze in view, and dont allow display of elements outside of the maze!!
    lda _player2_y ;if player is near the bottom of the screen then don't scroll
    cmp _scroll_up_maze_y_threshold
    bpl movePlayerUpOrTurn

    lda _player2_maze_y ; don't allow scrolling up past the top of the maze
    cmp #00
    beq movePlayerUpOrTurn
    dec _player2_maze_y

    movePlayerUpOrTurn
    dec _player2_y ;move the player upwards, (we will need to correct this when checking left/right possibilties)

    ; check that the move is valid, and that we don't have any signicant collisions
    ldy _player2_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player2_x
    lda (_maze_line_start),y
    cmp #(MAX_NON_FATAL_CHAR_CODE+1)
    bcc continueUp

    // Cannot continue up

    ; check if can move left
    ldy _player2_y;
    iny ; re-increment the y position, as we had a collision at that point
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player2_x;
    dey ;decrement the x position to check that the position to the left is valid
    lda (_maze_line_start),y
    cmp #(MAX_NON_FATAL_CHAR_CODE+1)
    bcc canMoveLeftFromUp
    jmp checkCanMoveRightFromUp


    canMoveLeftFromUp
    lda #POSSIBLE_DIRECTION_LEFT
    sta _possible_directions

    :checkCanMoveRightFromUp
    ldy _player2_x;
    iny ; increment the x position to check that the position to the right is valid
    lda (_maze_line_start),y
    cmp #(MAX_NON_FATAL_CHAR_CODE+1)
    bcc canMoveRightFromUp
    jmp processUpwardDirectionChange

    canMoveRightFromUp
    lda _possible_directions
    adc #POSSIBLE_DIRECTION_RIGHT
    sta _possible_directions

    ; Check the possible directions to see where we can move next
    :processUpwardDirectionChange
    lda _possible_directions
    cmp #POSSIBLE_DIRECTION_NONE
    beq continueUp
    cmp #POSSIBLE_DIRECTION_BOTH
    beq chooseADirectionFromUp
    cmp #POSSIBLE_DIRECTION_LEFT
    beq changeFromUpToLeft

    ; can only move right
    inc _player2_y; we couldn't move up... so increment the y position before moving right
    lda #PLAYER_DIRECTION_RIGHT
    sta _player2_direction
    inc _player2_x;
    jmp renderPlayer

    ; can only move left
    changeFromUpToLeft
    inc _player2_y; we couldn't move up... so increment the y position before moving left
    lda #PLAYER_DIRECTION_LEFT
    sta _player2_direction
    dec _player2_x;
    jmp renderPlayer

    ; choose right or left at random
    :chooseADirectionFromUp
    lda _possible_directions
    jsr _GetRand
    lda rand_low
    and #POSSIBLE_DIRECTION_LEFT
    cmp #POSSIBLE_DIRECTION_LEFT
    beq chooseLeftFromUp

    ; choose right
    inc _player2_x
    inc _player2_y ;  we couldn't move up... so increment the y position before moving right
    lda #PLAYER_DIRECTION_RIGHT
    sta _player2_direction
    jmp renderPlayer

    chooseLeftFromUp
    dec _player2_x
    inc _player2_y ;  we couldn't move up... so increment the y position before moving left
    lda #PLAYER_DIRECTION_LEFT
    sta _player2_direction
    jmp renderPlayer
.)
    :continueUp
    jmp renderPlayer


checkDown
    lda _player2_direction
    cmp #PLAYER_DIRECTION_DOWN
    beq processCheckDown
    jmp checkDone

    :processCheckDown
    lda #POSSIBLE_DIRECTION_NONE
    sta _possible_directions

    ; // Keep the maze in view, and dont allow display of elements outside of the maze!!
    lda _player2_y ;if player is neear the top of the screen then don't scroll
    cmp _scroll_down_maze_y_threshold
    bmi movePlayerDownOrTurn

    lda _player2_maze_y; don't allow scrolling up past the top of the maze
    cmp _scroll_down_max_maze_y
    beq movePlayerDownOrTurn
    inc _player2_maze_y

    movePlayerDownOrTurn
    inc _player2_y

    ; check that the move is valid, and that we don't have any signicant collisions
    ldy _player2_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player2_x
    lda (_maze_line_start),y
    cmp  #(MAX_NON_FATAL_CHAR_CODE+1)
    bcc renderPlayer

    // cannot continue down

; check if can move left
    ldy _player2_y;
    dey ; deccrement the y position, as we had a collision at that point
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player2_x;
    dey ;decrement the x position to check that the position to the left is valid
    lda (_maze_line_start),y
    cmp #(MAX_NON_FATAL_CHAR_CODE+1)
    bcc canMoveLeftFromDown
    jmp checkCanMoveRightFromDown

    canMoveLeftFromDown
    lda #POSSIBLE_DIRECTION_LEFT
    sta _possible_directions

    :checkCanMoveRightFromDown
    ldy _player2_x;
    iny ; increment the x position to check that the position to the right is valid
    lda (_maze_line_start),y
    cmp #(MAX_NON_FATAL_CHAR_CODE+1)
    bcc canMoveRightFromDown    
    jmp processDownwardDirectionChange

    canMoveRightFromDown
    lda _possible_directions
    adc #POSSIBLE_DIRECTION_RIGHT
    sta _possible_directions

    :processDownwardDirectionChange
    lda _possible_directions
    cmp #POSSIBLE_DIRECTION_NONE
    beq renderPlayer
    cmp #POSSIBLE_DIRECTION_BOTH
    beq chooseADirectionFromDown
    cmp #POSSIBLE_DIRECTION_LEFT
    beq changeFromDownToLeft

    ; can only move right
    dec _player2_y; we couldn't move up... so increment the y position before moving right
    lda #PLAYER_DIRECTION_RIGHT
    sta _player2_direction
    inc _player2_x;
    jmp renderPlayer

    ; can only move left
    changeFromDownToLeft
    dec _player2_y; we couldn't move up... so increment the y position before moving left
    lda #PLAYER_DIRECTION_LEFT
    sta _player2_direction
    dec _player2_x;
    jmp renderPlayer

    ; choose right or left at random
    :chooseADirectionFromDown
    lda _possible_directions
    jsr _GetRand
    lda rand_low
    and #POSSIBLE_DIRECTION_LEFT
    cmp #POSSIBLE_DIRECTION_LEFT
    beq chooseLeftFromDown

    ; choose right
    inc _player2_x
    dec _player2_y ;  we couldn't move up... so increment the y position before moving right
    lda #PLAYER_DIRECTION_RIGHT
    sta _player2_direction
    jmp renderPlayer

    chooseLeftFromDown
    dec _player2_x
    dec _player2_y ;  we couldn't move up... so increment the y position before moving left
    lda #PLAYER_DIRECTION_LEFT
    sta _player2_direction
    jmp renderPlayer

renderPlayer
    ldy _player2_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi

    ; check for collision
    ldy _player2_x
    lda (_maze_line_start),Y
    clc
    sbc #(MAX_NON_FATAL_CHAR_CODE+1)
    bpl playerDead 
    

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
