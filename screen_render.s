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

 
.)

; <<<<<< ScreenRender
; -----------------------------------------------------------------
