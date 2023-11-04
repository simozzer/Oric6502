    
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
_maze_x_tmp .byt 1
_maze_y_tmp .byt 1
_maze_line_start
_maze_line_start_lo .byt 1
_maze_line_start_hi .byt 1

_maze_right .byt 1

_player1_x .byt 1
_player1_y .byt 1
_player1_direction .byt 1
_player_status .byt 1
_player1_maze_x .byt 1
_player1_maze_y .byt 1

_player2_x .byt 1
_player2_y .byt 1
_player2_direction .byt 1
_player2_maze_x .byt 1
_player2_maze_y .byt 1


_screen_render_right .byt 1
_screen_render_bottom .byt 1
_maze_render_offset_x .byt 1
_screen_render_x_wrap .byt 1 ; the value x must hit to go to the previous line
_screen_render_y_wrap .byt 1 ; the value y must be for render complete

_display_mode .byt 1

_zp_end_

// Part of code copied from Kong, which was supplied with the OSDK
rand_low		.dsb 1		;// Random number generator, low part
rand_high		.dsb 1		;// Random number generator, high part
b_tmp1          .dsb 1


.text
#define _cls		$ccce

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

#DEFINE KEY_UP_ARROW 156
#DEFINE KEY_DOWN_ARROW 180
#DEFINE KEY_LEFT_ARROW 172
#DEFINE KEY_RIGHT_ARROW 188
#DEFINE KEY_SPACE 132
#DEFINE KEY_Q 177
#DEFINE KEY_PRESS_NONE 56

#DEFINE KEY_PRESS_LOOKUP $0208

#DEFINE DISPLAY_MODE_FULLSCREEN 0
#DEFINE DISPLAY_MODE_SIDE_BY_SIDE 1
#DEFINE DISPLAY_MODE_TOP_TO_BOTTOM 2

#DEFINE FULLSCREEN_TEXT_FIRST_COLUMN 2
#DEFINE FULLSCREEN_TEXT_LAST_COLUMN 39
#DEFINE FULLSCREEN_TEXT_MAZE_OFFSET_X 37 ; First 2 columns on screen are for text and paper attributes
#DEFINE FULLSCREEN_TEXT_LAST_LINE 26
#DEFINE FULLSCREEN_TEXT_X_WRAP 1
#DEFINE FULLSCREEN_TEXT_Y_WRAP 0
#DEFINE FULLSCREEN_MAZE_X 110
#DEFINE FULLSCREEN_MAZE_Y 21


#DEFINE LEFT_SCREEN_TEXT_FIRST_COLUMN 2
#DEFINE LEFT_SCREEN_TEXT_LAST_COLUMN 18
#DEFINE LEFT_SCREEN_TEXT_MAZE_OFFSET_X 20 ; First 2 columns on screen are for text and paper attributes
#DEFINE LEFT_SCREEN_TEXT_LAST_LINE 26
#DEFINE LEFT_SCREEN_TEXT_X_WRAP 1
#DEFINE LEFT_SCREEN_TEXT_Y_WRAP 0
#DEFINE LEFT_SCREEN_MAZE_X 119
#DEFINE LEFT_SCREEN_MAZE_Y 21

#DEFINE RIGHT_SCREEN_TEXT_FIRST_COLUMN 20
#DEFINE RIGHT_SCREEN_TEXT_LAST_COLUMN 39
#DEFINE RIGHT_SCREEN_TEXT_MAZE_OFFSET_X 39 ; First 2 columns on screen are for text and paper attributes
#DEFINE RIGHT_SCREEN_TEXT_LAST_LINE 26
#DEFINE RIGHT_SCREEN_TEXT_X_WRAP 19
#DEFINE RIGHT_SCREEN_TEXT_Y_WRAP 0
#DEFINE RIGHT_SCREEN_MAZE_X 119
#DEFINE RIGHT_SCREEN_MAZE_Y 21


#DEFINE OFFSCREEN_LAST_COLUMN 254
#DEFINE OFFSCREEN_LAST_ROW 80

#DEFINE PLAYER_DIRECTION_LEFT 0;
#DEFINE PLAYER_DIRECTION_RIGHT 1;
#DEFINE PLAYER_DIRECTION_UP 2;
#DEFINE PLAYER_DIRECTION_DOWN 3;

