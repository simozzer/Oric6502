
; Display section of maze on screen
; Whilst this is currently working on a very basic level
; several changes must be made.
; - when processing a maze byte  process all BITs to prevent re-looking up the 
; maze data

; This will eventually render off screen to another area, and that area will be rendered on screen
; (which should be much faster)
:MazeDisplay
// set the position of the maze
maze_start_left
    lda #00; left
    sta _maze_left
maze_start_top
    lda #00 ; top
    sta _maze_top

// set the position for plotting on the screen
    lda #TEXT_FIRST_COLUMN
    sta _plot_ch_x
    lda #00
    sta _plot_ch_y

// get the screen address for the 1st line

    ldy _plot_ch_y                  ; Load row value                     
    lda LineLookupLo,Y              ; lookup low byte for row value and store
    sta _line_start_lo               
    lda LineLookupHi,Y              ; lookup hi byte for row value and store
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
    lda #97
    
    jmp plot_on_screen
:nowall
    ; plot some empty space
    lda #32

plot_on_screen
    ldy _plot_ch_x;
    sta (_line_start),y

    cpy #TEXT_LAST_COLUMN
    beq nexty;


    inc _plot_ch_x;
    inc _maze_left;
    jmp getMazeByte;

    nexty ldx _plot_ch_y;
    cpx #TEXT_LAST_LINE
    beq screen_done;
    
    ;move to next line
    ldx #TEXT_FIRST_COLUMN
    stx _plot_ch_x;
    inc _plot_ch_y;
    ldx maze_start_left+1
    ldy _plot_ch_y                 ; Load row value                     
    lda LineLookupLo,Y    ; lookup low byte for row value and store
    sta _line_start_lo                
    lda LineLookupHi,Y     ; lookup hi byte for row value and store
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

    ;check key presses
    ldx KEY_PRESS_LOOKUP                     
    cpx #KEY_UP_ARROW                                         
    bne nextKey1
    lda maze_start_top
    dec maze_start_top+1

    nextKey1
    cpx #KEY_DOWN_ARROW
    bne nextKey2
    inc maze_start_top+1

    nextKey2
    cpx #KEY_RIGHT_ARROW
    bne nextKey3
    inc maze_start_left+1

    nextKey3
    cpx #KEY_LEFT_ARROW
    bne nextKey4
    k2
    dec maze_start_left+1

    nextKey4
    jmp MazeDisplay;
    rts
    
    
    






                                     