;// THIS IS FOR THE PLAYER CONTROLLED BY THE COMPUTER
updateMovementPlayer2 
.(
    lda _player2_direction
    cmp #PLAYER_DIRECTION_LEFT
    beq processCheckLeft
    jmp checkRight

    :processCheckLeft
    lda #POSSIBLE_DIRECTION_NONE
    sta _possible_directions

    dec _player2_x

    ; check that the move is valid, and that we don't have any signicant collisions
    ldy _player2_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player2_x
    lda (_maze_line_start),y
    and #127
    cmp #(MAX_NON_FATAL_CHAR_CODE+1)
    bcs cannotContinueLeft
    jmp renderPlayer

    ;cannot continue left
    cannotContinueLeft
    ldy _player2_y;    
    dey ; decrement player y to see if we can move up
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player2_x;
    iny ;increment the x position, which we've previously decremented to check up is valid
    lda (_maze_line_start),y
    and #127
    cmp #(MAX_NON_FATAL_CHAR_CODE+1)
    bcc canMoveUpFromLeft
    jmp checkCanMoveDownFromLeft

    canMoveUpFromLeft
    lda #POSSIBLE_DIRECTION_UP
    sta _possible_directions

    :checkCanMoveDownFromLeft
    ldy _player2_y;    
    iny ; increment player y to see if we can move down
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player2_x;
    iny ;increment the x position, which we've previously decremented to check down is valid
    lda (_maze_line_start),y
    and #127
    cmp #(MAX_NON_FATAL_CHAR_CODE+1)
    bcc canMoveDownFromLeft
    jmp processLeftwardDirectionChange

    canMoveDownFromLeft
    lda _possible_directions
    adc #POSSIBLE_DIRECTION_DOWN
    sta _possible_directions

    :processLeftwardDirectionChange
    lda _possible_directions
    cmp #POSSIBLE_DIRECTION_NONE
    beq continueLeft
    cmp #POSSIBLE_DIRECTION_BOTH
    beq chooseADirectionFromLeft
    cmp #POSSIBLE_DIRECTION_UP
    beq changeFromLeftToUp

    ; can only move down
    inc _player2_x; we couldn't move left... so increment the x position before moving down
    lda #PLAYER_DIRECTION_DOWN
    sta _player2_direction
    inc _player2_y;
    jmp continueLeft

    ; can only move up
    changeFromLeftToUp
    inc _player2_x; we couldn't move left... so increment the x position before moving up
    lda #PLAYER_DIRECTION_UP
    sta _player2_direction
    dec _player2_y;
    jmp continueLeft

    :chooseADirectionFromLeft
    lda _possible_directions
    jsr _GetRand
    lda rand_low
    and #POSSIBLE_DIRECTION_UP
    cmp #POSSIBLE_DIRECTION_UP
    beq chooseUpFromLeft
    
    ; choose down
    inc _player2_y
    inc _player2_x ;  we couldn't move left... so increment the x position before moving right
    lda #PLAYER_DIRECTION_DOWN
    sta _player2_direction
    jmp renderPlayer


    chooseUpFromLeft
    dec _player2_y
    inc _player2_x ;  we couldn't move left... so increment the x position before moving down
    lda #PLAYER_DIRECTION_UP
    sta _player2_direction
    jmp renderPlayer


    :continueLeft
    jmp renderPlayer

checkRight
    lda _player2_direction
    cmp #PLAYER_DIRECTION_RIGHT
    beq processCheckRight
    jmp checkUp

    :processCheckRight
    lda #POSSIBLE_DIRECTION_NONE
    sta _possible_directions

    inc _player2_x

    ; check that the move is valid, and that we don't have any signicant collisions
    ldy _player2_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player2_x
    lda (_maze_line_start),y
    and #127
    cmp #(MAX_NON_FATAL_CHAR_CODE+1)
    bcs cannotContinueRight
    jmp renderPlayer

    ;cannot continue left
    cannotContinueRight
    ldy _player2_y;    
    dey ; decrement player y to see if we can move up
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player2_x;
    dey ;decrement the x position, which we've previously incremented to check up is valid
    lda (_maze_line_start),y
    and #127
    cmp #(MAX_NON_FATAL_CHAR_CODE+1)
    bcc canMoveUpFromRight
    jmp checkCanMoveDownFromRight

    canMoveUpFromRight
    lda #POSSIBLE_DIRECTION_UP
    sta _possible_directions

    :checkCanMoveDownFromRight
    ldy _player2_y;    
    iny ; increment player y to see if we can move down
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player2_x;
    dey ;decrement the x position, which we've previously incremented to check down is validd
    lda (_maze_line_start),y
    and #127
    cmp #(MAX_NON_FATAL_CHAR_CODE+1)
    bcc canMoveDownFromRight
    jmp processRightwardDirectionChange

    canMoveDownFromRight
    lda _possible_directions
    adc #POSSIBLE_DIRECTION_DOWN
    sta _possible_directions

    :processRightwardDirectionChange
    lda _possible_directions
    cmp #POSSIBLE_DIRECTION_NONE
    beq continueRight
    cmp #POSSIBLE_DIRECTION_BOTH
    beq chooseADirectionFromRight
    cmp #POSSIBLE_DIRECTION_UP
    beq changeFromRightToUp

    ; can only move down
    dec _player2_x; we couldn't move right... so decrement the x position before moving down
    lda #PLAYER_DIRECTION_DOWN
    sta _player2_direction
    inc _player2_y;
    jmp continueRight

    ; can only move up
    changeFromRightToUp
    dec _player2_x; we couldn't move right... so decrement the x position before moving down
    lda #PLAYER_DIRECTION_UP
    sta _player2_direction
    dec _player2_y;
    jmp continueLeft

     :chooseADirectionFromRight
    lda _possible_directions
    jsr _GetRand
    lda rand_low
    and #POSSIBLE_DIRECTION_UP
    cmp #POSSIBLE_DIRECTION_UP
    beq chooseUpFromRight

    ; choose down
    inc _player2_y
    dec _player2_x; we couldn't move right... so decrement the x position before moving down
    lda #PLAYER_DIRECTION_DOWN
    sta _player2_direction
    jmp renderPlayer

    chooseUpFromRight
    dec _player2_y
    dec _player2_x; we couldn't move right... so decrement the x position before moving up
    lda #PLAYER_DIRECTION_UP
    sta _player2_direction
    jmp renderPlayer


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
    dec _player2_y ;move the player upwards, (we will need to correct this when checking left/right possibilties)

    ; check that the move is valid, and that we don't have any signicant collisions
    ldy _player2_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player2_x
    lda (_maze_line_start),y
    and #127
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
    and #127
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
    and #127
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
    inc _player2_y

    ; check that the move is valid, and that we don't have any signicant collisions
    ldy _player2_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _player2_x
    lda (_maze_line_start),y
    and #127
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
    and #127
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
    and #127
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
    dec _player2_y; we couldn't move down... so increment the y position before moving right
    lda #PLAYER_DIRECTION_RIGHT
    sta _player2_direction
    inc _player2_x;
    jmp renderPlayer

    ; can only move left
    changeFromDownToLeft
    dec _player2_y; we couldn't move down... so increment the y position before moving left
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
    dec _player2_y ;  we couldn't move down... so increment the y position before moving right
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

    ; check for fatal collision
    ldy _player2_x
    lda (_maze_line_start),Y
    and #127
    sbc #(MAX_NON_FATAL_CHAR_CODE+1)
    bpl playerDead 

    ; check for collision with black hole
    ldy _player2_x
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
    cmp #ERASER_CHAR_CODE
    bne storeAndPlot1
    jsr eraseTrailPlayer2
    lda _player2_x
    tay
    jmp plot1

    storeAndPlot1
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

    :plot1
    lda #PLAYER2_SEGEMENT_CHAR_CODE ; character code for segment of light trail
    adc #128
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
    adc #128
    sta (_maze_line_start),y

    ;// set metrics based on screen mode
    lda _display_mode
    cmp #DISPLAY_MODE_SIDE_BY_SIDE
    beq updateSideBySide
    cmp #DISPLAY_MODE_FULLSCREEN
    beq updateStatus

    jsr setMetricsForTopScreen
    jsr plotArea
    jsr setMetricsForBottomScreen
    jsr plotArea
    jmp updateStatus

    updateSideBySide
    jsr setMetricsForLeftScreen
    jsr plotArea
    jsr setMetricsForRightScreen
    jsr plotArea
    
    :updateStatus
    ; print message on status line
    lda #<ComputerDeadMessage
    sta loadMessageLoop+1
    lda #>ComputerDeadMessage
    sta loadMessageLoop+2
    jsr printStatusMessage

    ; set flag for player dead
    lda #PLAYER_STATUS_DEAD_PLAYER_2
    sta _player_status
    jsr bigDelay
    rts
.)
