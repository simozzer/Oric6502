
StartProg
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Main program
; ------------------------------------------------------------------------------
    :start
    
   
    ;// NOKEYCLICK+SCREEN no cursor
	lda #8+2	
	sta $26a

    jsr _InitIRQ
 
    jsr clearScreen    
    jsr initTrailMemory 

    jsr MakeCharacters_1
    jsr BackupCharacters
    jsr SetPaper
    jsr SetInk
    jsr printWaitMessage


    // The value here will set the rendering mode
    ;lda #DISPLAY_MODE_TOP_TO_BOTTOM
    lda #DISPLAY_MODE_SIDE_BY_SIDE
    sta _display_mode
    sta _last_display_mode

    
    // Initialise the random generator values (taken from kong, which was supplied with the OSDK)
	lda #23
	sta rand_low
	lda #35
	sta rand_high

    lda #GAME_MODE_WAITING
    sta _game_mode


startagain
    jsr initTrailMemory
    jsr MazeRender
    jsr printScrollInstructions
    jsr clearScreen
    jsr SetPaper
    jsr SetInk
    lda #0
    sta _player_animation_index

    //setup player 1
    lda #PLAYER_1_START_X
    sta _player1_x    
    lda #PLAYER_1_START_Y
    sta _player1_y
    lda #PLAYER_DIRECTION_UP
    sta _player1_direction
    lda #PLAYER_STATUS_BOTH_ALIVE
    sta _player_status

    // render player
    ldy _player1_y
    lda OffscreenLineLookupLo,Y
    sta _maze_line_start_lo
    lda OffscreenLineLookupHi,y
    sta _maze_line_start_hi
    lda #PLAYER1_SEGEMENT_CHAR_CODE ; character code for segment of light trail
    ldy _player1_x
    sta (_maze_line_start),y


    
    //setup player 2
    lda #PLAYER_2_START_X
    sta _player2_x    
    lda #PLAYER_2_START_Y
    sta _player2_y
    lda #PLAYER_DIRECTION_RIGHT
    sta _player2_direction

    setMode
    lda _display_mode
    sta _last_display_mode
    cmp #DISPLAY_MODE_FULLSCREEN
    bne nextMode0
    jsr runFullScreen   
    jmp checkMode
     
    nextMode0
    cmp #DISPLAY_MODE_SIDE_BY_SIDE
    bne nextMode1
    jsr runSideBySide  
    jsr renderSideBySideSplitter
    jmp checkMode

    nextMode1
    cmp #DISPLAY_MODE_TOP_TO_BOTTOM
    bne checkMode
    jsr renderTopBottomSplitter
    jsr runTopToBottom
    
    :checkMode
    lda _last_display_mode
    cmp _display_mode
    bne setMode
    
    jmp startagain 
    rts 



runFullScreen
    .(
    // set up dimensions for screen to render    
    fullScreenLoop
    jsr setMetricsForFullScreen

    jsr plotArea
    lda _game_mode
    beq continue
    jsr waitToStart
    lda _display_mode
    cmp #DISPLAY_MODE_FULLSCREEN
    bne stop

    continue
    jsr AnimateCharacters

    jsr processKeyboardPlayer1
    jsr updateMovementPlayer1


    jsr updateMovementPlayer2

    jsr smallDelay
    
    lda _player_status
    cmp #PLAYER_STATUS_BOTH_ALIVE
    beq fullScreenLoop

    lda #GAME_MODE_WAITING
    sta _game_mode

    stop
    rts
    .)

runSideBySide
    .(
    // set initial maze position
    jsr renderSideBySideSplitter
    
    // set up dimensions for screen to render    
    :sideScreenLoop
    jsr setMetricsForLeftScreen

    lda _game_mode ; don't update player position if game is not running
    bne render0
    jsr processKeyboardPlayer1
    jsr updateMovementPlayer1

    render0
    jsr plotArea ; render left screen
    jsr AnimateCharacters
    
    // set up dimensions for screen to render    
    jsr setMetricsForRightScreen

    lda _game_mode ; don't update position if game is not running
    bne render1
    jsr updateMovementPlayer2

    render1
    jsr plotArea 
    
    lda _game_mode ; show start screen if game is not running
    beq continue
    jsr waitToStart
    lda _display_mode
    cmp #DISPLAY_MODE_SIDE_BY_SIDE
    bne stop

    continue
    jsr smallDelay

    lda _player_status
    cmp #PLAYER_STATUS_BOTH_ALIVE
    bne someoneDied
    jmp sideScreenLoop
    someoneDied
    lda #GAME_MODE_WAITING
    sta _game_mode

    stop
    rts
    .)



