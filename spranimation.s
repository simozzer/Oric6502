; initialize animation by copying data for characters s,t & u to buffer

BackupCharacters
    lda #<_AltSpriteData                   
    sta _copy_mem_src_lo                         
    lda #>_AltSpriteData
    sta _copy_mem_src_hi                         
    lda #$D1 ; BYTE COUNT           
    sta _copy_mem_count_lo                         
    lda #$00                        
    sta _copy_mem_count_hi                        
    lda #<_animationBackup                      
    sta _copy_mem_dest_lo                      
    lda #>_animationBackup
    sta _copy_mem_dest_hi                        
    jsr CopyMemory                                              
    rts  
; for each frame copy data from offscreen buffer into s and advance to next frame
; Animation frame lookup table: source_lo, source_hi, dest_lo, dest_hi for each animation pair
AnimationTable
.byt <(_animationBackup + 18*8), >(_animationBackup + 18*8), <($b708 + 18*8), >($b708 + 18*8)
.byt <(_animationBackup + 21*8), >(_animationBackup + 21*8), <($b708 + 21*8), >($b708 + 21*8)
.byt <(_animationBackup + 19*8), >(_animationBackup + 19*8), <($b708 + 18*8), >($b708 + 18*8)
.byt <(_animationBackup + 22*8), >(_animationBackup + 22*8), <($b708 + 21*8), >($b708 + 21*8)
.byt <(_animationBackup + 20*8), >(_animationBackup + 20*8), <($b708 + 18*8), >($b708 + 18*8)
.byt <(_animationBackup + 23*8), >(_animationBackup + 23*8), <($b708 + 21*8), >($b708 + 21*8)

AnimateCharacters
    ; Get animation frame index and multiply by 8 (4 bytes per pair, 2 pairs per frame)
    lda _player_animation_index
    asl
    asl
    asl
    tax
    
    ; Copy first animation character of frame
    lda AnimationTable, x
    sta _copy_mem_src_lo
    lda AnimationTable+1, x
    sta _copy_mem_src_hi
    lda AnimationTable+2, x
    sta _copy_mem_dest_lo
    lda AnimationTable+3, x
    sta _copy_mem_dest_hi
    lda #$08
    sta _copy_mem_count_lo
    lda #$00
    sta _copy_mem_count_hi
    jsr CopyMemory
    
    ; Copy second animation character of frame
    lda AnimationTable+4, x
    sta _copy_mem_src_lo
    lda AnimationTable+5, x
    sta _copy_mem_src_hi
    lda AnimationTable+6, x
    sta _copy_mem_dest_lo
    lda AnimationTable+7, x
    sta _copy_mem_dest_hi
    lda #$08
    sta _copy_mem_count_lo
    lda #$00
    sta _copy_mem_count_hi
    jsr CopyMemory
    
    ; Advance frame counter
    inc _player_animation_index
    lda _player_animation_index
    cmp #03
    bne AnimateDone
    lda #00
    sta _player_animation_index
    
AnimateDone
    rts        



; copy 
