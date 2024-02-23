; allow 3 bytes for each section of the trail data
; each 'record' will contain x_pos, y_pos and the previous char at that position
trailData 
.byt 0,0,0,0,0,0,0,0,0,0 
.byt 0,0,0,0,0,0,0,0,0,0
.byt 0,0,0,0,0,0,0,0,0,0
.byt 0,0,0,0,0,0,0,0,0,0
.byt 0,0,0,0,0,0,0,0,0,0
.byt 0,0,0,0,0,0,0,0,0,0 


initTrailMemory
.(
  ;setup zero page pointer to trail data 
  lda #<trailData
  sta trail_data_low_player_1
  lda #>trailData
  sta trail_data_hi_player_1

  ; set trail index to zero
  lda #00
  sta trail_index_player_1
  ; zero out the data for the trail
  ldy #29

  lda #$00
  loop
    sta (trail_data_player_1),Y
    dey  
    bne loop
  exit
    sta (trail_data_player_1),Y
   rts
.)


addTrailItem
.(
  ldy trail_index_player_1
  cpy #31
  bcc add
  ldy #0
  sty trail_index_player_1
  add
  lda trailItemX
  sta (trail_data_player_1),Y
  iny 
  lda trailItemY
  sta (trail_data_player_1),Y
  iny 
  lda trailChar
  sta (trail_data_player_1),Y
  iny
  sty trail_index_player_1
  itemAdded
  rts
.)

eraseTrail
.(
  ldx #9; set the maximum number of iterations
  loop
  ldy trail_index_player_1; get the current index in the trail data
  bne getItem
  bob
  ldy #30 ; if we're at zero then move to the last item in the data
  sty trail_index_player_1
  :getItem
  ldy trail_index_player_1
  dey
  dex
  beq done ; if we've done max iterations then we're done.
  
  lda (trail_data_player_1),Y
  beq done ; if the trail data is empty then we're done
  sta trailChar
  ; erase char in trail history
  lda #0 
  sta (trail_data_player_1),Y

  dey
  lda (trail_data_player_1),y
  sta trailItemY
  
  
  dey
  lda (trail_data_player_1),Y
  sta trailItemX

  sty trail_index_player_1

  ; restore the character in the play area
  ldy trailItemY
  lda OffscreenLineLookupLo,y
  sta _line_start_lo
  lda OffscreenLineLookupHi,y
  sta _line_start_hi
  ldy trailItemX
  lda trailChar
  sta (_line_start),y

  jmp getItem


  
  done
    jsr initTrailMemory
    rts
.)


shredTrail
.(

.)