#DEFINE PLAYER_STATUS_ALIVE 0
#DEFINE PLAYER_STATUS_DEAD 1

 StartProg

    ;// NOKEYCLICK+SCREEN no cursor
	lda #8+2	
	sta $26a
    
    ;jsr PrintAlphabet 
    jsr PrintInstructions       
    jsr CopySetToRam                        
    jsr MakeCharacters_0               
    jsr screen_filler                       
    jsr CopyRamToChars     

    jsr MakeCharacters_1
    jsr SetPaper
    jsr SetInk
    jsr PrintWaitMessage

    // Initialise the random generator values (taken from kong, which was supplied with the OSDK)
	lda #23
	sta rand_low
	lda #35
	sta rand_high
    jsr MazeRender
    jsr PrintScrollInstructions
    jsr _cls
    jsr SetPaper
    jsr SetInk


    //setup player 
    lda #128
    sta _player1_x    
    lda #34
    sta _player1_y
    lda #PLAYER_DIRECTION_UP
    sta _player1_direction
    lda #PLAYER_STATUS_ALIVE
    sta _player_status

    // render player
    ldy _player1_y
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    lda #108 ; character code for segment of light trail
    ldy _player1_x
    sta (_maze_line_start),y

    lda #DISPLAY_MODE_FULLSCREEN
    sta _display_mode

    
    //lda _display_mode
    cmp #DISPLAY_MODE_FULLSCREEN
    bne nextMode0
    jsr runFullScreen   
    jmp end
     
    nextMode0
    cmp #DISPLAY_MODE_SIDE_BY_SIDE // SIDE BY SIDE IS A WORK IN PROGRESS AND DOES NOT YET FUNCTION CORRECTLY!!!!
    bne nextMode1
    jsr runSideBySide  
    jmp end

nextMode1
end
   // jsr CopyRamToChars    
    rts  

runFullScreen
    // set initial maze position
    lda #FULLSCREEN_MAZE_X
    sta _maze_left
    sta _player1_maze_x
    lda #FULLSCREEN_MAZE_Y
    sta _maze_top
    sta _player1_maze_y
    
    // set up dimensions for screen to render    
    fullScreenLoop
    lda #FULLSCREEN_TEXT_LAST_COLUMN
    sta _screen_render_right
    lda #FULLSCREEN_TEXT_LAST_LINE
    sta _screen_render_bottom
    lda #FULLSCREEN_TEXT_MAZE_OFFSET_X
    sta _maze_render_offset_x
    lda #FULLSCREEN_TEXT_X_WRAP
    sta _screen_render_x_wrap
    lda #FULLSCREEN_TEXT_Y_WRAP 
    sta _screen_render_y_wrap
    lda _player1_maze_x
    sta _maze_left
    lda _player1_maze_y
    sta _maze_top

    jsr ScreenRender

    jsr processMovement
    lda _maze_left
    sta _player1_maze_x
    lda _maze_top
    sta _player1_maze_y
    lda _player_status
    cmp #PLAYER_STATUS_DEAD
    bne fullScreenLoop
    rts

runSideBySide
    // set initial maze position
    lda #LEFT_SCREEN_MAZE_X
    sta _player1_maze_x
    lda #LEFT_SCREEN_MAZE_Y
    sta _player1_maze_y

    lda #RIGHT_SCREEN_MAZE_X
    sta _player1_maze_x
    lda #RIGHT_SCREEN_MAZE_Y
    sta _player1_maze_y
    
    // set up dimensions for screen to render    
    sideScreenLoop
    lda #LEFT_SCREEN_TEXT_LAST_COLUMN
    sta _screen_render_right
    lda #LEFT_SCREEN_TEXT_LAST_LINE
    sta _screen_render_bottom
    lda #LEFT_SCREEN_TEXT_MAZE_OFFSET_X
    sta _maze_render_offset_x
    lda #LEFT_SCREEN_TEXT_X_WRAP
    sta _screen_render_x_wrap
    lda #LEFT_SCREEN_TEXT_Y_WRAP 
    sta _screen_render_y_wrap
    lda _player1_maze_x
    sta _maze_left
    lda _player1_maze_y
    sta _maze_top

    jsr ScreenRender

    
    // set up dimensions for screen to render    
    lda #RIGHT_SCREEN_TEXT_LAST_COLUMN
    sta _screen_render_right
    lda #RIGHT_SCREEN_TEXT_LAST_LINE
    sta _screen_render_bottom
    lda #RIGHT_SCREEN_TEXT_MAZE_OFFSET_X
    sta _maze_render_offset_x
    lda #RIGHT_SCREEN_TEXT_X_WRAP
    sta _screen_render_x_wrap
    lda #RIGHT_SCREEN_TEXT_Y_WRAP 
    sta _screen_render_y_wrap
    lda _player2_maze_x
    sta _maze_left
    lda _player2_maze_y
    sta _maze_top

    
    jsr ScreenRender

    jsr processMovement
    lda _player1_maze_x
    sta _maze_left
    lda _player1_maze_y
    sta _maze_top

    lda _player_status
    cmp #PLAYER_STATUS_DEAD
    bne sideScreenLoop
    rts

    
 
 ; ** PRINT CHAR AT X,Y           
 :plotchar ldy _plot_ch_y                 ; Load row value                     
    lda ScreenLineLookupLo,Y    ; lookup low byte for row value and store
    sta _line_start_lo                
    lda ScreenLineLookupHi,Y     ; lookup hi byte for row value and store
    sta _line_start_hi
    lda _plot_ascii                 ; load ascii code
    ldy _plot_ch_x                 ; load column value                   
    sta (_line_start),Y             ; plot character on screen
    rts


