 :StartProg
    jsr Alphabet        
    jsr CopySetToRam                        
    jsr MakeCharacters                        
    jsr ScreenFiller                       
    jsr CopyRamToChars                    
    rts  
 
 
 ; ** PRINT CHAR AT X,Y           
 ; ** Y IS STORED AT #$71         
 ; ** X IS STORED AT #$70         
 ; ** ASCII CODE STORED AT #$72   
 ; ** LO BYTE OF LINE staRT AT $73
 ; ** HI BYTE OF LINE staRT AT $74
 :PlotChar
    ldy $71                 ; Load row value                     
    lda LineLookupLo,Y    ; lookup low byte for row value and store
    sta $73                
    lda LineLookupHi,Y     ; lookup hi byte for row value and store
    sta $74
    lda $72                 ; load ascii code
    ldy $70                 ; load column value                   
    sta ($73),Y             ; plot character on screen
    rts


// Fill screen in turn with characters from a-z and repeat
// Exit it key pressed
:ScreenFiller
    lda #2 ; Start AT COLUMN 2  
    sta $70                          
    lda #0; Start ON ROW 0           
    sta $71                          
    lda #97; Start with lower case a
    sta $72                        
    :PrintNextChar jsr PlotChar                      
    ldx $70                          
    cpx #39 ;CHECK FOR LAST COLUMN   
    beq NextLine                        
    inx ;MOVE TO NEXT COLUMN         
    stx $70                          
    jmp PrintNextChar                           
    :NextLine 
    lda #2 ;MOVE BACK TO COL 2 
    sta $70                          
    ldx $71                          
    cpx #26 ;CHECK IF AT LAST LINE   
    beq NextChar                        
    inx ;MOVE TO NEXT LINE           
    stx $71                          
    jmp PrintNextChar                           
    :NextChar 
    ldx $72; SET NEXT CHAR     
    cpx #122                         
    beq ScreenFiller
    inx                     
    stx $72                          
    lda #2; MOVE BACK TO staRT OF SCREEN                                   
    sta $70                          
    lda #0                           
    sta $71                          
    ;TEST FOR KEY PRESS              
    ;jsr $EB78                        
    ;ldx $0208                        
    ;cpx #56 ;No key pressed                                         
    ;bne ExitScreenFill                          
    jmp PrintNextChar                           
    :ExitScreenFill rts       

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; SHOW LOWER CASE CHARS ON staTUS LINE (just for info)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  
:Alphabet .byt "abcdefghijklmnopqrstuvwxyz"                                 
    :PrintAlphabet ldy #0                      
    :L2 cpy #26                       
    beq ExitAlphabet                        
    lda Alphabet,Y                      
    sta $BB82,Y                     
    iny                             
    jmp L2                          
    :ExitAlphabet RTS      

                  
;>>>>> staRT OF COPY MEM ROUTINE
;$78 IS LOW BYTE OF SOURCE ADDR 
;$79 IS HI BYTE OF SOURCE ADDR  
;$80 IS LO BYTE OF BYTES TO COPY
;$81 IS HI BYTE OF BYTES TO COPY
;82 IS LO BYTE OF DEST ADDRESS  
;83 IS HI BYTE OF DEST ADDRESS  
:CopyMemory 
    ldx $78          
    stx BSRC+1                      
    ldx $79                         
    stx BSRC+2                      
    ldx $82                         
    stx BDEST+1                     
    ldx $83                         
    stx BDEST+2                     
    :CopyLoop 
    lda $8A; LO BYTE OF COUNT 1300 ;DECREMENT BYTES REMAINING      
    bne DecLo                        
    dec $8                         
    :DecLo 
    dec $80                    
    ; CHECK IF ALL BYTES COPIED     
    lda $80                         
   bne BSRC                        
   lda $81                         
   bne BSRC                        
   rts ; ZERO BYTES REMAIN          
   ; COPY SRC TO DEST              
   :BSRC 
   lda $FFFF                  
   :BDEST 
   sta $FFFF                 
   ; <<<<<<<<<                     
   inc BSRC+1                      
   bne DPLUS                       
   inc BSRC+2                      
   ; INCREMENT DEST POINTER        
   :DPLUS 
   inc BDEST+1               
   bne IDONE                       
   inc BDEST+2                     
   :IDONE 
   jmp CopyLoop 


                    
; Copy initial data for characters a-z into a buffer so we can restore them later
:CopySetToRam 
    lda #$08 ;lo byte of src                  
    sta $78                         
    lda #$B7 ;hi byte of src                       
    sta $79                         
    lda #$D1                        
    sta $80                         
    lda #$00                        
    sta $81                         
    lda #>_SpriteBackup_; lo byte of dest                         
    sta $82                         
    lda #<_SpriteBackup_ ; hi byte of dest
    sta $83                         
    jsr CopyMemory                       
    rts                             


; Copy initial character defintions back to restore a-z   
:CopyRamToChars 
    lda #<_SpriteBackup_; lo byte of source                 
    sta $78                         
    lda #>_SpriteBackup_; hi byte of source
    sta $79                         
    lda #$D1                        
    sta $80                     
    lda #$00                        
    sta $81                         
    lda #$08  ;lo bye of dest                      
    sta $82                         
    lda #$B7  ;hi byte of dest                      
    sta $83                         
    jsr CopyMemory                       
    rts                             


; Create characters a-z from data                  
:MakeCharacters 
    lda #<_SpriteData_ ; finally the correct incantation (:_SpriteData_)                   
    sta $78                         
    lda #>_SpriteData_
    sta $79                         
    lda #$D1 ; BYTE COUNT           
    sta $80                         
    lda #$00                        
    sta $81                         
    lda #$08                        
    sta $82                         
    lda #$B7                        
    sta $83                         
    jsr CopyMemory                                              
    rts                                               