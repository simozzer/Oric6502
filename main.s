    
#define _getKey		$EB78

    .zero
     *= $50

_zp_start_

_plot_ch_x .byt 1
_plot_ch_y .byt 1
_plot_ascii .byt 1
_line_start
_line_start_lo .byt 1
_line_start_hi .byt 1

_copy_mem_src
_copy_mem_src_lo .byt 1
_copy_mem_src_hi .byt 1
_copy_mem_dest
_copy_mem_dest_lo .byt 1
_copy_mem_dest_hi .byt 1
_copy_mem_count
_copy_mem_count_lo .byt 1
_copy_mem_count_hi .byt 1

_maze_left .byt 1
_maze_top .byt 1
_maze_byte .byt 1
_bits_to_process .byt 1
_maze_bitmask .byt 1

_zp_end_

.text

#DEFINE PAPER_BLACK 16
#DEFINE PAPER_RED 17
#DEFINE PAPER_GREEN 18
#DEFINE PAPER_YELLOW 19
#DEFINE PAPER_BLUE 20
#DEFINE PAPER_MAGENTA 21
#DEFINE PAPER_CYAN 22
#DEFINE PAPER_WHITE 23

#DEFINE INK_BLACK 0
#DEFINE INK_RED 1
#DEFINE INK_GREEN 2
#DEFINE INK_YELLOW 3
#DEFINE INK_BLUE 4
#DEFINE INK_MAGENTA 5
#DEFINE INK_CYAN 6
#DEFINE INK_WHITE 7

 StartProg
    ;jsr PrintAlphabet 
    jsr PrintInstructions       
    ;jsr CopySetToRam                        
    jsr MakeCharacters_0                      
    jsr screen_filler                       
    ;jsr CopyRamToChars     

    jsr MakeCharacters_1
    jsr SetPaper
    jsr SetInk
    jsr MazeDisplay // Working on this at the moment
    rts  

    
 
 ; ** PRINT CHAR AT X,Y           
 :plotchar ldy _plot_ch_y                 ; Load row value                     
    lda LineLookupLo,Y    ; lookup low byte for row value and store
    sta _line_start_lo                
    lda LineLookupHi,Y     ; lookup hi byte for row value and store
    sta _line_start_hi
    lda _plot_ascii                 ; load ascii code
    ldy _plot_ch_x                 ; load column value                   
    sta (_line_start),Y             ; plot character on screen
    rts


// Fill screen in turn with characters from a-z and repeat
// Exit if key pressed
screen_filler
    lda #2 ; Start AT COLUMN 2  
    sta _plot_ch_x                          
    lda #0; Start ON ROW 0           
    sta _plot_ch_y                          
    lda #97; Start with lower case a
    sta _plot_ascii 

print_line ; get the line address once a line
    ldy _plot_ch_y        ; Load row value                     
    lda LineLookupLo,Y    ; lookup low byte for row value and store
    sta _line_start_lo                
    lda LineLookupHi,Y     ; lookup hi byte for row value and store
    sta _line_start_hi

    ldy #2
    lda _plot_ascii
print_next_char
    sta (_line_start),Y                     
                           
    cpy #39 ;CHECK FOR LAST COLUMN   
    beq next_line                                               
    iny
    jmp print_next_char                           
    
    next_line
    ldy #2 
    ldx _plot_ch_y                          
    cpx #26 ;CHECK IF AT LAST LINE   
    beq next_char                                              
    inc _plot_ch_y ;move to next line
    jmp print_line                           
    
    next_char
    ldx _plot_ascii; load current char     
    cpx #122; check if we've reached last char                        
    beq screen_filler                       
    inc _plot_ascii ; move to next char
    lda #2; Set next character at start of screen                                  
    sta _plot_ch_x                          
    lda #0                           
    sta _plot_ch_y                          
    ;TEST FOR KEY PRESS  (temporarily disabled)            
    ;jsr _getKey                        
    ldx $0208                        
    cpx #56 ;No key pressed                                         
    bne ExitScreenFill    

    jmp print_line                          
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


