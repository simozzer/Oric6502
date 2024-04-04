/*
1.) This unit also requires lookup.s, or you could include the following:

;////////////////////////////////////
; Lookup tables for lo and hi bytes 
; of each line in text mode
;////////////////////////////////////
:ScreenLineLookupLo 
  .byt $A8,$D0,$F8,$20,$48,$70,$98,$C0,$E8,$10                        
  .byt $38,$60,$88,$B0,$D8,$00,$28,$50,$78,$A0                            
  .byt $C8,$F0,$18,$40,$68,$90,$B8  

:ScreenLineLookupHi 
  .byt $BB,$BB,$BB,$BC,$BC,$BC,$BC,$BC,$BC,$BD                        
  .byt $BD,$BD,$BD,$BD,$BD,$BE,$BE,$BE,$BE,$BE                            
  .byt $BE,$BE,$BF,$BF,$BF,$BF,$BF


2.) Also need zero page variables declaring e.g.

_line_start
_line_start_lo .dsb 1
_line_start_hi .dsb 1
_secondary_line_start
_secondary_line_start_lo .dsb 1
_secondary_line_start_hi .dsb 1

*/

effect_index .dsb 1,0 ;used as a parameter to determine which row/column to process
temp_effect_char .dsb 1,0 ;used for temporary storage for wrapping characters when scrolling
_temp_effect_char .dsb 1,0;used for temporary storage in inner loop for wrapping characters when scrolling 
effect_temp .dsb 1,0 ; used to keep count of the number of iterations for repeated operations
inner_effect_temp .dsb 1,0 ; used to keep count of the number of iterations for repeated operations
_temp_row_index .dsb 1,0; used to store row index on routines when scrolling columns up or down
_temp_row_data .dsb 40,0; used to store the contents of an entire row of character data


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; _scrollRowLeft: scrolls an individual row 1 position left. The
; character in the leftmost position will appear on the right
; Params: 
;   effect_index: The index of the row to be scrolled
; Returns: null
; -------------------------------------------------------------------
_max_col_index .byt 1
_scrollRowLeft
.(
  ldy effect_index
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,Y
  sta _line_start_hi

  ; copy char from left column into temp_effect_char
  ldy screen_area_left
  lda (_line_start),y
  sta temp_effect_char

  ; calculate last column
  lda screen_area_width
  clc
  adc screen_area_left
  sta _max_col_index
  
  ; move all chars left
  ldy screen_area_left
  iny
  loop
  lda (_line_start),Y
  dey
  sta (_line_start),Y
  iny
  iny
  cpy _max_col_index
  bne loop

  ; copy the character from the 1st column into the last column
  ldy _max_col_index
  dey
  lda temp_effect_char
  sta (_line_start),y

  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; _wrapRowLeft: scrolls an individual row left until the line is returned
; to its original state
; Params: 
;   effect_index: The index of the row to be scrolled
; Returns: null
; -------------------------------------------------------------------
_wrapRowLeft
.(
  lda screen_area_left
  clc
  adc screen_area_width
  sec
  sbc #02
  sta _wrap_col_last_index

  lda screen_area_left
  sec
  sbc #02
  sta inner_effect_temp
  loop
  jsr _scrollRowLeft
  jsr _effectDelay
  inc inner_effect_temp
  lda inner_effect_temp
  cmp _wrap_col_last_index
  bne loop
  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; _wrapRowRight: scrolls an individual row right until the line is returned
; to its original state
; Params: 
;   effect_index: The index of the row to be scrolled
; Returns: null
; -------------------------------------------------------------------
_wrap_col_last_index .byt 1
_wrapRowRight
.(
  lda screen_area_left
  clc
  adc screen_area_width
  sec
  sbc #02
  sta _wrap_col_last_index

  lda screen_area_left
  sec
  sbc #02
  sta inner_effect_temp
  loop
  jsr _scrollRowRight
  jsr _effectDelay
  inc inner_effect_temp
  lda inner_effect_temp
  cmp _wrap_col_last_index
  bne loop
  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; _scrollRowRight: scrolls an individual row 1 position right. The
; character in the rightmost position will appear on the left
; Params: 
;   effect_index: The index of the row to be scrolled
; Returns: null
; -------------------------------------------------------------------
_min_col_index .byt 1
_scrollRowRight
.(
  ldy effect_index
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,Y
  sta _line_start_hi

  ;calculate min col index
  lda screen_area_left
  sec
  sbc #01
  sta _min_col_index

  
  ; copy char from right column into temp_effect_char
  lda screen_area_width
  clc
  adc screen_area_left
  sec
  sbc #01
  tay

  lda (_line_start),y
  sta temp_effect_char
  
  ; move all chars right
  lda screen_area_width
  clc
  adc screen_area_left
  sec
  sbc #02
  tay
  loop
  lda (_line_start),Y
  iny
  sta (_line_start),Y
  dey
  dey
  cpy _min_col_index
  bne loop

  ; copy the character from the last column into the 1st column
  ldy screen_area_left
  lda temp_effect_char
  sta (_line_start),y

  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<





; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; _scrollScreenLeft: scrolls entire screen 1 position left. The
; characters in the leftmost position will appear on the right
; Params: none
; Returns: null
; -------------------------------------------------------------------
_scrollScreenLeft
.(
  ldx screen_area_top
  loop
  stx effect_index
  jsr _scrollRowLeft
  inx
  cpx screen_area_height
  bne loop
  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; _scrollScreenRight: scrolls entire screen 1 position right. The
; characters in the rightmost position will appear on the left
; Params: none
; Returns: null
; -------------------------------------------------------------------
_scrollScreenRight
.(
  ldx screen_area_top
  loop
  stx effect_index
  jsr _scrollRowRight
  inx
  cpx screen_area_height
  bne loop
  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; wrapScreenLeft: scrolls entire screen left until the screen is
; back in its original state
; Params: none
; Returns: null
; -------------------------------------------------------------------
_wrapScreenLeft
.(
  lda screen_area_top
  sta effect_temp
  tay
  loop
  jsr _scrollScreenLeft
  ldy effect_temp
  iny
  sty effect_temp
  cpy screen_area_width
  bcc loop
  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; wrapScreenRight: scrolls entire screen right until the screen is
; back in its original state
; Params: none
; Returns: null
; -------------------------------------------------------------------
_wrapScreenRight
.(
  lda #0
  sta effect_temp
  tay
  loop
  jsr _scrollScreenRight
  ldy effect_temp
  iny
  sty effect_temp
  cpy screen_area_width
  bcc loop
  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; shredScreenLeft: scrolls each row left, in turn, until the screen
; is returned to its original state
; original state
; Returns: null
; -------------------------------------------------------------------
_shredScreenLeft
.(


  lda screen_area_top
  sta effect_index
  loop
  jsr _wrapRowLeft
  inc effect_index

  lda effect_index
  cmp screen_area_height
  bne loop

  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; shredScreenRight: scrolls each row right, in turn, until the screen
; is returned to its original state
; original state
; Returns: null
; -------------------------------------------------------------------
_shredScreenRight
.(
  lda #0
  sta effect_index
  loop
  jsr _wrapRowRight
  inc effect_index

  lda effect_index
  cmp #27
  bne loop

  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<




; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; shredScreenHorizontal: scrolls alternate rows in different 
; directions, and continues until the screen is back in its
; original state
; Returns: null
; -------------------------------------------------------------------
_max_row_index .byt 1
_shredScreenHorizontal
.(
  ; calculate max row index
  lda screen_area_height
  clc
  adc #01
  sta _max_row_index

  lda screen_area_left
  sec
  sbc #02
  sta effect_temp

  screenLoop
  lda screen_area_top
  sta effect_index

  tay
  lineLoop
  jsr _scrollRowLeft
  inc effect_index
  lda effect_index
  cmp screen_area_height
  beq linesDone
  jsr _scrollRowRight
  inc effect_index

  jsr _effectDelay

  lda effect_index
  cmp _max_row_index
  bne lineLoop

  linesDone
  inc effect_temp
  lda effect_temp
  cmp screen_area_width
  bne screenLoop

  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<





; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; _scrollColumnUp: scrolls an individual column 1 position up. The
; character in the top position will appear on the bottom
; Params: 
;   effect_index: The index of the column to be scrolled
; Returns: null
; -------------------------------------------------------------------
_scrollColumnUp
.(
  ; get the character from the 1st row and store it
  ldy #0
  lda ScreenLineLookupLo,y
  sta _line_start_lo
  lda ScreenLineLookupHi,y
  sta _line_start_hi
  ldy effect_index
  lda (_line_start),y
  sta temp_effect_char

  ; move all characters up one position
  lda #1
  sta _temp_row_index
  __loopy
  ldy _temp_row_index
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,y
  sta _line_start_hi
  ldy effect_index

  ; pull the char for the current line and store it
  lda (_line_start),y
  sta _temp_effect_char

  ldy _temp_row_index
  dey
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,y
  sta _line_start_hi
  ; retrieve the stored char and put it on the previous line
  ldy effect_index
  lda _temp_effect_char
  sta (_line_start),y

  ; go to the next line
  inc _temp_row_index
  lda _temp_row_index
  cmp #27
  bne __loopy

  ; put the character which was on the first row onto the last
  ldy #26
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,y
  sta _line_start_hi

  lda temp_effect_char
  ldy effect_index
  sta (_line_start),y

  rts
.)



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; _scrollColumnDown: scrolls an individual column 1 position down. The
; character in the bottom position will appear on the top
; Params: 
;   effect_index: The index of the column to be scrolled
; Returns: null
; -------------------------------------------------------------------
_scrollColumnDown
.(
  ; get the character from the last row and store it
  ldy #26
  lda ScreenLineLookupLo,y
  sta _line_start_lo
  lda ScreenLineLookupHi,y
  sta _line_start_hi
  ldy effect_index
  lda (_line_start),y
  sta temp_effect_char

  ; move all characters down one position
  lda #25
  sta _temp_row_index
  _loop_y
  ldy _temp_row_index
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,y
  sta _line_start_hi
  ldy effect_index

  ; pull the char for the current line and store it
  lda (_line_start),y
  sta _temp_effect_char

  ldy _temp_row_index
  iny
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,y
  sta _line_start_hi
  ; retrieve the fetched character on put it on the next line
  ldy effect_index
  lda _temp_effect_char
  sta (_line_start),y

  ; go to the next line
  dec _temp_row_index
  lda _temp_row_index
  cmp #0
  bpl _loop_y

  ; put the character which was on the last row onto the first
  ldy #0
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,y
  sta _line_start_hi

  lda temp_effect_char
  ldy effect_index
  sta (_line_start),y

  rts
.)




; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; shredScreenVertical: scrolls alternate columns in different 
; directions, and continues until the screen is back in its
; original state
; Returns: null
; -------------------------------------------------------------------
shredScreenVertical
.(
  lda #0
  sta effect_temp

  screenLoop
  lda #2
  sta effect_index

  tay
  lineLoop
  jsr _scrollColumnDown
  inc effect_index
  lda effect_index
  cmp #37
  beq linesDone
  jsr _scrollColumnUp
  inc effect_index

  lda effect_index
  cmp #38
  bne lineLoop

  linesDone
  inc effect_temp
  lda effect_temp
  cmp #27
  bne screenLoop

  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; _wrapColumnUp: scrolls an individual column up until the line is returned
; to its original state
; Params: 
;   effect_index: The index of the column to be scrolled
; Returns: null
; -------------------------------------------------------------------
_wrapColumnUp
.(
  lda #0
  sta inner_effect_temp
  loop
  jsr _scrollColumnUp
  jsr _effectDelay
  inc inner_effect_temp
  lda inner_effect_temp
  cmp #27
  bne loop
  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; _wrapColumnDown: scrolls an individual column down until the line is returned
; to its original state
; Params: 
;   effect_index: The index of the column to be scrolled
; Returns: null
; -------------------------------------------------------------------
_wrapColumnDown
.(
  lda #0
  sta inner_effect_temp
  loop
  jsr _scrollColumnDown
  jsr _effectDelay
  inc inner_effect_temp
  lda inner_effect_temp
  cmp #27
  bne loop
  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; shredScreenUp: scrolls each column up, in turn, until the screen
; is returned to its original state
; original state
; Returns: null
; -------------------------------------------------------------------
shredScreenUp
.(
  lda #2
  sta effect_index
  loop
  jsr _wrapColumnUp
  inc effect_index

  lda effect_index
  cmp #39
  bne loop

  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; shredScreenDown: scrolls each column down, in turn, until the screen
; is returned to its original state
; original state
; Returns: null
; -------------------------------------------------------------------
shredScreenDown
.(
  lda #2
  sta effect_index
  loop
  jsr _wrapColumnDown
  inc effect_index

  lda effect_index
  cmp #39
  bne loop

  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<




; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; _scrollScreenUp: scrolls entire screen 1 position up. The
; characters in the top position will appear on the bottom
; Params: none
; Returns: null
; -------------------------------------------------------------------
_scrollScreenUp
.(
  ; copy 1st row into buffer
  ldy #0
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,y
  sta _line_start_hi

  ldy #2
  copyFirstLineLoop
  lda (_line_start),Y
  sta _temp_row_data,y
  iny
  cpy #38
  bne copyFirstLineLoop

  ; copy rest of the rows up
  ldy #1
  sty _temp_row_index

  copyAllLinesLoop
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,y
  sta _line_start_hi
  dey
  lda ScreenLineLookupLo,Y
  sta _secondary_line_start_lo
  lda ScreenLineLookupHi,Y
  sta _secondary_line_start_hi
  iny
  iny
  sty _temp_row_index

  ldy #2
  copyCharsInLineLoop
  lda (_line_start),Y
  sta (_secondary_line_start),Y
  iny
  cpy #39
  bne copyCharsInLineLoop

  ldy _temp_row_index
  cpy #27
  bne copyAllLinesLoop

  ;copy data from buffer onto last row
  ldy #26
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,Y
  sta _line_start_hi

  ldy #2
  plotLastRow
  lda _temp_row_data,Y
  sta (_line_start),Y
  iny
  cpy #38
  bne plotLastRow

  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; _scrollScreenDown: scrolls entire screen 1 position down. The
; characters in the bottom position will appear on the top
; Params: none
; Returns: null
; -------------------------------------------------------------------
_scrollScreenDown
.(
  ; copy last row into buffer
  ldy #26
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,y
  sta _line_start_hi

  ldy #2
  copyLastLineLoop
  lda (_line_start),Y
  sta _temp_row_data,y
  iny
  cpy #38
  bne copyLastLineLoop

  ; copy rest of the rows down
  ldy #25
  sty _temp_row_index

  copyAllLinesLoop
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,y
  sta _line_start_hi
  iny
  lda ScreenLineLookupLo,Y
  sta _secondary_line_start_lo
  lda ScreenLineLookupHi,Y
  sta _secondary_line_start_hi
  dey
  dey
  sty _temp_row_index

  ldy #2
  copyCharsInLineLoop
  lda (_line_start),Y
  sta (_secondary_line_start),Y
  iny
  cpy #39
  bmi copyCharsInLineLoop

  ldy _temp_row_index
  cpy #$ff
  bne copyAllLinesLoop

  ;copy data from buffer onto 1st row
  ldy #0
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,Y
  sta _line_start_hi

  ldy #2
  plotFirstRow
  lda _temp_row_data,Y
  sta (_line_start),Y
  iny
  cpy #38
  bne plotFirstRow

  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; wrapScreenUp: scrolls entire screen up until the screen is
; back in its original state
; Params: none
; Returns: null
; -------------------------------------------------------------------
wrapScreenUp
.(
  lda #0
  sta effect_temp
  tay
  loop
  jsr _scrollScreenUp
  ldy effect_temp
  iny
  sty effect_temp
  cpy #27
  bcc loop
  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; wrapScreenDown: scrolls entire screen down until the screen is
; back in its original state
; Params: none
; Returns: null
; -------------------------------------------------------------------
wrapScreenDown
.(
  lda #0
  sta effect_temp
  tay
  loop
  jsr _scrollScreenDown
  ldy effect_temp
  iny
  sty effect_temp
  cpy #27
  bcc loop
  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Perform a short delay to slow down an effect
; -------------------------------------------------------------------
_effectDelay
.(    
    ; a small delay
    ldy #200
    loop
    dey
    nop
    cpy #00
    Bne loop
    rts    
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


shake
.(
  jsr _scrollScreenLeft
  jsr _scrollScreenUp
  jsr _scrollScreenRight  
  jsr _scrollScreenDown

  jsr _scrollScreenUp
  jsr _scrollScreenLeft
  jsr _scrollScreenDown  
  jsr _scrollScreenRight
  rts
.)