// Fill screen in turn with characters from a-z and repeat
// Exit if key pressed
screen_filler
    lda #FULLSCREEN_TEXT_FIRST_COLUMN
    sta _plot_ch_x                          
    lda #0; Start ON ROW 0           
    sta _plot_ch_y                          
    lda #97; Start with lower case a
    sta _plot_ascii 

print_line ; get the line address once a line
    ldy _plot_ch_y        ; Load row value                     
    lda ScreenLineLookupLo,Y    ; lookup low byte for row value and store
    sta _line_start_lo                
    lda ScreenLineLookupHi,Y     ; lookup hi byte for row value and store
    sta _line_start_hi

    ldy #FULLSCREEN_TEXT_FIRST_COLUMN
    lda _plot_ascii
print_next_char
    sta (_line_start),Y                     
                           
    cpy #FULLSCREEN_TEXT_LAST_COLUMN ;CHECK FOR LAST COLUMN   
    beq next_line                                               
    iny
    jmp print_next_char                           
    
    next_line
    ldy #FULLSCREEN_TEXT_FIRST_COLUMN
    ldx _plot_ch_y                          
    cpx #FULLSCREEN_TEXT_LAST_LINE ;CHECK IF AT LAST LINE   
    beq next_char                                              
    inc _plot_ch_y ;move to next line
    jmp print_line                           
    
    next_char
    ldx _plot_ascii; load current char     
    cpx #122; check if we've reached last char                        
    beq screen_filler                       
    inc _plot_ascii ; move to next char
    lda #FULLSCREEN_TEXT_FIRST_COLUMN; Set next character at start of screen                                  
    sta _plot_ch_x                          
    lda #0                           
    sta _plot_ch_y                          
    ;TEST FOR KEY PRESS  (temporarily disabled)                                   
    ldx KEY_PRESS_LOOKUP
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
    jsr ClearStatus
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
    jsr ClearStatus
    ldy #0                      
.(
Loop
    cpy #27                   
    beq ExitInstructions                        
    lda Instructions,Y                      
    sta $BB82,Y                     
    iny                             
    jmp Loop
    ExitInstructions 
    rts       
.)


:ScrollInstructions .byt "PRESS ARROW KEYS TO SCROLL"                                 
:PrintScrollInstructions
    jsr ClearStatus
    ldy #0                      
.(
Loop
    cpy #26                  
    beq ExitInstructions                        
    lda ScrollInstructions,Y                      
    sta $BB82,Y                     
    iny                             
    jmp Loop
    ExitInstructions 
    rts       
.)
    


:WaitMessage .byt "PLEASE WAIT..."                                 
:PrintWaitMessage
    jsr ClearStatus
    ldy #0                      
.(
Loop
    cpy #14;
    beq ExitInstructions                        
    lda WaitMessage,Y                      
    sta $BB82,Y                     
    iny                             
    jmp Loop
    ExitInstructions 
    rts
.)

:ClearStatus
    ldy #0                      
    lda #32
.(
Loop
    cpy #38 ;
    beq ExitClear                        
    sta $BB82,Y                     
    iny                             
    jmp Loop
    ExitClear 
    rts
.)
  
    
                  
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

:SetInk
    ldy #FULLSCREEN_TEXT_LAST_LINE
    ldx #INK_GREEN
.(
    loop
    lda ScreenLineLookupLo,Y
    sta writePaper+1
    lda ScreenLineLookupHi,y
    sta writePaper+2
    :writePaper stx $ffff
    dey
    bpl loop

    rts
.)

:SetPaper
    ldy #FULLSCREEN_TEXT_LAST_LINE
    ldx #01
.(
    loop
    lda ScreenLineLookupLo,Y
    sta writeInk+1
    lda ScreenLineLookupHi,y
    sta writeInk+2
    lda #PAPER_BLACK
    :writeInk sta $ffff,x
    dey
    bpl loop

    rts
.)


    



