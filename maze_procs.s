
; Display section of maze on screen
; Whilst this is currently working on a very basic level
; several changes must be made.
; - when processing a maze byte  process all BITs to prevent re-looking up the 
; maze data

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
    
    jmp plot_offscreen
:nowall
    ; plot some empty space
    lda #32

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
    adc #39
    sta _maze_x_tmp
    sta _maze_right

    lda _maze_top
    clc
    adc #28
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
    jmp loop

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
    cpx #KEY_LEFT_ARROW
    bne nextKey0
    lda _maze_left
    cmp #00
    beq nextKey0
    dec _maze_left

nextKey0
    cpx #KEY_RIGHT_ARROW
    bne nextKey1
    lda _maze_left
    cmp #206
    beq nextKey1
    inc _maze_left

nextKey1
    cpx #KEY_DOWN_ARROW
    bne nextKey2
    lda _maze_top
    cmp #49
    bpl nextKey2
    inc _maze_top

nextKey2
    cpx #KEY_UP_ARROW
    bne nextKey3
    lda _maze_top
    cmp #00
    beq nextKey3
    dec _maze_top

nextKey3
    jmp ScreenRender
.)





; <<<<< ScreenRender



    ;check key presses
    ;ldx KEY_PRESS_LOOKUP                     
    ;cpx #KEY_UP_ARROW                                         
    ;bne nextKey1
    ;lda maze_start_top
    ;dec maze_start_top+1

    ;nextKey1
    ;cpx #KEY_DOWN_ARROW
    ;bne nextKey2
    ;inc maze_start_top+1

    ;nextKey2
    ;cpx #KEY_RIGHT_ARROW
    ;bne nextKey3
    ;jsr scroll_right
    ;inc maze_start_left+1

    nextKey3
    ;cpx #KEY_LEFT_ARROW
    ;bne nextKey4
    k2
    ;jsr scroll_left
    ;dec maze_start_left+1

    nextKey4
    ;jmp screen_done; MazeDisplay;
    ;rts


;/// IN PROGREES
scroll_left
.(
    ldy #26 ; start at last line

process_line  
    sty _plot_ch_y;  
    lda ScreenLineLookupLo,Y
    sta _line_start_lo
    lda ScreenLineLookupHi,y
    sta _line_start_hi

    ldy #03 ; start at 2nd visible column
loop   
    lda (_line_start),Y
    dey ; copy into previous column
    sta (_line_start),Y
    iny
    iny
    cpy #39 ; check if we've reached right column
    beq prev_line
    jmp loop

    prev_line
    ldy _plot_ch_y
    dey
    cpy #00
    beq done    
    jmp process_line

    done
      ; TODO.. fill in right column
      rts

.)


scroll_right
.(
    ldy #26 ; start at last line

process_line  
    sty _plot_ch_y;  
    lda ScreenLineLookupLo,Y
    sta _line_start_lo
    lda ScreenLineLookupHi,y
    sta _line_start_hi

    ldy #38 ; start at last visible column
loop   
    lda (_line_start),Y
    iny ; copy into next column
    sta (_line_start),Y
    dey
    dey
    cpy #01 ; check if we've reached left column
    beq prev_line
    jmp loop

    prev_line
    ldy _plot_ch_y
    dey
    cpy #00
    beq done    
    jmp process_line

    done
      ; TODO.. fill in right column
      rts

.)






    
    
    






                                     