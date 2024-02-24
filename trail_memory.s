; allow 3 bytes for each section of the trail data
; each 'record' will contain x_pos, y_pos and the previous char at that position
trail_x_pos_player_1 .dsb TRAIL_MEMORY_LENGTH,1 
trail_y_pos_player_1 .dsb  TRAIL_MEMORY_LENGTH,2
trail_char_player_1 .dsb TRAIL_MEMORY_LENGTH,3

trail_x_pos_player_2 .dsb  TRAIL_MEMORY_LENGTH,1 
trail_y_pos_player_2 .dsb  TRAIL_MEMORY_LENGTH,2
trail_char_player_2 .dsb TRAIL_MEMORY_LENGTH,3



initTrailMemory
.(
  lda #00
  ldy #00
  loop
  sta trail_x_pos_player_1,Y
  sta trail_y_pos_player_1,Y
  sta trail_char_player_1,y
  sta trail_x_pos_player_2,Y
  sta trail_y_pos_player_2,Y
  sta trail_char_player_2,y
  iny
  cpy #TRAIL_MEMORY_LENGTH
  bne loop

  sta trail_index_player_1
  sta trail_index_player_2
  rts
.)


addTrailItemPlayer1
.(
  ldy trail_index_player_1
  cpy #TRAIL_MEMORY_LENGTH
  bne add
  ldy #0
  sty trail_index_player_1
  add
  lda trailItemX
  sta trail_x_pos_player_1,y

  lda trailItemY
  sta trail_y_pos_player_1,y
  
  lda trailChar
  sta trail_char_player_1,y
  
  inc trail_index_player_1
  rts
.)

eraseTrailPlayer1
.(
  ldx #TRAIL_MEMORY_LENGTH-1
  loop
  ldy trail_index_player_1
  cpy #00
  bne doItWithDec
  ldy #TRAIL_MEMORY_LENGTH-1
  sty trail_index_player_1
  jmp doItWithNoDec

  doItWithDec
  dey
  sty trail_index_player_1
  :doItWithNoDec
  ;get xpos - if it is zero then the entry is empty and we're done
  lda trail_x_pos_player_1,y
  beq done
  sta trailItemX

  lda trail_y_pos_player_1,Y
  sta trailItemY

  lda trail_char_player_1,Y
  sta trailChar

  ; restore the character for the trail item
  ldy trailItemY
  lda OffscreenLineLookupLo,y
  sta _line_start_lo
  lda OffscreenLineLookupHi,y
  sta _line_start_hi
  ldy trailItemX
  lda trailChar
  sta (_line_start),y

  dex
  cpx #00
  beq done
  jmp loop
  
  done
    jsr initTrailMemory
    rts
.)


shredTrail
.(

.)


