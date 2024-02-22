; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Render entire maze(/game area) to an offscreen buffer
; ------------------------------------------------------------------------------
_plot_index_y .dsb 1
_plot_index_x .dsb 1

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
    lda #(BRICK_WALL_CHAR_CODE + 128) ; +128 is plot as inverse
    
    jmp plot_offscreen
:nowall
    ; plot some empty space
    ;lda #32

    ; plot some random 'grains' to give a background texture to ensure a feeling of motion when scrolling through 'empty' space
    jsr _GetRand
    lda rand_low;
    and #15
    adc #97

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
    beq plotStuff;
    
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

plotStuff
    jsr plot_inner_walls
    jsr plotRandomBlocks
    jsr plotRandomBlackHoles

    
screen_done
    rts
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<




// Plot walls inside the game area to create obstacles
plot_inner_walls
.(
    lda #00                         ;set index to lookup first y position
    sta _plot_index_y
    .(
        y_loop
        // lookup y position
        ldy _plot_index_y           ; lookup y position for current y index
        lda inner_wall_y_positions,Y
        sta center_y                ; store center y positon for walls to be drawn
        beq done             ; exit if y position is zero
        inc _plot_index_y           ; otherwise move to next position.

        lda #00                     ; set index to lookup first x position
        sta _plot_index_x
        .(
            :x_loop
            ldy _plot_index_x               ;lookup x position for current x index
            lda inner_wall_x_positions,Y
            sta center_x                    ; store center x position for walls to be drawn.
            beq y_loop                      ; If x position is zero then goto next y position
            inc _plot_index_x               ; otherwise lookup next x position

            jsr plot_inner_plus             ; call routine to render obstacle
            
            jmp x_loop                      ; continue to loop x positions until last item in list is reached
        .)
    .)
    done
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


plotRandomBlocks
.(
    ldy #255
    sty y_temp

    .(
        :loop
        beq done
        jsr _GetRand
        lda rand_low
        sta _plot_ch_x
        jsr _GetRand
        lda rand_low
        cmp #78
        bpl skip
        tay
        lda OffscreenLineLookupLo,Y
        sta _maze_line_start_lo
        lda OffscreenLineLookupHi,y
        sta _maze_line_start_hi

        lda (_maze_line_start),Y ; check that the area doesn't alreayd contain an obstable
        clc
        and 127
        cmp #BRICK_WALL_CHAR_CODE
        bcs skip
        lda #RANDOM_BLOCK_CHAR_CODE + 128
        ldy _plot_ch_x
        sta (_maze_line_start),Y


        skip
        dec y_temp
        jmp loop
    .)
    done 
    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


plotRandomBlackHoles
.(
    ldy #10
    sty y_temp

    .(
        :loop
        beq screen_done
        jsr _GetRand
        lda rand_low
        cmp #249
        bcs no_skip
        sta _plot_ch_x
        jsr _GetRand
        lda rand_low
        cmp #74
        bcs no_skip
        clc
        adc #3
        sta _plot_ch_y
        tay
        lda OffscreenLineLookupLo,Y
        sta _maze_line_start_lo
        lda OffscreenLineLookupHi,y
        sta _maze_line_start_hi

        lda #BLACK_HOLE_TOP_LEFT_CHAR_CODE;
        ldy _plot_ch_x
        sta (_maze_line_start),Y
        iny
        lda #BLACK_HOLE_TOP_RIGHT_CHAR_CODE
        sta (_maze_line_start),y

        ldy _plot_ch_y
        iny
        lda OffscreenLineLookupLo,Y
        sta _maze_line_start_lo
        lda OffscreenLineLookupHi,y
        sta _maze_line_start_hi

        lda #BLACK_HOLE_BOTTOM_LEFT_CHAR_CODE;
        ldy _plot_ch_x
        sta (_maze_line_start),Y
        iny
        lda #BLACK_HOLE_BOTTOM_RIGHT_CHAR_CODE
        sta (_maze_line_start),y

        skip
        dec y_temp
        no_skip
        jmp loop
    .)
    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


:center_y
    .byt 0
:center_x
    .byt 0
:plus_size
    .byt 0
:y_temp
    .byt 0


plot_inner_plus
    .(
    lda #3
    sta plus_size

    ldy center_y
    lda OffscreenLineLookupLo,Y
    sta _line_start_lo
    lda OffscreenLineLookupHi,y
    sta _line_start_hi
    
    // Draw horizontal line
    lda center_x
    clc
    sbc plus_size
    tay
    iny
    lda plus_size
    adc plus_size
    tax
    
    :next_x
    txa
    beq draw_vertical
    dex
    lda #(BRICK_WALL_CHAR_CODE + 128); plot inverse
    sta (_line_start),y
    iny
    jmp next_x

    draw_vertical
    lda center_y
    clc
    sbc plus_size
    tay
    iny
    lda plus_size
    adc plus_size
    tax

    :vert_loop
    txa
    beq done
    lda OffscreenLineLookupLo,Y
    sta _line_start_lo
    lda OffscreenLineLookupHi,y
    sta _line_start_hi
    tya
    sta y_temp
    ldy center_x
    
    lda #(BRICK_WALL_CHAR_CODE + 128); plot inverse
    sta (_line_start),y

    lda y_temp
    tay
    iny
    dex
    jmp vert_loop



    done
    rts
    .)
