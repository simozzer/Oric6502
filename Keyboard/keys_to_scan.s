_StartScreenKeyMatrix .byt 0,2,1,1,1,0,64,0 ; Keys active during start screen (T,SPACE,S,M,K)

_AllKeysKeyMatrix .byt $F7,$F7,$FF,$f2,$ff,$ff,$f7,$fd

setupStartScreenActiveKeys
.(
    lda #<_StartScreenKeyMatrix
    sta _copy_mem_src_lo
    lda #>_StartScreenKeyMatrix
    sta _copy_mem_src_hi
    lda #9; byte count
    sta _copy_mem_count_lo                         
    lda #$00                        
    sta _copy_mem_count_hi                        
    lda #<_KeysToScanMatrix                      
    sta _copy_mem_dest_lo                      
    lda #>_KeysToScanMatrix       
    sta _copy_mem_dest_hi                        
    jsr CopyMemory  
    rts
.)

setAllKeysActive
.(
    lda #<_AllKeysKeyMatrix
    sta _copy_mem_src_lo
    lda #>_AllKeysKeyMatrix
    sta _copy_mem_src_hi
    lda #9; byte count
    sta _copy_mem_count_lo                         
    lda #$00                        
    sta _copy_mem_count_hi                        
    lda #<_KeysToScanMatrix                      
    sta _copy_mem_dest_lo                      
    lda #>_KeysToScanMatrix       
    sta _copy_mem_dest_hi                        
    jsr CopyMemory  
    rts
.)


_tempKeyRow .byt 1
_tempColMask .byt 1
_mapperRow .byt 1

setGameKeysActive
.(
  ; set all keys inactive
  ldy #0
  lda #0
  setZeroLoop
  sta _KeysToScanMatrix,Y
  iny
  cpy #8
  bne setZeroLoop

  ; use key mapper data to setup active key matrix
  ldy #0
  sty _mapperRow
  mapKeyLoop
  lda keyboardRows,Y
  sta _tempKeyRow
  lda keyboardColMasks,Y
  sta _tempColMask

  ldy _tempKeyRow
  lda _KeysToScanMatrix,Y
  ora _tempColMask
  sta _KeysToScanMatrix,Y
  ldy _mapperRow
  iny
  sty _mapperRow
  cpy #8
  bne mapKeyLoop
  rts
.)