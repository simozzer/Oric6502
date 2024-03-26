StartProg
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Main program
; ------------------------------------------------------------------------------
    :start

   
    ;// NOKEYCLICK+SCREEN no cursor
	lda #8+2	
	sta $26a

    jsr setupDefaultKeys

    ; enable the tracker interupt but start with music disabled
    lda #1
    sta _tracker_running;
    jsr setupTrackerInterrupt;

    jsr clearSound;

    jsr _InitIRQ
 
    jsr clearScreen    

    jsr MakeCharacters_1
    jsr BackupCharacters
    jsr SetPaper
    jsr SetInk
    jsr printWaitMessage

    lda #PLAYER_COUNT_1
    sta player_count

    // The value here will set the rendering mode
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
    jsr MazeRender
    jsr clearStatusLine
    jsr clearScreen
    jsr SetPaper
    jsr SetInk
    lda #0
    sta _player_animation_index

    //setup player 1
    SETUP
    lda #01
    sta _player1_id
    lda #PLAYER_1_START_X
    sta _player1_x    
    lda #PLAYER_1_START_Y
    sta _player1_y
    lda #PLAYER_DIRECTION_UP
    sta _player1_direction
    lda #PLAYER_EFFECT_TYPE_NONE
    sta _player1_effect_type
    lda #0
    sta _player1_effect_cycles_remaining
    
    lda #<trail_x_pos_player_1
    sta _player1_trail_data_x_lo
    lda #>trail_x_pos_player_1
    sta _player1_trail_data_x_hi

    lda #<trail_y_pos_player_1
    sta _player1_trail_data_y_lo
    lda #>trail_y_pos_player_1
    sta _player1_trail_data_y_hi

    lda #<trail_char_player_1
    sta _player1_trail_data_char_lo
    lda #>trail_char_player_1
    sta _player1_trail_data_char_hi

    lda #<player1_data
    sta _player_data_lo
    lda #>player1_data
    sta _player_data_hi
    jsr initTrailMemory

    lda #PLAYER1_SEGEMENT_CHAR_CODE
    sta _player1_char_code

    
    lda #PLAYER_STATUS_BOTH_ALIVE
    sta _player_status
    
    ; plot a safe zone around the starting position
    lda _player1_x
    sta center_x
    lda _player1_y
    sta center_y
    jsr plotSafeSpace

    
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
    lda #02
    sta _player2_id
    lda #PLAYER_2_START_X
    sta _player2_x    
    lda #PLAYER_2_START_Y
    sta _player2_y
    lda #PLAYER_DIRECTION_RIGHT
    sta _player2_direction
    lda #PLAYER_EFFECT_TYPE_NONE
    sta _player2_effect_type
    lda #0
    sta _player2_effect_cycles_remaining

    lda #<trail_x_pos_player_2
    sta _player2_trail_data_x_lo
    lda #>trail_x_pos_player_2
    sta _player2_trail_data_x_hi

    lda #<trail_y_pos_player_2
    sta _player2_trail_data_y_lo
    lda #>trail_y_pos_player_2
    sta _player2_trail_data_y_hi

    lda #<trail_char_player_2
    sta _player2_trail_data_char_lo
    lda #>trail_char_player_2
    sta _player2_trail_data_char_hi

    
    lda #<player2_data
    sta _player_data_lo
    lda #>player2_data
    sta _player_data_hi
    jsr initTrailMemory

    lda #PLAYER2_SEGEMENT_CHAR_CODE + 128;  Plus 128 for inverse 
    sta _player2_char_code

    ; plot a safe zone around the starting position
    lda _player2_x
    sta center_x
    lda _player2_y
    sta center_y
    jsr plotSafeSpace


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
    jsr smallDelay
    jsr AnimateCharacters

    jsr processMovements
    
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

    
    lda #<player1_data
    sta _player_data_lo
    lda #>player1_data
    sta _player_data_hi

    render0
    jsr plotArea ; render left screen
    jsr AnimateCharacters
    
    // set up dimensions for screen to render    
    jsr setMetricsForRightScreen

    lda _game_mode ; don't update position if game is not running
    bne render1
    
    jsr processMovements

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
    
    lda #<player1_data
    sta _player_data_lo
    lda #>player1_data
    sta _player_data_hi

    render0
    jsr plotArea ; render left screen
    jsr AnimateCharacters
    
    // set up dimensions for screen to render  
    jsr setMetricsForBottomScreen

    lda _game_mode ; don't update position if game is not running
    bne render1
    
    jsr processMovements

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



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; printStartScreen: 
;   display instructions
; ------------------------------------------------------------------------------
printStartScreen
.(
    ldy #9
    lda ScreenLineLookupLo,y
    sta _line_start_lo
    lda ScreenLineLookupHi,Y
    sta _line_start_hi
    ldy #5
    ldx #0
    .(
        loop
        lda player_count
        bne display_player_count_2
        lda startScreenInstructions_1player,x
        jmp checkEndOfLine
        
        display_player_count_2
        lda startScreenInstructions_2players,x
        
        :checkEndOfLine    
        beq nextLine_
        sta (_line_start),Y
        inx
        iny
        jmp loop
    .)
    nextLine_
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
        beq nextLine2
        sta (_line_start),Y
        inx
        iny
        jmp loop
    .)

    nextLine2
    ldy #13
    lda ScreenLineLookupLo,y
    sta _line_start_lo
    lda ScreenLineLookupHi,Y
    sta _line_start_hi
    ldy #5
    ldx #0
    .(
        loop
        lda startScreenInstructions_3,x
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
    :redo
    ; Display start screen
    jsr printStartScreen
    jsr keyDelay


    :waitLoop
    ; use the modified keyoard handler to check for key presses

    ; lookup the space key in the key matrix
    ldy #0
    lda _KeyRowArrows,y;
    and #01; cpx #KEY_SPACE
    bne startGame
    beq checkS

    startGame

    jsr initTrailMemory
    lda #GAME_MODE_RUNNING
    sta _game_mode
    jsr renderGameArea
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
    jmp render

    :nextMode_0
    lda #DISPLAY_MODE_FULLSCREEN
    sta _display_mode
    jmp render

    :nextMode_1
    lda #DISPLAY_MODE_TOP_TO_BOTTOM
    sta _display_mode
 
    :render
    jsr renderGameArea

    :plotStartScreen
    jsr printStartScreen

    jsr keyDelay
    jmp waitLoop

    checkM
    ; lookup the M key in the key matrix
    ldy #02
    lda _KeyMatrix,Y
    and #01
    cmp #01
    beq toggleSound
    bne checkK

    toggleSound
    jsr keyDelay
    lda _tracker_running
    beq stopMusic
    jsr enableMusicPlayback
    jmp redo

    stopMusic
    jsr disableMusicPlayback
    jmp redo

    checkK
    ldy #03
    lda _KeyMatrix,Y
    and #01
    cmp #01
    bne checkT
    jsr runKeyboardMapper
    jsr MakeCharacters_1
    jsr SetPaper
    jsr SetInk
    jsr renderGameArea
    jsr keyDelay
    jmp redo

    checkT
    ldy #01
    lda _KeyMatrix,Y
    and #02
    cmp #02
    bne loop

    lda player_count
    beq setPlayerCount2

    lda #PLAYER_COUNT_1
    sta player_count
    jmp redo

    setPlayerCount2
    lda #PLAYER_COUNT_2
    sta player_count
    jmp redo

    loop
    jmp waitLoop

.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; renderGameArea: 
;   Render the game area for the current display mode
; ------------------------------------------------------------------------------ 
renderGameArea
.(
    lda _display_mode
    beq renderFullScreen

    cmp #DISPLAY_MODE_SIDE_BY_SIDE
    beq renderSideBySide

    ; render top to bottom
    jsr setMetricsForTopScreen
    jsr plotArea
    jsr setMetricsForBottomScreen
    jsr plotArea
    jsr renderTopBottomSplitter
    rts

    renderFullScreen
    jsr setMetricsForFullScreen
    jsr plotArea
    rts

    renderSideBySide
    jsr setMetricsForLeftScreen
    jsr plotArea
    jsr setMetricsForRightScreen
    jsr plotArea
    jsr renderSideBySideSplitter
    rts
.)
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


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; SetInk: Sets the global ink color for the screen
; ------------------------------------------------------------------------------ 
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
    .)
    rts
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; SetInk: Sets the global paper color for the screen
; ------------------------------------------------------------------------------ 
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
    .)
    rts
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

