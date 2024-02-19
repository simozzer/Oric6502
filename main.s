

StartProg
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Main program
; ------------------------------------------------------------------------------
    :start
    
   
    ;// NOKEYCLICK+SCREEN no cursor
	lda #8+2	
	sta $26a

    jsr startMusic

    jsr printTestInstructions    
    jsr clearScreen     

    jsr MakeCharacters_1
    jsr BackupCharacters
    jsr SetPaper
    jsr SetInk
    jsr printWaitMessage


    // The value here will set the rendering mode
    lda #DISPLAY_MODE_TOP_TO_BOTTOM
    ;lda #DISPLAY_MODE_SIDE_BY_SIDE
    sta _display_mode

    
    // Initialise the random generator values (taken from kong, which was supplied with the OSDK)
	lda #23
	sta rand_low
	lda #35
	sta rand_high

    lda #GAME_MODE_WAITING
    sta _game_mode


startagain
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

    
    lda _display_mode
    cmp #DISPLAY_MODE_FULLSCREEN
    bne nextMode0
    jsr runFullScreen   
    jmp end
     
    nextMode0
    cmp #DISPLAY_MODE_SIDE_BY_SIDE
    bne nextMode1
    jsr runSideBySide  
    jmp end

    nextMode1
    cmp #DISPLAY_MODE_TOP_TO_BOTTOM
    bne end
    jsr runTopToBottom


end
    jmp startagain
   ;; jsr CopyRamToChars    
    rts 

setMazePositionForFullScreen
.(
    lda #FULLSCREEN_MAZE_X
    sta _maze_left
    sta _player1_maze_x
    lda #FULLSCREEN_MAZE_Y
    sta _maze_top
    sta _player1_maze_y
    rts
.) 

setMetricsForFullScreen
.(
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
    lda #FULL_SCREEN_SCROLL_LEFT_MAZE_X_THRESHOLD
    sta _scroll_left_maze_x_threshold
    lda #FULL_SCREEN_SCROLL_RIGHT_MAZE_X_THRESHOLD
    sta _scroll_right_maze_x_threshold
    lda #FULL_SCREEN_SCROLL_RIGHT_MAX_MAZE_X
    sta _scroll_right_max_maze_x  
    lda #FULL_SCREEN_SCROLL_UP_MAZE_Y_THRESHOLD
    sta _scroll_up_maze_y_threshold  
    lda #FULL_SCREEN_SCROLL_DOWN_MAX_MAZE_Y
    sta _scroll_down_maze_y_threshold 
    lda #FULL_SCREEN_SCROLL_DOWN_MAZE_Y_THRESHOLD
    sta _scroll_down_max_maze_y

    lda _player1_maze_x
    sta _maze_left
    lda _player1_maze_y
    sta _maze_top
    rts
.)

setMazePositionForSideBySide
.(
    lda #LEFT_SCREEN_MAZE_X
    sta _player1_maze_x
    lda #LEFT_SCREEN_MAZE_Y
    sta _player1_maze_y

    lda #RIGHT_SCREEN_MAZE_X
    sta _player2_maze_x
    lda #RIGHT_SCREEN_MAZE_Y
    sta _player2_maze_y
    rts
.)

setMetricsForLeftScreen
.(
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
    lda #LEFT_SCREEN_SCROLL_LEFT_MAZE_X_THRESHOLD
    sta _scroll_left_maze_x_threshold
    lda #LEFT_SCREEN_SCROLL_RIGHT_MAZE_X_THRESHOLD
 
    sta _scroll_right_maze_x_threshold
    lda #LEFT_SCREEN_SCROLL_RIGHT_MAX_MAZE_X
    sta _scroll_right_max_maze_x
    lda #LEFT_SCREEN_SCROLL_UP_MAZE_Y_THRESHOLD
    sta _scroll_up_maze_y_threshold
    lda #LEFT_SCREEN_SCROLL_DOWN_MAX_MAZE_Y
    sta _scroll_down_maze_y_threshold 
    lda #LEFT_SCREEN_SCROLL_DOWN_MAZE_Y_THRESHOLD
    sta _scroll_down_max_maze_y

    lda _player1_maze_x
    sta _maze_left
    lda _player1_maze_y
    sta _maze_top
    rts
.)

