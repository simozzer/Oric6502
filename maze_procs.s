
; Display section of maze on screen
; Whilst this is currently working on a very basic level
; several changes must be made.
; - when processing a maze byte  process all BITs to prevent re-looking up the 
; maze data

; >>>>> MazeRender
; Render entire maze(/game area) to an offscreen buffer
:MazeRender

// Initialise the random generator values (taken from kong, which was supplied with the OSDK)
	lda #23
	sta rand_low
	lda #35
	sta rand_high

// set the position of the maze
maze_start_left
    lda #00; left
    sta _maze_left
maze_start_top
    lda #00 ; top
    sta _maze_top

// set the position for plotting offscreen
    lda #00
    sta _plot_ch_x
    sta _plot_ch_y

// get the address for the 1st offscreen line
    ldy _plot_ch_y                  ; Load row value                     
    lda OffscreenLineLookupLo,Y              ; lookup low byte for row value and store
    sta _line_start_lo               
    lda OffscreenLineLookupHi,Y              ; lookup hi byte for row value and store
    sta _line_start_hi

    ldy _maze_top
    lda mazeRowLookupTableLo,Y      ; lookup low byte for row value and store
    sta _maze_line_start_lo               
    lda mazeRowLookupTableHi,Y      ; lookup hi byte for row value and store
    sta _maze_line_start_hi

:getMazeByte

    ; find the correct byte from row by dividing col b y 8
    ldy _maze_left
    lda divideBy8Table,y
    tay

    ; get the byte for the maze data
    lda (_maze_line_start),y
    sta _maze_byte ; should now contain the maze byte for the column and row

    ; Get the remainder of the above divison to find the
    ; correct BIT for the maze wall
    ldx _maze_left
    lda mod8Table,X

    tax
    lda reverseBitmaskTable,X

    ; Logical AND with accumulator should tell us if bit is set (i.e there is a wall)
    and _maze_byte

    ;; if accumulator is non zero there is a wall
    beq nowall
    
    ; Plot a section of wall
    lda #97 + 128 ; +128 is plot as inverse
    
    jmp plot_offscreen
:nowall
    ; plot some empty space
    ;lda #32

    ; plot some random 'grains' to give a background texture to ensure a feeling of motion when scrolling through 'empty' space
    jsr _GetRand
    lda rand_low;
    and #08
    adc #98

plot_offscreen
    ldy _plot_ch_x;
    sta (_line_start),y

    cpy #OFFSCREEN_LAST_COLUMN
    beq nexty;


    inc _plot_ch_x;
    inc _maze_left;
    jmp getMazeByte;

    nexty ldx _plot_ch_y;
    cpx #OFFSCREEN_LAST_ROW
    beq screen_done;
    
    ;move to next line
    ldx #0
    stx _plot_ch_x;
    inc _plot_ch_y;
    ldx maze_start_left+1
    ldy _plot_ch_y                 ; Load row value                     
    lda OffscreenLineLookupLo,Y    ; lookup low byte for row value and store
    sta _line_start_lo                
    lda OffscreenLineLookupHi,Y     ; lookup hi byte for row value and store
    sta _line_start_hi

    stx _maze_left;
    inc _maze_top;

    ldy _maze_top
    lda mazeRowLookupTableLo,Y    ; lookup low byte for row value and store
    sta _maze_line_start_lo              
    lda mazeRowLookupTableHi,Y     ; lookup hi byte for row value and store
    sta _maze_line_start_hi
    jmp getMazeByte

screen_done
    rts

; <<<<< MazeRender


; >>>>> ScreenRender
ScreenRender

    // set the start position for plotting on screen.
    lda #39
    sta _plot_ch_x
    lda #26
    sta _plot_ch_y

    // set the start position for grabbing data from offscreen
    lda _maze_left
    clc
    adc #37
    sta _maze_x_tmp
    sta _maze_right

    lda _maze_top
    adc #26
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
    cpx #01
    beq RenderNextLine
    
    stx _plot_ch_x
    dec _maze_x_tmp
    jmp innerloop

    RenderNextLine
    ldx _plot_ch_y
    dex
    cpx #00
    bmi complete
    
    ; move maze data to previous line
    stx _plot_ch_y
    lda #39
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
    sta _player_direction

nextKey0
    cpx #KEY_RIGHT_ARROW
    bne nextKey1
    lda #PLAYER_DIRECTION_RIGHT
    sta _player_direction

nextKey1
    cpx #KEY_DOWN_ARROW
    bne nextKey2
    lda #PLAYER_DIRECTION_DOWN
    sta _player_direction

nextKey2
    cpx #KEY_UP_ARROW
    bne updateMovement
    lda #PLAYER_DIRECTION_UP
    sta _player_direction
    

updateMovement
    lda _player_direction
    cmp #PLAYER_DIRECTION_LEFT
    bne checkRight

    ;scroll if we can
    lda _maze_left
    cmp #00
    beq movePlayerLeft
    dec _maze_left

    movePlayerLeft
    dec _player_x
    jmp renderPlayer

checkRight
    lda _player_direction
    cmp #PLAYER_DIRECTION_RIGHT
    bne checkUp

    ;scroll if we can
    lda _maze_left
    cmp #217
    beq movePlayerRight
    inc _maze_left

    movePlayerRight
    inc _player_x
    jmp renderPlayer

checkUp
    lda _player_direction
    cmp #PLAYER_DIRECTION_UP
    bne checkDown

    ;scroll if we can
    lda _maze_top
    cmp #00
    beq movePlayerUp
    dec _maze_top

    movePlayerUp
    dec _player_y
    jmp renderPlayer


checkDown
    lda _player_direction
    cmp #PLAYER_DIRECTION_DOWN
    bne checkDone

    ;scroll if we can
    lda _maze_top
    cmp #53
    beq movePlayerDown
    inc _maze_top

    movePlayerDown
    inc _player_y


renderPlayer
    ldy _player_y;
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi

    ; check for collision
    ldy _player_x
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

;// Taken from Kong source code 
;// Calculate some RANDOM values
;// Not accurate at all, but who cares ?
;// For what I need it's enough.
_GetRand
	lda rand_high
	sta b_tmp1
	lda rand_low
	asl 
	rol b_tmp1
	asl 
	rol b_tmp1
	asl
	rol b_tmp1
	asl
	rol b_tmp1
	clc
	adc rand_low
	pha
	lda b_tmp1
	adc rand_high
	sta rand_high
	pla
	adc #$11
	sta rand_low
	lda rand_high
	adc #$36
	sta rand_high
	rts