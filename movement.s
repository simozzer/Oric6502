
processMovement
    ldx KEY_PRESS_LOOKUP  

    cpx KEY_PRESS_NONE
    beq updateMovement
    
    cpx #KEY_LEFT_ARROW
    bne nextKey0
    lda #PLAYER_DIRECTION_LEFT
    sta _player1_direction

nextKey0
    cpx #KEY_RIGHT_ARROW
    bne nextKey1
    lda #PLAYER_DIRECTION_RIGHT
    sta _player1_direction

nextKey1
    cpx #KEY_DOWN_ARROW
    bne nextKey2
    lda #PLAYER_DIRECTION_DOWN
    sta _player1_direction

nextKey2
    cpx #KEY_UP_ARROW
    bne updateMovement
    lda #PLAYER_DIRECTION_UP
    sta _player1_direction
    


// TODO: need to change the constraints for when to scroll based on the screen sizes 
updateMovement
    lda _player1_direction
    cmp #PLAYER_DIRECTION_LEFT
    bne checkRight

    ;scroll if we can ((TODO don't scroll if scrolling up and haven't reached middle of screen))
    lda _maze_left
    cmp #00
    beq movePlayerLeft
    dec _maze_left

    movePlayerLeft
    dec _player1_x
    jmp renderPlayer

checkRight
    lda _player1_direction
    cmp #PLAYER_DIRECTION_RIGHT
    bne checkUp

    ;scroll if we can
    lda _maze_left
    cmp #217
    beq movePlayerRight
    inc _maze_left

    movePlayerRight
    inc _player1_x
    jmp renderPlayer

checkUp
    lda _player1_direction
    cmp #PLAYER_DIRECTION_UP
    bne checkDown

    ;scroll if we can
    lda _maze_top
    cmp #00
    beq movePlayerUp
    dec _maze_top

    movePlayerUp
    dec _player1_y
    jmp renderPlayer


checkDown
    lda _player1_direction
    cmp #PLAYER_DIRECTION_DOWN
    bne checkDone

    ;scroll if we can
    lda _maze_top
    cmp #53
    beq movePlayerDown
    inc _maze_top

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
    cmp #97
    beq playerDead 
    cmp #108
    beq playerDead


    lda #108 ; character code for segment of light trail
    sta (_maze_line_start),y

checkDone
   rts

:DeadMessage .byt "YOU'RE DEAD"                                 
:playerDead
    jsr ClearStatus
    ldy #0                      
.(
Loop
    cpy #11               
    beq ExitInstructions                        
    lda DeadMessage,Y                      
    sta $BB82,Y                     
    iny                             
    jmp Loop
    ExitInstructions 
    lda #PLAYER_STATUS_DEAD
    sta _player_status
    rts       
.)

  

; <<<<<< ScreenRender
; -----------------------------------------------------------------
