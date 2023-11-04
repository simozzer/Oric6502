
processKeyboardPlayer1
.(
    ldx KEY_PRESS_LOOKUP  

    cpx KEY_PRESS_NONE
    beq keyboardDone
    
    cpx #KEY_LEFT_ARROW
    bne nextKey0
    lda _player1_direction
    cmp #PLAYER_DIRECTION_RIGHT
    beq nextKey0
    lda #PLAYER_DIRECTION_LEFT
    sta _player1_direction

nextKey0
    cpx #KEY_RIGHT_ARROW
    bne nextKey1
    lda _player1_direction
    cmp #PLAYER_DIRECTION_LEFT
    beq nextKey1
    lda #PLAYER_DIRECTION_RIGHT
    sta _player1_direction

nextKey1
    cpx #KEY_DOWN_ARROW
    bne nextKey2
    lda _player1_direction
    cmp #PLAYER_DIRECTION_UP
    beq nextKey2
    lda #PLAYER_DIRECTION_DOWN
    sta _player1_direction

nextKey2
    cpx #KEY_UP_ARROW
    bne keyboardDone
    lda _player1_direction
    cmp #PLAYER_DIRECTION_DOWN
    beq keyboardDone
    lda #PLAYER_DIRECTION_UP
    sta _player1_direction
keyboardDone
  rts
.)
    


// TODO: need to change the constraints for when to scroll based on the screen sizes 
updateMovementPlayer1FullScreen
.(
    lda _player1_direction
    cmp #PLAYER_DIRECTION_LEFT
    bne checkRight

    ;scroll if we can ((TODO don't scroll if scrolling up and haven't reached middle of screen))

    LDA _player1_x
    CMP #234
    BCS movePlayerLeft
    lda _player1_maze_x
    cmp #00
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
    CMP #21
    BCC movePlayerRight

    lda _player1_maze_x
    cmp #217
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
    cmp #68
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
    cmp #12
    bmi movePlayerDown
    ;scroll if we can
    lda _player1_maze_y
    cmp #53
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
    cmp #97 + 128
    beq playerDead 
    cmp #115
    beq playerDead


    lda #115 ; character code for segment of light trail
    sta (_maze_line_start),y

checkDone
   rts

   :DeadMessage .byt "YOU'RE DEAD"                                 
:playerDead
    jsr ScreenRender
    lda #115 ; character code for segment of light trail
    sta (_maze_line_start),y
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
.)


updateMovementPlayer1SideBySide
.(
    lda _player1_direction
    cmp #PLAYER_DIRECTION_LEFT
    bne checkRight

    ;scroll if we can ((TODO don't scroll if scrolling up and haven't reached middle of screen))

   ; LDA _player1_x
   ; CMP #245
   ; BCS movePlayerLeft
    lda _player1_maze_x
    cmp #00
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
    CMP #9
    BCC movePlayerRight

    lda _player1_maze_x
    cmp #250
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
    cmp #68
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
    cmp #12
    bmi movePlayerDown
    ;scroll if we can
    lda _player1_maze_y
    cmp #53
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
    cmp #97 + 128
    beq playerDead 
    cmp #115
    beq playerDead


    lda #115 ; character code for segment of light trail
    sta (_maze_line_start),y

checkDone
   rts

:DeadMessage .byt "YOU'RE DEAD"                                 
:playerDead
    jsr ScreenRender
    lda #115 ; character code for segment of light trail
    sta (_maze_line_start),y
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
.)






  

; <<<<<< ScreenRender
; -----------------------------------------------------------------
