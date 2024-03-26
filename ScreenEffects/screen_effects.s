effect_index .byt 1 ;used as a parameter to determine which row/column to process
temp_effect_char .byt 1 ;used for temporary storage for wrapping characters when scrolling
effect_temp .byt 1 ; used to keep count of the number of iterations for repeated operations
inner_effect_temp .byt 1 ; used to keep count of the number of iterations for repeated operations


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; _scrollRowLeft: scrolls an individual row 1 position left. The
; character in the leftmost position will appear on the right
; Params: 
;   effect_index: The index of the row to be scrolled
; Returns: null
; -------------------------------------------------------------------
_scrollRowLeft
.(
  ldy effect_index
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,Y
  sta _line_start_hi

  ; copy char from left column into temp_effect_char
  ldy #2
  lda (_line_start),y
  sta temp_effect_char
  
  ; move all chars left
  ldy #3
  loop
  lda (_line_start),Y
  dey
  sta (_line_start),Y
  iny
  iny
  cpy #40
  bne loop

  ; copy the character from the 1st column into the last column
  ldy #39
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
  lda #0
  sta inner_effect_temp
  loop
  jsr _scrollRowLeft
  jsr _effectDelay
  inc inner_effect_temp
  lda inner_effect_temp
  cmp #38
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
_wrapRowRight
.(
  lda #0
  sta inner_effect_temp
  loop
  jsr _scrollRowRight
  jsr _effectDelay
  inc inner_effect_temp
  lda inner_effect_temp
  cmp #38
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
_scrollRowRight
.(
  ldy effect_index
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,Y
  sta _line_start_hi

  
  ; copy char from right column into temp_effect_char
  ldy #39
  lda (_line_start),y
  sta temp_effect_char
  
  ; move all chars right
  ldy #38
  loop
  lda (_line_start),Y
  iny
  sta (_line_start),Y
  dey
  dey
  cpy #1
  bne loop

  ; copy the character from the last column into the 1st column
  ldy #2
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
  ldx #0
  loop
  stx effect_index
  jsr _scrollRowLeft
  inx
  cpx #27
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
  ldx #0
  loop
  stx effect_index
  jsr _scrollRowRight
  inx
  cpx #27
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
wrapScreenLeft
.(
  lda #0
  sta effect_temp
  tay
  loop
  jsr _scrollScreenLeft
  ldy effect_temp
  iny
  sty effect_temp
  cpy #38
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
wrapScreenRight
.(
  lda #0
  sta effect_temp
  tay
  loop
  jsr _scrollScreenRight
  ldy effect_temp
  iny
  sty effect_temp
  cpy #38
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
shredScreenLeft
.(
  lda #0
  sta effect_index
  loop
  jsr _wrapRowLeft
  inc effect_index

  lda effect_index
  cmp #27
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
shredScreenRight
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
shredScreenHorizontal
.(
  lda #0
  sta effect_temp

  screenLoop
  lda #0
  sta effect_index

  tay
  lineLoop
  jsr _scrollRowLeft
  inc effect_index
  lda effect_index
  cmp #27
  beq linesDone
  jsr _scrollRowRight
  inc effect_index

  lda effect_index
  cmp #28
  bne lineLoop

  linesDone
  inc effect_temp
  lda effect_temp
  cmp #38
  bne screenLoop

  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


_temp_row_index .byt 1


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
  loop
  ldy _temp_row_index
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,y
  sta _line_start_hi
  ldy effect_index

  ; pull the char for the current line and put it on the stack 
  lda (_line_start),y
  pha

  ldy _temp_row_index
  dey
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,y
  sta _line_start_hi
  ; pull the char from the stack on put it on the previous line
  ldy effect_index
  pla
  sta (_line_start),y

  ; go to the next line
  inc _temp_row_index
  lda _temp_row_index
  cmp #27
  bne loop

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
  loop
  ldy _temp_row_index
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,y
  sta _line_start_hi
  ldy effect_index

  ; pull the char for the current line and put it on the stack 
  lda (_line_start),y
  pha

  ldy _temp_row_index
  iny
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,y
  sta _line_start_hi
  ; pull the char from the stack on put it on the next line
  ldy effect_index
  pla
  sta (_line_start),y

  ; go to the next line
  dec _temp_row_index
  lda _temp_row_index
  cmp #0
  bpl loop

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
; Perform a short delay to slow down an effect
; -------------------------------------------------------------------
_effectDelay
.(    
    ; a small delay
    ldy #100
    loop
    dey
    nop
    cpy #00
    Bne loop
    rts    
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<