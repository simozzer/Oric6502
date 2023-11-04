
; -----------------------------------------------------------------
; >>>>> ScreenRender
ScreenRender

    // set the start position for plotting on screen.
    lda _screen_render_right
    sta _plot_ch_x
    lda _screen_render_bottom
    sta _plot_ch_y

    // set the start position for grabbing data from offscreen
    lda _maze_left
    clc
    adc _maze_render_offset_x
    sta _maze_x_tmp
    sta _maze_right

    lda _maze_top
    adc _screen_render_bottom
    sta _maze_y_tmp

.(
loop
    // lookup start of line for plotting on screen
    ldy _plot_ch_y
    lda ScreenLineLookupLo,y
    sta _line_start_lo
    lda ScreenLineLookupHi,Y
    sta _line_start_hi

    // look up start of line for grabbing data from offscreen
    ldy _maze_y_tmp
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi

innerloop
    // grab character from offscreen 
    ldy _maze_x_tmp
    lda (_maze_line_start),Y

    // plot character onscreen
    ldy _plot_ch_x
    sta (_line_start),y

    // move to previous character
    ldx _plot_ch_x
    dex
    cpx _screen_render_x_wrap
    beq RenderNextLine
    
    stx _plot_ch_x
    dec _maze_x_tmp
    jmp innerloop

    RenderNextLine
    ldx _plot_ch_y
    dex
    cpx _screen_render_y_wrap
    bmi complete
    
    ; move maze data to previous line
    stx _plot_ch_y
    lda _screen_render_right
    sta _plot_ch_x
    dec _maze_y_tmp
    lda _maze_right
    sta _maze_x_tmp
    jmp loop

complete

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
   jmp ScreenRender

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
    rts       
.)
rts
  
.)

; <<<<<< ScreenRender
; -----------------------------------------------------------------