setMetricsForRightScreen
.(
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
    lda #RIGHT_SCREEN_SCROLL_LEFT_MAZE_X_THRESHOLD
    sta _scroll_left_maze_x_threshold
    lda #RIGHT_SCREEN_SCROLL_RIGHT_MAZE_X_THRESHOLD
    sta _scroll_right_maze_x_threshold
    lda #RIGHT_SCREEN_SCROLL_RIGHT_MAX_MAZE_X
    sta _scroll_right_max_maze_x
    lda #RIGHT_SCREEN_SCROLL_UP_MAZE_Y_THRESHOLD
    sta _scroll_up_maze_y_threshold 
    lda #RIGHT_SCREEN_SCROLL_DOWN_MAX_MAZE_Y
    sta _scroll_down_maze_y_threshold 
    lda #RIGHT_SCREEN_SCROLL_DOWN_MAZE_Y_THRESHOLD
    sta _scroll_down_max_maze_y

    lda _player2_maze_x
    sta _maze_left
    lda _player2_maze_y
    sta _maze_top
    rts
.)


setMazePositionForTopToBottom
.(
    lda #TOPSCREEN_MAZE_X
    sta _player1_maze_x
    lda #TOPSCREEN_MAZE_Y
    sta _player1_maze_y

/*
    lda #BOTTOMSCREEN_MAZE_X
    sta _player2_maze_x
    lda #BOTTOMSCREEN_MAZE_Y
    sta _player2_maze_y
    rts
*/
.)


setMetricsForTopScreen
.(
    lda #TOPSCREEN_TEXT_LAST_COLUMN
    sta _screen_render_right
    lda #TOPSCREEN_TEXT_LAST_LINE
    sta _screen_render_bottom
    lda #TOPSCREEN_TEXT_MAZE_OFFSET_X
    sta _maze_render_offset_x
    lda #TOPSCREEN_TEXT_X_WRAP
    sta _screen_render_x_wrap
    lda #TOPSCREEN_TEXT_Y_WRAP 
    sta _screen_render_y_wrap
    lda #TOP_SCREEN_SCROLL_LEFT_MAZE_X_THRESHOLD
    sta _scroll_left_maze_x_threshold
    lda #TOP_SCREEN_SCROLL_RIGHT_MAZE_X_THRESHOLD
 
    sta _scroll_right_maze_x_threshold
    lda #TOP_SCREEN_SCROLL_RIGHT_MAX_MAZE_X
    sta _scroll_right_max_maze_x
    lda #TOP_SCREEN_SCROLL_UP_MAZE_Y_THRESHOLD
    sta _scroll_up_maze_y_threshold
    lda #TOP_SCREEN_SCROLL_DOWN_MAX_MAZE_Y
    sta _scroll_down_maze_y_threshold 
    lda #TOP_SCREEN_SCROLL_DOWN_MAZE_Y_THRESHOLD
    sta _scroll_down_max_maze_y

    lda _player1_maze_x
    sta _maze_left
    lda _player1_maze_y
    sta _maze_top
    rts
.)

runFullScreen
    .(
    // set initial maze position
    jsr setMazePositionForFullScreen
    
    // set up dimensions for screen to render    
    fullScreenLoop
    jsr setMetricsForFullScreen

    jsr ScreenRender
    lda _game_mode
    beq continue
    jsr waitToStart

    continue
    jsr AnimateCharacters

    jsr processKeyboardPlayer1
    jsr updateMovementPlayer1

    lda _player2_maze_x
    sta _maze_left
    lda _player2_maze_y
    sta _maze_top

    jsr updateMovementPlayer2

    jsr smallDelay
    
    lda _player_status
    cmp #PLAYER_STATUS_BOTH_ALIVE
    beq fullScreenLoop

    lda #GAME_MODE_WAITING
    sta _game_mode
    rts
    .)

