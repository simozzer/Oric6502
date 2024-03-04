; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Print a message on the status line at the top of the screen
; ------------------------------------------------------------------------------
printStatusMessage
    jsr clearStatusLine
    ldy 0
    :loadMessageLoop    
    lda $ffff,Y
    beq messagePrinted
    sta $bb82,y
    iny
    jmp loadMessageLoop
    messagePrinted
    rts
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Clear text from the status line at the top of the screen
; ------------------------------------------------------------------------------
clearStatusLine
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
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;// Copy memory (could be further opitimised using comments from dhbug)
; ------------------------------------------------------------------------------
CopyMemory 

    ldx _copy_mem_src_lo          
    stx LoadSourceByte+1                      
    ldx _copy_mem_src_hi                        
    stx LoadSourceByte+2                      
    ldx _copy_mem_dest_lo                      
    stx SaveDestByte+1                     
    ldx _copy_mem_dest_hi           
    stx SaveDestByte+2                     
CopyLoop 
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
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;// Wipe params. Zero all params used for a Basic Call
; ------------------------------------------------------------------------------
WipeParams
.(
    ldy #08
    lda #0
    wipePriorParam
    sta $02E0, y
    dey
    bne wipePriorParam
    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Perform a short delay (currently used to slow to down the game a bit)
; ------------------------------------------------------------------------------
smallDelay
.(
    txa
    pha
    ldx #$0c

    outer_loop
    
    ; a small delay
    ldy #255
    loop
    dey
    nop
    cpy #00
    Bne loop
    dex
    cpx #00 
    bpl outer_loop

    pla
    tax
    rts    
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Perform a big delay (currently used to wait a while before restarting the game
; ------------------------------------------------------------------------------
bigDelay
.(
    txa
    pha
    ldx #$ff

    outer_loop
    
    ; a small delay
    ldy #255
    loop
    dey
    nop
    cpy #00
    Bne loop
    dex
    cpx #00 
    bne outer_loop

    pla
    tax
    rts    
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Perform a short delay to allow for a key tap to complete
; ------------------------------------------------------------------------------
keyDelay
.(
    txa
    pha
    ldx #$40

    outer_loop
    
    ; a small delay
    ldy #255
    loop
    dey
    nop
    cpy #00
    Bne loop
    dex
    cpx #00 
    bne outer_loop

    pla
    tax
    rts    
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Clear the screen in text mode (without changing status line, or paper and ink)
; ------------------------------------------------------------------------------
clearScreen
    lda #FULLSCREEN_TEXT_FIRST_COLUMN
    sta _plot_ch_x                          
    lda #0; Start ON ROW 0           
    sta _plot_ch_y       

.(                       
clear_line ; get the line address once a line

    ldy _plot_ch_y        ; Load row value                     
    lda ScreenLineLookupLo,Y    ; lookup low byte for row value and store
    sta _line_start_lo                
    lda ScreenLineLookupHi,Y     ; lookup hi byte for row value and store
    sta _line_start_hi

    ldy #FULLSCREEN_TEXT_FIRST_COLUMN
    lda #20 ; space character
clear_next_char
    sta (_line_start),Y                     
                           
    cpy #FULLSCREEN_TEXT_LAST_COLUMN ;CHECK FOR LAST COLUMN   
    beq clear_next_line                                               
    iny
    jmp clear_next_char
    
clear_next_line
    ldy #FULLSCREEN_TEXT_FIRST_COLUMN
    ldx _plot_ch_y                          
    cpx #FULLSCREEN_TEXT_LAST_LINE ;CHECK IF AT LAST LINE   
    beq screen_cleared                                              
    inc _plot_ch_y ;move to next line
    jmp clear_line                         
    
    screen_cleared
    rts     
.)  
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Simple galois16 taken from https://github.com/bbbradsmith/prng_6502/blob/master/galois16.s
; Take care using this function as it alters the Y register!!!
; ------------------------------------------------------------------------------
_GetRand
.(
    ldy #8  
	lda rand_low
:back
	asl        ; shift the register
	rol rand_high
	bcc noEor
	eor #$39   ; apply XOR feedback whenever a 1 bit is shifted out
:noEor
	dey
	bne back
	sta rand_low
	cmp #0     ; reload flags
	rts
    .)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; CopyCharsFromROM: reset the character set for text mode using data from the ROM
; -------------------------------------------------------------------------------
CopyCharsFromROM
.(
  lda #$78
  sta _copy_mem_src_lo
  lda #$FC
  sta _copy_mem_src_hi

  lda #$f8
  sta _copy_mem_count_lo
  lda #$03
  sta _copy_mem_count_hi

  lda #$00
  sta _copy_mem_dest_lo
  lda #$B5
  sta _copy_mem_dest_hi

  jsr CopyMemory

  rts
.)


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; printStr: Print at null termintaed string at a given position on the
; screen. 
; This is a modified version of the AdvancedPrint function found in the
; OSDK samples for C
; Params: 
;   params_0: x position
;   params_1: y position
;   params_2: address of string lo
;   params_3: address of string hi
; --------------------------------------------------------------------
printStr
.(
	
	; Initialise display adress
	; this uses self-modifying code
	; (the $0123 is replaced by display adress)
	
	; The idea is to get the Y position from the stack,
	; and use it as an index in the two adress tables.
	; We also need to add the value of the X position,
	; also taken from the stack to the resulting value.
	

	lda temp_param_1		; Access Y coordinate
	tax
	
	lda ScreenLineLookupLo,x	; Get the LOW part of the screen adress
	clc						; Clear the carry (because we will do an addition after)
	adc temp_param_0				; Add X coordinate
	sta write+1
	lda ScreenLineLookupHi,x	; Get the HIGH part of the screen adress
	adc #0					; Eventually add the carry to complete the 16 bits addition
	sta write+2				



	; Initialise message adress using the stack parameter
	; this uses self-modifying code
	; (the $0123 is replaced by message adress)
	lda temp_param_2
	sta read+1
	iny
	lda temp_param_3
	sta read+2


	; Start at the first character
	ldx #0
loop_char

	; Read the character, exit if it's a 0
read
	lda $0123,x
	beq end_loop_char

	; Write the character on screen
write
	sta $0123,x

	; Next character, and loop
	inx
	jmp loop_char  

	; Finished !
end_loop_char
	rts
.)
; --------------------------------------------------------------------

