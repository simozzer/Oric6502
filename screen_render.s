; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Plot a section of the maze to an area of the screen.
; This routine calculates the area to display based on
; the current position of the player
; ------------------------------------------------------------------------------
plotArea
.(
  ; calculate half width
  lda screen_area_width
  lsr 
  sta screen_area_half_width

  ; calculate half height
  lda screen_area_height
  lsr
  sta screen_area_half_height

  ; Calculate game area top

  ; if player_y > (OFFSCREEN_LAST_ROW - screen_area_half_height) 
  ; then game_area_top = (OFFSCREEN_LAST_ROW - screen_area_height)
  lda #OFFSCREEN_LAST_ROW
  clc
  sbc screen_area_half_height
  sta temp_value
  
  lda player_y
  cmp temp_value
  bcs preventScrollingPastBottom

  ; if player_y < screen_area_half_height then game_area_top = 0
  lda player_y
  cmp screen_area_half_height
  bcc preventScrollingPastTop

  ;otherwise game_area_top = player_y - half_screen_height
  clc
  sbc screen_area_half_height
  sta game_area_top
  bpl calculateLeft
  inc game_area_top
  jmp calculateLeft

  preventScrollingPastBottom
  lda #OFFSCREEN_LAST_ROW
  clc
  adc #01
  sbc screen_area_height
  sta game_area_top
  jmp calculateLeft

  preventScrollingPastTop
  lda #0
  sta game_area_top

  :calculateLeft 
  ; if player_x > (OFFSCREEN_LAST_COLUMN - screen_area_half_width) 
  ; then game_area_left = (OFFSCREEN_LAST_COLUMN - screen_area_half_width)
  lda #OFFSCREEN_LAST_COLUMN
  clc
  adc #01
  sbc screen_area_half_width
  sta temp_value
  
  lda player_x
  cmp temp_value
  bcs preventScrollingPastRight

  ; if player_x < screen_area_half_width then game_area_left = 0
  lda player_x
  cmp screen_area_half_width
  bcc preventScrollingPastLeft

  ;otherwise game_area_left = player_x - half_screen_width
  clc
  sbc screen_area_half_width
  sta game_area_left
  bpl plotOnScreen
  inc game_area_left

  jmp plotOnScreen

  preventScrollingPastRight
  lda #OFFSCREEN_LAST_COLUMN
  clc
  adc #02
  clc
  sbc screen_area_width
  sta game_area_left
  jmp plotOnScreen

  preventScrollingPastLeft
  lda #0
  sta game_area_left

  :plotOnScreen
  ; game_area_left, game_area_top are the topLeft position in the offscreen data
  lda game_area_top
  sta game_area_y
  lda game_area_left
  sta game_area_x
  lda screen_area_left
  sta screen_area_x
  clc
  adc screen_area_width
  sta screen_area_last_col
  lda screen_area_top
  sta screen_area_y
  clc
  adc screen_area_height
  sta screen_area_last_row

  
  :plotNextLine
  ldy game_area_y
  ; lookup the offscreen row
  lda OffscreenLineLookupLo,Y
  sta _maze_line_start_lo
  lda OffscreenLineLookupHi,y
  sta _maze_line_start_hi

  :plotChar
  ; lookup the correct column in the offscreen row
  ldy game_area_x
  lda (_maze_line_start),y
  sta temp_value ;temp value now contains the ascii code of the character to plot

  ; lookup the onscreen row
  ldy screen_area_y
  lda ScreenLineLookupLo,y
  sta _line_start_lo
  lda ScreenLineLookupHi,Y
  sta _line_start_hi

  ;plot the character on the screen
  lda temp_value
  ldy screen_area_x
  sta (_line_start),y

  ; move to the next column
  iny
  cpy screen_area_last_col
  beq nextRow
  sty screen_area_x
  inc game_area_x
  jmp plotChar

  nextRow
  lda screen_area_left
  sta screen_area_x
  ldy screen_area_y
  iny
  cpy screen_area_last_row
  beq done
  sty screen_area_y
  inc game_area_y
  lda game_area_left
  sta game_area_x
  jmp plotNextLine


  done
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


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Render splitter for top to bottom mode
; ---------------------------------------
renderTopBottomSplitter
.(
    ldy #13
    lda ScreenLineLookupLo,y
    sta _line_start_lo
    lda ScreenLineLookupHi,Y
    sta _line_start_hi

    ldy #39
    lda #TOP_BOTTTOM_SPLITTER

    loop
      cpy #01
      beq done
      :writeSplitter
      sta (_line_start),y
      dey
      jmp loop
    

    done
    rts    
.)    
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
