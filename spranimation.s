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

AnimateCharacters
lda _player_animation_index
cmp #00
beq loadFirstFrame
cmp #01
beq loadSecondFrame
cmp #02
beq loadThirdFrame

:loadFirstFrame
    lda #<(_animationBackup + 18*8)
    sta _copy_mem_src_lo                         
    lda #>(_animationBackup + 18*8)
    sta _copy_mem_src_hi                         
    lda #$08 ; BYTE COUNT           
    sta _copy_mem_count_lo                         
    lda #$00                        
    sta _copy_mem_count_hi                        
    lda #<($b708 + (18*8))
    sta _copy_mem_dest_lo                      
    lda #>($b708 + (18*8))
    sta _copy_mem_dest_hi                        
    jsr CopyMemory  

    lda #<(_animationBackup + 21*8)
    sta _copy_mem_src_lo                         
    lda #>(_animationBackup + 21*8)
    sta _copy_mem_src_hi                         
    lda #$08 ; BYTE COUNT           
    sta _copy_mem_count_lo                         
    lda #$00                        
    sta _copy_mem_count_hi                        
    lda #<($b708 + (21*8))
    sta _copy_mem_dest_lo                      
    lda #>($b708 + (21*8))
    sta _copy_mem_dest_hi                        
    jsr CopyMemory  

    inc _player_animation_index                                            
    rts

:loadSecondFrame
    lda #<(_animationBackup + 19*8)
    sta _copy_mem_src_lo                         
    lda #>(_animationBackup + 19*8)
    sta _copy_mem_src_hi                         
    lda #$08 ; BYTE COUNT           
    sta _copy_mem_count_lo                         
    lda #$00                        
    sta _copy_mem_count_hi                        
    lda #<($b708 + (18*8))
    sta _copy_mem_dest_lo                      
    lda #>($b708 + (18*8))
    sta _copy_mem_dest_hi                        
    jsr CopyMemory  

    lda #<(_animationBackup + 22*8)
    sta _copy_mem_src_lo                         
    lda #>(_animationBackup + 22*8)
    sta _copy_mem_src_hi                         
    lda #$08 ; BYTE COUNT           
    sta _copy_mem_count_lo                         
    lda #$00                        
    sta _copy_mem_count_hi                        
    lda #<($b708 + (21*8))
    sta _copy_mem_dest_lo                      
    lda #>($b708 + (21*8))
    sta _copy_mem_dest_hi                        
    jsr CopyMemory  

    inc _player_animation_index                                            
    rts    


:loadThirdFrame
    lda #<(_animationBackup + 20*8)
    sta _copy_mem_src_lo                         
    lda #>(_animationBackup + 20*8)
    sta _copy_mem_src_hi                         
    lda #$08 ; BYTE COUNT           
    sta _copy_mem_count_lo                         
    lda #$00                        
    sta _copy_mem_count_hi                        
    lda #<($b708 + (18*8))
    sta _copy_mem_dest_lo                      
    lda #>($b708 + (18*8))
    sta _copy_mem_dest_hi                        
    jsr CopyMemory  

    lda #<(_animationBackup + 23*8)
    sta _copy_mem_src_lo                         
    lda #>(_animationBackup + 23*8)
    sta _copy_mem_src_hi                         
    lda #$08 ; BYTE COUNT           
    sta _copy_mem_count_lo                         
    lda #$00                        
    sta _copy_mem_count_hi                        
    lda #<($b708 + (21*8))
    sta _copy_mem_dest_lo                      
    lda #>($b708 + (21*8))
    sta _copy_mem_dest_hi                        
    jsr CopyMemory  


    lda #00
    sta _player_animation_index                                            
    rts        



; copy 