:Instructions .byt "TEST: PRESS ANY KEY TO EXIT"                                 
:PrintInstructions
    ldy #0                      
.(
Loop
    cpy #27                   
    beq ExitInstructions                        
    lda Instructions,Y                      
    sta $BB82,Y                     
    iny                             
    jmp Loop
.)
    :ExitInstructions 
    rts       

                  
;>>>>> staRT OF COPY MEM ROUTINE
:CopyMemory 
    ldx _copy_mem_src_lo          
    stx LoadSourceByte+1                      
    ldx _copy_mem_src_hi                        
    stx LoadSourceByte+2                      
    ldx _copy_mem_dest_lo                      
    stx SaveDestByte+1                     
    ldx _copy_mem_dest_hi           
    stx SaveDestByte+2                     
    :CopyLoop 
    lda _copy_mem_count_lo; LO BYTE OF COUNT 
    bne DecLo                        
    dec _copy_mem_count_hi                         
    :DecLo 
    dec _copy_mem_count_lo                   
    ; CHECK IF ALL BYTES COPIED     
    lda _copy_mem_count_lo                         
    bne LoadSourceByte                        
    lda _copy_mem_count_hi                        
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
    sta _copy_mem_src_lo                         
    lda #$B7 ;hi byte of src                       
    sta _copy_mem_src_hi                         
    lda #$D1                        
    sta _copy_mem_count_lo                        
    lda #$00                        
    sta _copy_mem_count_hi                        
    lda #<_SpriteBackup_; lo byte of dest                         
    sta _copy_mem_dest_lo                       
    lda #>_SpriteBackup_ ; hi byte of dest
    sta _copy_mem_dest_hi                        
    jsr CopyMemory                       
    rts                             


; Copy initial character defintions back to restore a-z   
:CopyRamToChars 
    lda #<_SpriteBackup_; lo byte of source                 
    sta _copy_mem_src_lo                        
    lda #>_SpriteBackup_; hi byte of source
    sta _copy_mem_src_hi                         
    lda #$D1                        
    sta _copy_mem_count_lo                    
    lda #$00                        
    sta _copy_mem_count_hi                        
    lda #$08  ;lo bye of dest                      
    sta _copy_mem_dest_lo                         
    lda #$B7  ;hi byte of dest                      
    sta _copy_mem_dest_hi                         
    jsr CopyMemory                       
    rts                             


; Create characters a-z from data                  
:MakeCharacters_0
    lda #<_SpriteData_                   
    sta _copy_mem_src_lo                         
    lda #>_SpriteData_
    sta _copy_mem_src_hi                         
    lda #$D1 ; BYTE COUNT           
    sta _copy_mem_count_lo                         
    lda #$00                        
    sta _copy_mem_count_hi                        
    lda #$08                        
    sta _copy_mem_dest_lo                      
    lda #$B7                        
    sta _copy_mem_dest_hi                        
    jsr CopyMemory                                              
    rts          

:MakeCharacters_1
    lda #<_AltSpriteData                   
    sta _copy_mem_src_lo                         
    lda #>_AltSpriteData
    sta _copy_mem_src_hi                         
    lda #$D1 ; BYTE COUNT           
    sta _copy_mem_count_lo                         
    lda #$00                        
    sta _copy_mem_count_hi                        
    lda #$08                        
    sta _copy_mem_dest_lo                      
    lda #$B7                        
    sta _copy_mem_dest_hi                        
    jsr CopyMemory                                              
    rts    

:SetPaper
    ldy #26
    ldx #PAPER_YELLOW
.(
    loop
    lda LineLookupLo,Y
    sta writePaper+1
    lda LineLookupHi,y
    sta writePaper+2
    :writePaper stx $ffff
    dey
    bpl loop

    rts
.)

:SetInk
    ldy #26
    ldx #01
.(
    loop
    lda LineLookupLo,Y
    sta writeInk+1
    lda LineLookupHi,y
    sta writeInk+2
    lda #INK_RED
    :writeInk sta $ffff,x
    dey
    bpl loop

    rts
.)
    
    



