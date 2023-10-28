 :StartProg
    jsr PrintAlphabet        
    jsr CopySetToRam                        
    jsr MakeCharacters                        
    jsr ScreenFiller                       
    jsr CopyRamToChars     

    jsr MazeDisplay               
    rts  

#define _getKey		$EB78    
 
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
// Exit if key pressed
:ScreenFiller
    lda #2 ; Start AT COLUMN 2  
    sta $70                          
    lda #0; Start ON ROW 0           
    sta $71                          
    lda #97; Start with lower case a
    sta $72                        
.(
PrintNextChar 
    jsr PlotChar                      
    ldx $70                          
    cpx #39 ;CHECK FOR LAST COLUMN   
    beq NextLine                                               
    inc $70 ;move to next column
    jmp PrintNextChar                           
    :NextLine 
    lda #2 ;MOVE BACK TO COL 2 
    sta $70                          
    ldx $71                          
    cpx #26 ;CHECK IF AT LAST LINE   
    beq NextChar                                               
    inc $71 ;move to next line
    jmp PrintNextChar                           
    :NextChar 
    ldx $72; load current char     
    cpx #122; check if we've reached last char                        
    beq ScreenFiller                       
    inc $72 ; move to next char
    lda #2; Set next character at start of screen                                  
    sta $70                          
    lda #0                           
    sta $71                          
    ;TEST FOR KEY PRESS  (temporarily disabled)            
    jsr _getKey                        
    ldx $0208                        
    cpx #56 ;No key pressed                                         
    bne ExitScreenFill    

    jmp PrintNextChar 
.)                          
    :ExitScreenFill 
    rts       

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; SHOW LOWER CASE CHARS ON staTUS LINE (just for info)
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  
:Alphabet .byt "abcdefghijklmnopqrstuvwxyz"                                 
:PrintAlphabet 
    ldy #0                      
.(
Loop
    cpy #26                       
    beq ExitAlphabet                        
    lda Alphabet,Y                      
    sta $BB82,Y                     
    iny                             
    jmp Loop
.)
    :ExitAlphabet 
    rts      

                  
;>>>>> staRT OF COPY MEM ROUTINE
;$78 IS LOW BYTE OF SOURCE ADDR 
;$79 IS HI BYTE OF SOURCE ADDR  
;$7A IS LO BYTE OF BYTES TO COPY
;$7B IS HI BYTE OF BYTES TO COPY
;$7C IS LO BYTE OF DEST ADDRESS  
;$7D IS HI BYTE OF DEST ADDRESS  
:CopyMemory 
    ldx $78          
    stx LoadSourceByte+1                      
    ldx $79                         
    stx LoadSourceByte+2                      
    ldx $7C                      
    stx SaveDestByte+1                     
    ldx $7D                         
    stx SaveDestByte+2                     
    :CopyLoop 
    lda $7A; LO BYTE OF COUNT 
    bne DecLo                        
    dec $7B                         
    :DecLo 
    dec $7A                    
    ; CHECK IF ALL BYTES COPIED     
    lda $7A                         
    bne LoadSourceByte                        
    lda $7B                        
    bne LoadSourceByte                        
    rts ; ZERO BYTES REMAIN          
    
    ; Copy source byte to destination              
:LoadSourceByte 
    lda $FFFF                  
:SaveDestByte 
    sta $FFFF                 
    
    ; Increment Source pointer
    inc LoadSourceByte+1                      
    bne IncDestAddress                       
    inc LoadSourceByte+2                      
    
    ; Increment Destination pointer      
:IncDestAddress 
    inc SaveDestByte+1               
    bne IncrementDone                       
    inc SaveDestByte+2                     

:IncrementDone 
    jmp CopyLoop 


                    
; Copy initial data for characters a-z into a buffer so we can restore them later
:CopySetToRam 
    lda #$08 ;lo byte of src                  
    sta $78                         
    lda #$B7 ;hi byte of src                       
    sta $79                         
    lda #$D1                        
    sta $7A                        
    lda #$00                        
    sta $7B                        
    lda #<_SpriteBackup_; lo byte of dest                         
    sta $7C                       
    lda #>_SpriteBackup_ ; hi byte of dest
    sta $7D                         
    jsr CopyMemory                       
    rts                             


; Copy initial character defintions back to restore a-z   
:CopyRamToChars 
    lda #<_SpriteBackup_; lo byte of source                 
    sta $78                         
    lda #>_SpriteBackup_; hi byte of source
    sta $79                         
    lda #$D1                        
    sta $7A                    
    lda #$00                        
    sta $7B                         
    lda #$08  ;lo bye of dest                      
    sta $7C                         
    lda #$B7  ;hi byte of dest                      
    sta $7D                         
    jsr CopyMemory                       
    rts                             


; Create characters a-z from data                  
:MakeCharacters 
    lda #<_SpriteData_                   
    sta $78                         
    lda #>_SpriteData_
    sta $79                         
    lda #$D1 ; BYTE COUNT           
    sta $7A                         
    lda #$00                        
    sta $7B                         
    lda #$08                        
    sta $7C                      
    lda #$B7                        
    sta $7D                         
    jsr CopyMemory                                              
    rts          
