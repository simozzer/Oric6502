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
; when char code for 'u' reached then start again

lda _player_animation_index
cmp #00
beq loadFirstFrame

:loadFirstFrame


; copy 



