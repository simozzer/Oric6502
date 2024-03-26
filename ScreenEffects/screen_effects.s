effect_index .byt 1
temp_effect_char .byt 1

scrollLineLeft
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

scrollLineRight
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

scrollScreenLeft
.(
  ldx #0
  loop
  stx effect_index
  jsr scrollLineLeft
  inx
  cpx #26
  bne loop
  rts
.)


scrollScreenRight
.(
  ldx #0
  loop
  stx effect_index
  jsr scrollLineRight
  inx
  cpx #26
  bne loop
  rts
.)

effect_temp .byt 1

wrapScreenLeft
.(
  lda #0
  sta effect_temp
  tay
  loop
  jsr scrollScreenLeft
  ldy effect_temp
  iny
  sty effect_temp
  cpy #38
  bcc loop
  rts
.)

wrapScreenRight
.(
  lda #0
  sta effect_temp
  tay
  loop
  jsr scrollScreenRight
  ldy effect_temp
  iny
  sty effect_temp
  cpy #38
  bcc loop
  rts
.)

shredScreenHorizontal
.(
  lda #0
  sta effect_temp

  screenLoop
  lda #0
  sta effect_index

  tay
  lineLoop
  jsr scrollLineLeft
  inc effect_index
  jsr scrollLineRight
  inc effect_index

  lda effect_index
  cmp #26
  bne lineLoop

  inc effect_temp
  lda effect_temp
  cmp #38
  bne screenLoop

  rts
.)