runTopToBottom
.(
    // set initial maze position
    jsr renderTopBottomSplitter
    
    // set up dimensions for screen to render    
    :vertScreenLoop
    jsr setMetricsForTopScreen

    lda _game_mode ; don't update player position if game is not running
    bne render0
    jsr processKeyboardPlayer1
    jsr updateMovementPlayer1

    render0
    jsr plotArea ; render left screen
    jsr AnimateCharacters
    
    // set up dimensions for screen to render  
    jsr setMetricsForBottomScreen

    lda _game_mode ; don't update position if game is not running
    bne render1
    jsr updateMovementPlayer2

    render1
    jsr plotArea 
    
    lda _game_mode ; show start screen if game is not running
    beq continue
    jsr waitToStart
    lda _display_mode
    cmp #DISPLAY_MODE_TOP_TO_BOTTOM
    bne stop

    continue
    jsr smallDelay

    lda _player_status
    cmp #PLAYER_STATUS_BOTH_ALIVE
    bne someoneDied
    jmp vertScreenLoop
    someoneDied
    lda #GAME_MODE_WAITING
    sta _game_mode

    stop
    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

startScreenInstructions_0 .byt PAPER_YELLOW, INK_RED,   "    PRESS SPACE TO START      ", PAPER_BLACK, INK_GREEN, 0
startScreenInstructions_1 .byt PAPER_YELLOW, INK_RED,   "PRESS S TO TOGGLE SCREEN MODE ", PAPER_BLACK, INK_GREEN, 0
startScreenInstructions_2 .byt PAPER_YELLOW, INK_RED,   "   PRESS M TO TOGGLE MUSIC    ", PAPER_BLACK, INK_GREEN, 0


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; printStartScreen: 
;   display instructions
; ------------------------------------------------------------------------------
printStartScreen
.(
    ldy #10
    lda ScreenLineLookupLo,y
    sta _line_start_lo
    lda ScreenLineLookupHi,Y
    sta _line_start_hi
    ldy #5
    ldx #0
    .(
        loop
        lda startScreenInstructions_0,x
        beq nextLine0
        sta (_line_start),Y
        inx
        iny
        jmp loop
    .)
    :nextLine0
    ldy #11
    lda ScreenLineLookupLo,y
    sta _line_start_lo
    lda ScreenLineLookupHi,Y
    sta _line_start_hi
    ldy #5
    ldx #0
    .(
        loop
        lda startScreenInstructions_1,x
        beq nextLine1
        sta (_line_start),Y
        inx
        iny
        jmp loop
    .)

    :nextLine1
    ldy #12
    lda ScreenLineLookupLo,y
    sta _line_start_lo
    lda ScreenLineLookupHi,Y
    sta _line_start_hi
    ldy #5
    ldx #0
    .(
        loop
        lda startScreenInstructions_2,x
        beq done
        sta (_line_start),Y
        inx
        iny
        jmp loop
    .)
    done
    rts
.)


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; waitToStart: 
;   display message and wait for keypress to start game
; ------------------------------------------------------------------------------
waitToStart
.(
    ; Display start screen
    jsr printStartScreen
    jsr smallDelay

    :waitLoop
    ; use the modified keyoard handler to check for key presses

    ; lookup the space key in the key matrix
    ldy #0
    lda _KeyRowArrows,y;
    and #01; cpx #KEY_SPACE
    bne startGame
    beq checkS

    startGame
    ;jsr initTrailMemory
    lda #GAME_MODE_RUNNING
    sta _game_mode

    lda _display_mode
    cmp #DISPLAY_MODE_FULLSCREEN
    bne checkSplitter
    rts

    checkSplitter
    cmp #DISPLAY_MODE_SIDE_BY_SIDE
    bne nextSplitter
    jsr renderSideBySideSplitter
    rts

    nextSplitter
    jsr renderTopBottomSplitter
    rts

    checkS
    ; lookup the S key in the key matrix
    ldy #6
    lda _KeyMatrix,Y
    and #64 ;#KEY_S
    beq checkM
    jsr keyDelay
    lda _display_mode
    cmp #DISPLAY_MODE_SIDE_BY_SIDE
    beq nextMode_0
    cmp #DISPLAY_MODE_FULLSCREEN
    beq nextMode_1

    lda #DISPLAY_MODE_SIDE_BY_SIDE
    sta _display_mode
    jsr setMetricsForLeftScreen
    jsr plotArea
    jsr setMetricsForRightScreen
    jsr plotArea
    jsr renderSideBySideSplitter
    jmp plotStartScreen


    :nextMode_0
    lda #DISPLAY_MODE_FULLSCREEN
    sta _display_mode
    jsr setMetricsForFullScreen
    jsr plotArea
    jmp plotStartScreen

    :nextMode_1
    lda #DISPLAY_MODE_TOP_TO_BOTTOM
    sta _display_mode
    jsr setMetricsForTopScreen
    jsr plotArea
    jsr setMetricsForBottomScreen
    jsr plotArea
    jsr renderTopBottomSplitter

    :plotStartScreen
    jsr printStartScreen
    jmp waitLoop

    checkM

    ; lookup the M key in the key matrix
    ldy #02
    lda _KeyMatrix,Y
    and #01
    cmp #01
    beq toggleSound
    bne loop

    toggleSound
    jsr keyDelay
    sei

    lda ROM_CHECK_ADDR; // EDAD contains 49 (ascii code for 1 with rom 1.1)
    cmp #ROM_CHECK_ATMOS
    bcc checkOric1Interupt
    
    lda INTSL_ATMOS
    jmp toggleMusic
    
    checkOric1Interupt
    lda INTSL_ORIC1
    
    :toggleMusic
    cmp #$40; RTI
    beq initMusic
    jsr stopMusic
    jmp waitLoop

    initMusic
    jsr startMusic

    loop
    jmp waitLoop

.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; printScrollInstructions: 
;   Print some instructions in the status line at the top of the screen
; ------------------------------------------------------------------------------    
:printScrollInstructions                                 
    lda #<ScrollInstructions
    sta loadMessageLoop+1
    lda #>ScrollInstructions
    sta loadMessageLoop+2
    jsr printStatusMessage
    rts
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; printWaitMessage: 
;   Print some instructions in the status line at the top of the screen
;   while we're waiting for the offscreen 'maze' to be built
; ------------------------------------------------------------------------------      
:printWaitMessage
    lda #<WaitMessage
    sta loadMessageLoop+1
    lda #>WaitMessage
    sta loadMessageLoop+2
    jsr printStatusMessage
    rts
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; MakeCharacters_1: 
;   reconfigure the character set so that we have some sprites/alternative 
;   characters to use in 'game' mode.
; ------------------------------------------------------------------------------            
:MakeCharacters_1
    lda #<preNumericSpriteData
    sta _copy_mem_src_lo
    lda #>preNumericSpriteData
    sta _copy_mem_src_hi
    lda #121; byte count
    sta _copy_mem_count_lo                         
    lda #$00                        
    sta _copy_mem_count_hi                        
    lda #$08                        
    sta _copy_mem_dest_lo                      
    lda #$B5                      
    sta _copy_mem_dest_hi                        
    jsr CopyMemory   


    lda #<_AltSpriteData                   
    sta _copy_mem_src_lo                         
    lda #>_AltSpriteData
    sta _copy_mem_src_hi                         
    lda #241 ; BYTE COUNT           
    sta _copy_mem_count_lo                         
    lda #$00                        
    sta _copy_mem_count_hi                        
    lda #$08                        
    sta _copy_mem_dest_lo                      
    lda #$B7                        
    sta _copy_mem_dest_hi                        
    jsr CopyMemory                                              
    rts    
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 




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
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


startMusic
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Start playback of tracker music
; ------------------------------------------------------------------------------
.(
    ;// Initialize data for the tracker
    lda #TRACKER_PLAY_MODE_SONG
    sta _tracker_play_mode
    lda #16
    sta _tracker_last_step
    lda #0
    sta _tracker_bar_index
    sta _tracker_bar_step_index
    jsr clearSound

    ; setup interrupt for playing back music
    jsr setupTrackerInterrupt

    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

stopMusic
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Stop playback of tracker music
; ------------------------------------------------------------------------------
.(
    jsr clearTrackerInterupt

    jsr clearSound

    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<




; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Screen filler: (not used)
;   Fill screen in turn with characters from a-z and repeat
;    Exit if key pressed
; ------------------------------------------------------------------------------
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
    cpx KEY_PRESS_NONE                                        
    bne ExitScreenFill    

    jmp print_line                          
    :ExitScreenFill 
    rts
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<    








