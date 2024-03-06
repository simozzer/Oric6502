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
    jsr plotRandomErasers
    jsr plotRandomBlocks
    ;TODO revert jsr plot_inner_walls
    jsr plotRandomSlowSigns
    
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
        cmp #00
        beq doneIt                  ; exit if y position is zero
        
        sta center_y                ; store center y positon for walls to be drawn
        
        inc _plot_index_y           ; otherwise move to next position.

        lda #00                     ; set index to lookup first x position
        sta _plot_index_x
        .(
            :x_loop
            ldy _plot_index_x               ;lookup x position for current x index
            lda inner_wall_x_positions,Y
            sta center_x                    ; store center x position for walls to be drawn.
            cmp #00
            beq y_loop                      ; If x position is zero then goto next y position
            inc _plot_index_x               ; otherwise lookup next x position

            jsr plot_inner_plus             ; call routine to render obstacle
            
            jmp x_loop                      ; continue to loop x positions until last item in list is reached
        .)
    .)
    doneIt
    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


plotRandomBlocks
.(
    ldy #100
    sty y_temp

    .(
        :loop
        beq done
        jsr _GetRand
        lda rand_low
        cmp #253
        bcs skip_
        clc
        adc #2
        sta _plot_ch_x
        jsr _GetRand
        lda rand_low
        cmp #78
        bcs skip_
        clc
        adc #1
        tay
        lda OffscreenLineLookupLo,Y
        sta _maze_line_start_lo
        lda OffscreenLineLookupHi,y
        sta _maze_line_start_hi

        lda #BRICK_WALL_CHAR_CODE + 128
        ldy _plot_ch_x
        sta (_maze_line_start),Y


        skip_
        dec y_temp
        jmp loop
    .)
    done 
    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


plotRandomBlackHoles
.(
    ldy #6
    sty y_temp

    .(
        :loop
        beq screen_done
        jsr _GetRand
        lda rand_low
        cmp #249
        bcs skip
        sta _plot_ch_x
        jsr _GetRand
        lda rand_low
        cmp #74
        bcs skip
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
        jmp loop
    .)
    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


plotRandomErasers
.(
    ldy #100
    sty y_temp

    .(
        :loop
        beq done
        jsr _GetRand
        lda rand_low
        cmp #252
        bcs skip
        adc #01
        sta _plot_ch_x
        jsr _GetRand
        lda rand_low
        cmp #78
        bcs skip
        adc #2
        tay
        lda OffscreenLineLookupLo,Y
        sta _maze_line_start_lo
        lda OffscreenLineLookupHi,y
        sta _maze_line_start_hi
        lda #ERASER_CHAR_CODE
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


plotRandomSlowSigns
.(
    ldy #100
    sty y_temp

    .(
        :loop
        beq done
        jsr _GetRand
        lda rand_low
        cmp #250
        bcs skip
        adc #01
        sta _plot_ch_x
        jsr _GetRand
        lda rand_low
        cmp #77
        bcs skip
        adc #2
        tay
        lda OffscreenLineLookupLo,Y
        sta _maze_line_start_lo
        lda OffscreenLineLookupHi,y
        sta _maze_line_start_hi
        lda #SLOW_CHAR_CODE_LEFT
        ldy _plot_ch_x
        sta (_maze_line_start),Y
        lda #SLOW_CHAR_CODE_MID
        iny
        sta (_maze_line_start),Y
        lda #SLOW_CHAR_CODE_RIGHT
        iny
        sta (_maze_line_start),Y

        skip
        dec y_temp
        jmp loop
    .)
    done 
    rts
.)

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; plotSafeSpace: fill an area with 'safe characters'. This is used to ensure that
;    when the game starts a player has a small 'safe-zone' so that they don't
;    crash immediately.
; params : center_x, center_y
;-------------------------------------------------------------------------------
plotSafeSpace
.(
    lda center_x
    clc
    adc #08
    sta last_x+1

    lda center_x
    clc
    sbc #08
    sta startx +1

    lda center_y
    clc
    adc #08
    sta last_y+1

    lda center_y
    clc
    sbc #08
    sta center_y

    tay
    loopy
        ;ldy center_y
        lda OffscreenLineLookupLo,Y 
        sta _line_start_lo
        lda OffscreenLineLookupHi,Y
        sta _line_start_hi

        :startx
        ldy #00; will be self modified

        loopx
        tya ; save y param, as this is modified in _GetRand
        pha

        ; get a random 'grain' to plot
        jsr _GetRand
        lda rand_low;
        and #15
        adc #97
        sta grain+1

        pla ; restore y param
        tay
        :grain
        lda #$ff; will be self modified
        sta (_line_start),y
        iny
        :last_x
        cpy #$ff; will be self modified
        bne loopx

        ldy center_y
        iny 
        sty center_y
        :last_y
        cpy #$ff; will be self modified
        bne loopy

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
