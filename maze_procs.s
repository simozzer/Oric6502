
; Display section of maze on screen
; Whilst this is currently working on a very basic level
; several changes must be made.
; - when processing a maze byte  process all BITs to prevent re-looking up the 
; maze data

:MazeDisplay
// set the position of the maze
maze_start_left
    lda #00; left
    sta _maze_left
maze_start_top
    lda #00 ; top
    sta _maze_top

// set the position for plotting on the screen
    lda #02
    sta _plot_ch_x
    lda #00
    sta _plot_ch_y

// get the screen address for the 1st line

    ldy _plot_ch_y                 ; Load row value                     
    lda LineLookupLo,Y    ; lookup low byte for row value and store
    sta plot_pos+1                
    lda LineLookupHi,Y     ; lookup hi byte for row value and store
    sta plot_pos+2

    ldy _maze_top
    lda mazeRowLookupTableLo,Y    ; lookup low byte for row value and store
    sta getTheByte+1               
    lda mazeRowLookupTableHi,Y     ; lookup hi byte for row value and store
    sta getTheByte+2

:getMazeBit


; find the correct byte from that row by dividing col b y 8
    ldx _maze_left
    lda divideBy8Table,x
    tax

:getTheByte
    lda $ffff,X
    sta _maze_byte ; should now contain the maze byte for the column and row

; Get the remainder of the above divison to find the
; correct BIT for the maze wall  ; Faster with lookup
    ldx _maze_left
    lda mod8Table,X

    tax
    lda reverseBitmaskTable,X

    ; Logical AND with accumulator AND $80 should tell us if bit is set (i.e there is a wall)
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
    ldx _plot_ch_x;
    :plot_pos sta $ffff,X

    ldx _plot_ch_x;
    cpx #39;
    beq nexty;
    inc _plot_ch_x;
    inc _maze_left;
    jmp getMazeBit

    nexty ldx _plot_ch_y;
    cpx #26
    beq screen_done;
    
    ;move to next line
    ldx #02
    stx _plot_ch_x;
    inc _plot_ch_y;
    ldx maze_start_left+1
    ldy _plot_ch_y                 ; Load row value                     
    lda LineLookupLo,Y    ; lookup low byte for row value and store
    sta plot_pos+1                
    lda LineLookupHi,Y     ; lookup hi byte for row value and store
    sta plot_pos+2

    stx _maze_left;
    inc _maze_top;

    ldy _maze_top
    lda mazeRowLookupTableLo,Y    ; lookup low byte for row value and store
    sta getTheByte+1               
    lda mazeRowLookupTableHi,Y     ; lookup hi byte for row value and store
    sta getTheByte+2
    jmp getMazeBit

screen_done

    ldx $0208                         
    cpx #KEY_UP_ARROW                                         
    bne nextKey1
    k0
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
    
    
    






                                     