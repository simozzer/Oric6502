; allow 3 bytes for each section of the trail data
; each 'record' will contain x_pos, y_pos and the previous char at that position
trail_x_pos_player_1 .dsb TRAIL_MEMORY_LENGTH,1 
trail_y_pos_player_1 .dsb  TRAIL_MEMORY_LENGTH,2
trail_char_player_1 .dsb TRAIL_MEMORY_LENGTH,3

trail_x_pos_player_2 .dsb  TRAIL_MEMORY_LENGTH,1 
trail_y_pos_player_2 .dsb  TRAIL_MEMORY_LENGTH,2
trail_char_player_2 .dsb TRAIL_MEMORY_LENGTH,3

_temp_trail_index .dsb 1

initTrailMemory
.(
  ldy #PLAYER_DATA_OFFSET_TRAIL_DATA_X
  lda (_player_data),y ; lo
  sta initXTrailList+1
  iny
  lda (_player_data),y ;hi
  sta initXTrailList+2


  ldy #PLAYER_DATA_OFFSET_TRAIL_DATA_Y
  lda (_player_data),y ; lo
  sta initYTrailList+1
  iny
  lda (_player_data),y ;hi
  sta initYTrailList+2


  ldy #PLAYER_DATA_OFFSET_TRAIL_DATA_CHAR
  lda (_player_data),y ; lo
  sta initCharTrailList+1
  iny
  lda (_player_data),y ;hi
  sta initCharTrailList+2

  lda #00
  ldy #00
  loop
 
  :initXTrailList
  sta $ffff,y ; uses self modified value
  
  :initYTrailList
  sta $ffff,y ; uses self modified value

  :initCharTrailList
  sta $ffff,y ; uses self modified value
  
  iny
  cpy #TRAIL_MEMORY_LENGTH
  bne loop

  ldy #PLAYER_DATA_OFFSET_TRAIL_INDEX
  lda #0
  sta (_player_data),y

  rts
.)


addTrailItem
.(
  ldy #PLAYER_DATA_OFFSET_TRAIL_INDEX
  lda (_player_data),y  
  cmp #TRAIL_MEMORY_LENGTH
  bne add
  ldy #PLAYER_DATA_OFFSET_TRAIL_INDEX
  lda #0
  sta (_player_data),y
  add
  sta _temp_trail_index

  ; find the address of the trail data x position list
  ldy #PLAYER_DATA_OFFSET_TRAIL_DATA_X
  lda (_player_data),y ; lo
  sta storeXTrailList+1
  iny
  lda (_player_data),y ;hi
  sta storeXTrailList+2

  ; find the address of the trail data y position list
  ldy #PLAYER_DATA_OFFSET_TRAIL_DATA_Y
  lda (_player_data),y ; lo
  sta storeYTrailList+1
  iny
  lda (_player_data),y ;hi
  sta storeYTrailList+2

  ; find the address of the trail data char list
  ldy #PLAYER_DATA_OFFSET_TRAIL_DATA_CHAR
  lda (_player_data),y ; lo
  sta storeCharTrailList+1
  iny
  lda (_player_data),y ;hi
  sta storeCharTrailList+2

  ; store the x position in the list
  ldy _temp_trail_index
  lda trailItemX
  :storeXTrailList
  sta $ffff,y ; value is self modified

  ; store the y position in the list
  lda trailItemY
  :storeYTrailList
  sta $ffff,y ; value is self modified
  
  ; store the y position in the list
  lda trailChar
  :storeCharTrailList
  sta $ffff,y ; value is self modified

  tya
  clc
  adc #01
  ldy #PLAYER_DATA_OFFSET_TRAIL_INDEX
  sta (_player_data),y

  rts
.)


eraseTrail
.(
  ;setup pointers to the lists containing the trail memory 
  ldy #PLAYER_DATA_OFFSET_TRAIL_DATA_X
  lda (_player_data),y ; lo
  sta fetchXTrailList+1
  iny
  lda (_player_data),y ;hi
  sta fetchXTrailList+2

  ldy #PLAYER_DATA_OFFSET_TRAIL_DATA_Y
  lda (_player_data),y ; lo
  sta fetchYTrailList+1
  iny
  lda (_player_data),y ;hi
  sta fetchYTrailList+2

  ldy #PLAYER_DATA_OFFSET_TRAIL_DATA_CHAR
  lda (_player_data),y ; lo
  sta fetchCharTrailList+1
  iny
  lda (_player_data),y ;hi
  sta fetchCharTrailList+2

  ; X register will be used to count the iterations until the trail is erased
  ldy #TRAIL_MEMORY_LENGTH-1
  tya
  tax
  loop

  :fetchXTrailList
  lda $ffff,y ;self modified
  beq skip
  sta trailItemX

  :fetchYTrailList
  lda $ffff,y ;self modified
  sta trailItemY

  :fetchCharTrailList
  lda $ffff,y ;self modified
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

  skip
  dex
  bmi done
  txa
  tay
  jmp loop
  
  done
  jsr initTrailMemory
  rts
.)


shredTrail
.(

.)