runSideBySide
    .(
    // set initial maze position
    jsr setMazePositionForSideBySide
    jsr renderSideBySideSplitter
    
    // set up dimensions for screen to render    
    :sideScreenLoop
    jsr setMetricsForLeftScreen

    lda _game_mode ; don't update player position if game is not running
    bne render0
    jsr processKeyboardPlayer1
    jsr updateMovementPlayer1

    render0
    jsr ScreenRender ; render left screen
    jsr AnimateCharacters
    
    // set up dimensions for screen to render    
    jsr setMetricsForRightScreen

    lda _game_mode ; don't update position if game is not running
    bne render1
    jsr updateMovementPlayer2

    render1
    jsr ScreenRender 
    
    lda _game_mode ; show start screen if game is not running
    beq continue
    jsr waitToStart

    continue
    jsr smallDelay

    lda _player_status
    cmp #PLAYER_STATUS_BOTH_ALIVE
    bne someoneDied
    jmp sideScreenLoop
    someoneDied
    lda #GAME_MODE_WAITING
    sta _game_mode
    rts
    .)

runTopToBottom
.(
    // set initial maze position
    jsr setMazePositionForTopToBottom
   ; jsr renderSideBySideSplitter
    
    // set up dimensions for screen to render    
    :vertScreenLoop
    jsr setMetricsForTopScreen

    lda _game_mode ; don't update player position if game is not running
    bne render0
    jsr processKeyboardPlayer1
    jsr updateMovementPlayer1

    render0
    jsr ScreenRender ; render left screen
    jsr AnimateCharacters
    
    // set up dimensions for screen to render 
    /*   
    jsr setMetricsForBottomScreen

    lda _game_mode ; don't update position if game is not running
    bne render1
    jsr updateMovementPlayer2

    render1
    jsr ScreenRender 
    */
    lda _game_mode ; show start screen if game is not running
    beq continue
    jsr waitToStart

    continue
    jsr smallDelay

    lda _player_status
    cmp #PLAYER_STATUS_BOTH_ALIVE
    bne someoneDied
    jmp vertScreenLoop
    someoneDied
    lda #GAME_MODE_WAITING
    sta _game_mode
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
    ldx KEY_PRESS_LOOKUP
    cpx _last_key
    beq waitLoop
    stx _last_key

    cpx #KEY_SPACE
    beq startGame

    cpx #KEY_S
    bne checkM
    lda _display_mode
    cmp #DISPLAY_MODE_SIDE_BY_SIDE
    beq setFullScreen

        lda #DISPLAY_MODE_SIDE_BY_SIDE
    sta _display_mode
    jsr setMazePositionForSideBySide
    jsr setMetricsForLeftScreen
    jsr ScreenRender
    jsr setMetricsForRightScreen
    jsr ScreenRender
    jsr renderSideBySideSplitter
    jsr printStartScreen
    jmp waitLoop


    setFullScreen
    lda #DISPLAY_MODE_FULLSCREEN
    sta _display_mode
    jsr setMazePositionForFullScreen
    jsr setMetricsForFullScreen
    
    jsr ScreenRender
    jsr printStartScreen

    jmp waitLoop

    checkM
    cpx #KEY_M
    bne loop

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
    
    startGame
    lda #GAME_MODE_RUNNING
    sta _game_mode
    jsr renderSideBySideSplitter
    rts

.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Screen filler: 
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



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; printTestInstructions: 
;   Print some instructions in the status line at the top of the screen
; ------------------------------------------------------------------------------
printTestInstructions
    lda #<TestInstructions
    sta loadMessageLoop+1
    lda #>TestInstructions
    sta loadMessageLoop+2
    jsr printStatusMessage
    rts
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
; CopySetToRam: 
;   Copy initial data for characters a-z into a buffer so we can restore them 
;   later
; ------------------------------------------------------------------------------   
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
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; CopyRamToChars: 
;   Copy initial data for characters a-z back from buffer so that we can use
;   the entire initial character set outside of 'game mode'.
; ------------------------------------------------------------------------------                                  
:CopyRamToChars 
    lda #<_SpriteBackup_; lo byte of source                 
    sta _copy_mem_src_lo                        
    lda #>_SpriteBackup_; hi byte of source
    sta _copy_mem_src_hi                         
    lda #241                       
    sta _copy_mem_count_lo                    
    lda #$00                        
    sta _copy_mem_count_hi                        
    lda #$08  ;lo bye of dest                      
    sta _copy_mem_dest_lo                         
    lda #$B7  ;hi byte of dest                      
    sta _copy_mem_dest_hi                         
    jsr CopyMemory                       
    rts                             
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; MakeCharacters_1: 
;   reconfigure the character set so that we have some sprites/alternative 
;   characters to use in 'game' mode.
; ------------------------------------------------------------------------------            
:MakeCharacters_1
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







