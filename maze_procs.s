
; Render maze data into an offscreen area.
; - when processing a maze byte  process all BITs to prevent re-looking up the 
; maze data (to optimise)



;; -----------------------------------------------------------------
; >>>>> MazeRender
; Render entire maze(/game area) to an offscreen buffer
:MazeRender

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
    jsr _GetRand

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
; -----------------------------------------------------------------


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