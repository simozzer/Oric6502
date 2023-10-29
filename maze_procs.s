
; Display section of maze on screen
; Whilst this is currently working on a very basic level
; several changes must be made.
; - when processing a maze byte  process all BITs to prevent re-looking up the 
; maze data (i.e unroll the loop and increment screen x pos for all BITS processed)

:MazeDisplay
// set the position of the maze
    lda #$00 ; left
    sta _maze_left
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
    sta _plot_ascii
    ldx _plot_ch_x;
    :plot_pos sta $ffff,X
    //jsr plotchar; will be faster in-line

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
    ldx #00
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
    rts
    
    
    






                                     