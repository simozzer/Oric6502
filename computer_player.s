

_temp_player_x .byt 0
_temp_player_y .byt 0
_temp_player_direction .byt 0

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; chooseDirectionForComputerPlayer: updates the direction for the computer
; controlled player, if required.
; Params: none
; Returns: null
; -------------------------------------------------------------------
chooseDirectionForComputerPlayer
.(

    ldy #PLAYER_DATA_OFFSET_X
    lda (_player_data),y
    sta _temp_player_x

    ldy #PLAYER_DATA_OFFSET_Y
    lda (_player_data),y
    sta _temp_player_y

    ldy #PLAYER_DATA_OFFSET_DIRECTION
    lda (_player_data),y
    sta _temp_player_direction

    cmp #PLAYER_DIRECTION_LEFT
    beq processCheckLeft
    jmp checkRight

    :processCheckLeft
        lda #POSSIBLE_DIRECTION_NONE
        sta _possible_directions

        dec _temp_player_x

        ; check that the move is valid, and that we don't have any signicant collisions
        ldy _temp_player_y
        lda OffscreenLineLookupLo,Y
        sta _maze_line_start_lo
        lda OffscreenLineLookupHi,y
        sta _maze_line_start_hi
        ldy _temp_player_x
        lda (_maze_line_start),y
        and #127
        cmp #(MAX_NON_FATAL_CHAR_CODE+1)
        bcs cannotContinueLeft
        
        ;CAN CONTINUTE LEFT.. Return without altering player
        rts

        ;cannot continue left
        cannotContinueLeft
        ldy _temp_player_y   
        dey ; decrement player y to see if we can move up
        lda OffscreenLineLookupLo,Y
        sta _maze_line_start_lo
        lda OffscreenLineLookupHi,y
        sta _maze_line_start_hi
        ldy _temp_player_x
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
        ldy _temp_player_y;    
        iny ; increment player y to see if we can move down
        lda OffscreenLineLookupLo,Y
        sta _maze_line_start_lo
        lda OffscreenLineLookupHi,y
        sta _maze_line_start_hi
        ldy _temp_player_x;
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
        bne changeFromLeft
        rts
        changeFromLeft
        cmp #POSSIBLE_DIRECTION_BOTH
        beq chooseADirectionFromLeft
        cmp #POSSIBLE_DIRECTION_UP
        beq changeFromLeftToUp

        ; can only move down
        lda #PLAYER_DIRECTION_DOWN
        ldy #PLAYER_DATA_OFFSET_DIRECTION
        sta (_player_data),Y
        rts

        ; can only move up
        changeFromLeftToUp
        lda #PLAYER_DIRECTION_UP
        ldy #PLAYER_DATA_OFFSET_DIRECTION
        sta (_player_data),Y
        rts

        :chooseADirectionFromLeft
        lda _possible_directions
        jsr _GetRand
        lda rand_low
        and #POSSIBLE_DIRECTION_UP
        cmp #POSSIBLE_DIRECTION_UP
        beq chooseUpFromLeft
        
        ; choose down
        lda #PLAYER_DIRECTION_DOWN
        ldy #PLAYER_DATA_OFFSET_DIRECTION
        sta (_player_data),Y
        rts


        chooseUpFromLeft
        lda #PLAYER_DIRECTION_UP
        ldy #PLAYER_DATA_OFFSET_DIRECTION
        sta (_player_data),Y
        rts

        ;------------------------------------------------------------------------------------------------

    checkRight
    lda _temp_player_direction
    cmp #PLAYER_DIRECTION_RIGHT
    beq processCheckRight
    jmp checkUp

    :processCheckRight
    lda #POSSIBLE_DIRECTION_NONE
    sta _possible_directions

    inc _temp_player_x

    ; check that the move is valid, and that we don't have any signicant collisions
    ldy _temp_player_y
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _temp_player_x
    lda (_maze_line_start),y
    and #127
    cmp #(MAX_NON_FATAL_CHAR_CODE+1)
    bcs cannotContinueRight
    
    rts ; can continue right - return without changing direction

    ;cannot continue right
    cannotContinueRight
    ldy _temp_player_y   
    dey ; decrement player y to see if we can move up
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _temp_player_x
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
    ldy _temp_player_y 
    iny ; increment player y to see if we can move down
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _temp_player_x
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
    bne changeFromRight
    rts
    changeFromRight
    cmp #POSSIBLE_DIRECTION_BOTH
    beq chooseADirectionFromRight
    cmp #POSSIBLE_DIRECTION_UP
    beq changeFromRightToUp

    ; can only move down - store direction change and return
    lda #PLAYER_DIRECTION_DOWN
    ldy #PLAYER_DATA_OFFSET_DIRECTION
    sta (_player_data),Y
    rts

    ; can only move up
    changeFromRightToUp
    lda #PLAYER_DIRECTION_UP
    ldy #PLAYER_DATA_OFFSET_DIRECTION
    sta (_player_data),Y
    rts

     :chooseADirectionFromRight
    lda _possible_directions
    jsr _GetRand
    lda rand_low
    and #POSSIBLE_DIRECTION_UP
    cmp #POSSIBLE_DIRECTION_UP
    beq chooseUpFromRight

    ; choose down
    lda #PLAYER_DIRECTION_DOWN
    ldy #PLAYER_DATA_OFFSET_DIRECTION
    sta (_player_data),Y
    rts

    chooseUpFromRight
    lda #PLAYER_DIRECTION_UP
    ldy #PLAYER_DATA_OFFSET_DIRECTION
    sta (_player_data),Y
    rts

    ;--------------------------------------------------------------------------------------

    checkUp
    lda _temp_player_direction
    cmp #PLAYER_DIRECTION_UP
    beq processCheckUp
    jmp checkDown

    :processCheckUp
    lda #POSSIBLE_DIRECTION_NONE
    sta _possible_directions
    dec _temp_player_y ;move the player upwards, (we will need to correct this when checking left/right possibilties)

    ; check that the move is valid, and that we don't have any signicant collisions
    ldy _temp_player_y
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _temp_player_x
    lda (_maze_line_start),y
    and #127
    cmp #(MAX_NON_FATAL_CHAR_CODE+1)
    bcs  cannotcontinueUp
    
    rts ;can continue up, return without changing direction
    
    // Cannot continue up
    cannotcontinueUp
    ; check if can move left
    ldy _temp_player_y
    iny ; re-increment the y position, as we had a collision at that point
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _temp_player_x
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
    ldy _temp_player_x
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
    bne changeFromUp
    rts
    changeFromUp
    cmp #POSSIBLE_DIRECTION_BOTH
    beq chooseADirectionFromUp
    cmp #POSSIBLE_DIRECTION_LEFT
    beq changeFromUpToLeft

    ; can only move right
    lda #PLAYER_DIRECTION_RIGHT
    ldy #PLAYER_DATA_OFFSET_DIRECTION
    sta (_player_data),Y
    rts

    ; can only move left
    changeFromUpToLeft
    lda #PLAYER_DIRECTION_LEFT
    ldy #PLAYER_DATA_OFFSET_DIRECTION
    sta (_player_data),Y
    rts

    ; choose right or left at random
    :chooseADirectionFromUp
    lda _possible_directions
    jsr _GetRand
    lda rand_low
    and #POSSIBLE_DIRECTION_LEFT
    cmp #POSSIBLE_DIRECTION_LEFT
    beq chooseLeftFromUp

    ; choose right
    lda #PLAYER_DIRECTION_RIGHT
    ldy #PLAYER_DATA_OFFSET_DIRECTION
    sta (_player_data),Y
    rts

    chooseLeftFromUp
    lda #PLAYER_DIRECTION_LEFT
    ldy #PLAYER_DATA_OFFSET_DIRECTION
    sta (_player_data),Y
    rts

    ;-------------------------------------------------------------------------------------
    checkDown
    lda _temp_player_direction
    cmp #PLAYER_DIRECTION_DOWN
    beq processCheckDown
    rts

    :processCheckDown
    lda #POSSIBLE_DIRECTION_NONE
    sta _possible_directions
    inc _temp_player_y

    ; check that the move is valid, and that we don't have any signicant collisions
    ldy _temp_player_y
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _temp_player_x
    lda (_maze_line_start),y
    and #127
    cmp  #(MAX_NON_FATAL_CHAR_CODE+1)
    bcs checkMoveLeft

    rts ;can continue to move down, return without changing direction

    // cannot continue down
    checkMoveLeft
    ; check if can move left
    ldy _temp_player_y
    dey ; deccrement the y position, as we had a collision at that point
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    ldy _temp_player_x
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
    ldy _temp_player_x;
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
    bne changeFromDown
    rts
    changeFromDown
    cmp #POSSIBLE_DIRECTION_BOTH
    beq chooseADirectionFromDown
    cmp #POSSIBLE_DIRECTION_LEFT
    beq changeFromDownToLeft

    ; can only move right
    lda #PLAYER_DIRECTION_RIGHT
    ldy #PLAYER_DATA_OFFSET_DIRECTION
    sta (_player_data),Y
    rts

    ; can only move left
    changeFromDownToLeft
    lda #PLAYER_DIRECTION_LEFT
    ldy #PLAYER_DATA_OFFSET_DIRECTION
    sta (_player_data),Y
    rts

    ; choose right or left at random
    :chooseADirectionFromDown
    lda _possible_directions
    jsr _GetRand
    lda rand_low
    and #POSSIBLE_DIRECTION_LEFT
    cmp #POSSIBLE_DIRECTION_LEFT
    beq chooseLeftFromDown

    ; choose right
    lda #PLAYER_DIRECTION_RIGHT
    ldy #PLAYER_DATA_OFFSET_DIRECTION
    sta (_player_data),Y
    rts

    chooseLeftFromDown
    lda #PLAYER_DIRECTION_LEFT
    ldy #PLAYER_DATA_OFFSET_DIRECTION
    sta (_player_data),Y
    rts
.)