processMovements
.(
    lda #<player1_data
    sta _player_data_lo
    lda #>player1_data
    sta _player_data_hi

    jsr processKeyboardPlayer1
    jsr processJoystickPlayer1
    jsr updateMovement



    lda #<player2_data
    sta _player_data_lo
    lda #>player2_data
    sta _player_data_hi

    lda player_count
    beq _updateMovementComputerPlayer

    jsr processKeyboardplayer2
    jsr processJoystickPlayer2
    jmp doMove

    _updateMovementComputerPlayer
    jsr chooseDirectionForComputerPlayer

    :doMove
    jsr updateMovement



    // Check if either player is in fast mode and move again
    ldy #PLAYER_DATA_OFFSET_EFFECT_TYPE
    lda #<player1_data
    sta _player_data_lo
    lda #>player1_data
    sta _player_data_hi
    lda (_player_data),Y
    cmp #PLAYER_EFFECT_TYPE_FAST
    bne checkPlayer2
    jsr processKeyboardPlayer1
    jsr processJoystickPlayer1
    jsr updateMovement

    checkPlayer2
    ldy #PLAYER_DATA_OFFSET_EFFECT_TYPE
    lda #<player2_data
    sta _player_data_lo
    lda #>player2_data
    sta _player_data_hi
    lda (_player_data),Y
    cmp #PLAYER_EFFECT_TYPE_FAST
    bne doDelay


    lda player_count
    beq _updateMovementComputerPlayer2

    jsr processKeyboardplayer2
    jsr processJoystickPlayer2
    jmp doMove2

    _updateMovementComputerPlayer2
    jsr chooseDirectionForComputerPlayer

    :doMove2
    jsr updateMovement

    doDelay
    jsr smallDelay

    rts
.)

