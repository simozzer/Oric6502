; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Render a section of the maze to an area of the screen
; ------------------------------------------------------------------------------
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
    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Render a spliiter in the centre of the screen for side by side mode
; ( This is a lazy implementation and could easily be improved,
;   I haven't bothered because it's not time critical )
; ------------------------------------------------------------------------------
renderSideBySideSplitter
    ldy #FULLSCREEN_TEXT_LAST_LINE
.(
    leftLoop
    lda ScreenLineLookupLo,Y
    sta writeLeftSplitter+1
    lda ScreenLineLookupHi,y
    sta writeLeftSplitter+2
    
    ldx #20;
    lda #SIDE_BY_SIDE_SPLITTER_LEFT_CHAR_CODE + 128
    :writeLeftSplitter sta $ffff,X
    dey
    cpy #00 
    bpl leftLoop

    ldy #FULLSCREEN_TEXT_LAST_LINE
    rightLoop
    lda ScreenLineLookupLo,Y
    sta writeRightSplitter+1
    lda ScreenLineLookupHi,y
    sta writeRightSplitter+2
    
    ldx #21;
    lda #SIDE_BY_SIDE_SPLITTER_RIGHT_CHAR_CODE + 128
    :writeRightSplitter sta $ffff,X
    dey
    cpy #00
    bpl rightLoop

    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
