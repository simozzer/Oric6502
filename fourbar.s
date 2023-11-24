// Called fourbar, as a reference to foo-bar
// Each bar will contain 16 semi-quavers, 
// and we will just allow for four bars of music (initially)
// For each channel we will store (per semi quaver)
// Octave (hi-nibble) & Note (lo-nibble)(lo-word)
// Length (hi-nibble) & Vol (lo-nibble)(hi-word)
// so we should be able to contain a 'tune' in 128 bytes per channel.
// We will just allow for 2 channels of music,
// this will leave 1 tone channel for the game to use for simple sfx 
// the noise channel should also be available, if I can work out
// how to use this for drums then I will.


// There are much better tunes available using things
// like MYM, and other programs to created to use Atari St
// music files - but these seem to take a lot of memory 
// or a lot of CPU time decompressing existing data.
// I'm trying to keep things as simple a possible (KISS)
// to reduce the demands on CPU and memory.
// (And also to eliminate the learning curve by not 
// actually learning all the IO required to program the 
// sound chip).

// The data will be stored using this format
// OCTAVE 0-7 (3 bits, but will use 4. The hi bit will be used for 'no note')
// NOTE (1-12/ can be stores as 0-11) (4 bits)
// LENGTH (1-15) ( 4 bits)
// VOL (1-15 - volume level, 0 = use envelope from play) (4 bits)


// example screen layout for 1 bar
/*
 01234567890123456789012345678901234567
0    CHANNEL 1          CHANNEL 2
1 NOTE OCT LEN VOL   NOTE OCT LEN VOL
2-------------------------------------
3>----|---|---|---| |----|---|---|---<
4|----|---|---|---| |----|---|---|---|
5|----|---|---|---| |----|---|---|---|
6|----|---|---|---| |----|---|---|---|
7>----|---|---|---| |----|---|---|---<
8|----|---|---|---| |----|---|---|---|
9|----|---|---|---| |----|---|---|---|
0|----|---|---|---| |----|---|---|---|
1>----|---|---|---| |----|---|---|---<
2|----|---|---|---| |----|---|---|---|
3|----|---|---|---| |----|---|---|---|
4|----|---|---|---| |----|---|---|---|
5>----|---|---|---| |----|---|---|---<
6|----|---|---|---| |----|---|---|---|
7|----|---|---|---| |----|---|---|---|
8|----|---|---|---| |----|---|---|---|
9-------------------------------------
0Arrows to navigate.
1+/- to change value. 
2</> to change bar.
*/

// temporary code to test tracker screen
runTracker
.(

    jsr printTrackerInstructions
    lda #0
    sta _tracker_selected_col_index
    sta _tracker_selected_row_index
    :refreshTrackerScreen
    jsr printTrackerScreen

    :readAgain
    jsr _getKey
    ldx KEY_PRESS_LOOKUP
    cpx _last_key
    beq readAgain
    stx _last_key
    

    cpx #KEY_DOWN_ARROW
    bne checkUp
    lda _tracker_selected_row_index
    cmp #15
    bpl checkUp
    inc _tracker_selected_row_index
    jmp refreshTrackerScreen

    checkUp
    cpx #KEY_UP_ARROW
    bne checkRight
    lda _tracker_selected_row_index
    cmp #01
    bmi checkRight
    dec _tracker_selected_row_index
    jmp refreshTrackerScreen


    checkRight
    cpx #KEY_RIGHT_ARROW
    bne checkLeft
    lda _tracker_selected_col_index
    cmp #07
    bpl checkLeft
    inc _tracker_selected_col_index
    jmp refreshTrackerScreen

    checkLeft
    cpx #KEY_LEFT_ARROW
    bne checkPlus
    lda _tracker_selected_col_index
    cmp #01
    bmi checkPlus
    dec _tracker_selected_col_index
    jmp refreshTrackerScreen

    checkPlus
    cpx #KEY_PLUS
    bne checkMinus
    jsr processPlus
    jmp refreshTrackerScreen

    checkMinus
    cpx #KEY_MINUS
    bne checkQuit
    jsr processMinus
    jmp refreshTrackerScreen

    checkQuit
    cpx #KEY_Q
    bne loopAgain
    rts
    
    loopAgain
    jmp readAgain
.)



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; processPlus: 
;   handle the plus key being pressed to increment a column value
;   for the current step in the tracker display
; ------------------------------------------------------------------------------            
processPlus
.(
    ldy _tracker_selected_row_index
    lda trackerMusicDataLo,Y
    sta _copy_mem_src_lo
    lda trackerMusicDataHi,y
    sta _copy_mem_src_hi

    lda _tracker_selected_col_index
    cmp #TRACKER_COL_INDEX_NOTE_CH1
    bne nextCheck0

    ldy #0
    lda (_copy_mem_src),y
    tax
    and #$F0
    sta _hi_nibble
    txa
    and #$0f
    sta _lo_nibble
    cmp #12
    bmi incrementNoteChannel1
    jmp done

    incrementNoteChannel1 // Add to note value channel 1
    tax
    inx
    txa
    sta _lo_nibble
    adc _hi_nibble
    ldy #0
    sta (_copy_mem_src),y
    rts

nextCheck0
    cmp #TRACKER_COL_INDEX_OCT_CH1
    bne nextCheck1

    ldy #0
    lda (_copy_mem_src),y
    tax
    and #$0f
    sta _lo_nibble
    txa
    and #$f0
    lsr
    lsr 
    lsr
    lsr
    sta _hi_nibble
    clc
    cmp #07
    bcc incrementOctChannel1
    jmp done

    incrementOctChannel1 // Add to oct value channel 1
    clc
    adc #$01
    asl
    asl
    asl
    asl

    adc _lo_nibble
    ldy #0
    sta (_copy_mem_src),y
    rts

nextCheck1
    cmp #TRACKER_COL_INDEX_LEN_CH1
    bne nextCheck2

    ldy #1
    lda (_copy_mem_src),y
    tax
    and #$F0
    sta _hi_nibble
    txa
    and #$0f
    sta _lo_nibble
    cmp #15
    bmi incrementLenChannel1
    jmp done

    incrementLenChannel1 // Add to length value channel 1
    tax
    inx
    txa
    sta _lo_nibble
    adc _hi_nibble
    ldy #1
    sta (_copy_mem_src),y
    rts

nextCheck2
    cmp #TRACKER_COL_INDEX_VOL_CH1
    bne nextCheck3

    
    ldy #1
    lda (_copy_mem_src),y
    tax
    and #$0f
    sta _lo_nibble
    txa
    and #$f0
    lsr
    lsr 
    lsr
    lsr
    sta _hi_nibble
    clc
    cmp #15
    bcc incrementVolChannel1
    jmp done

    incrementVolChannel1 // Add to oct value channel 1
    clc
    adc #$01
    asl
    asl
    asl
    asl

    adc _lo_nibble
    ldy #1
    sta (_copy_mem_src),y
    rts



nextCheck3
    cmp #TRACKER_COL_INDEX_NOTE_CH2
    bne nextCheck4

    ldy #2
    lda (_copy_mem_src),y
    tax
    and #$F0
    sta _hi_nibble
    txa
    and #$0f
    sta _lo_nibble
    cmp #12
    bmi incrementNoteChannel2
    jmp done

    incrementNoteChannel2 // Add to note value channel 2
    tax
    inx
    txa
    sta _lo_nibble
    adc _hi_nibble
    ldy #2
    sta (_copy_mem_src),y
    rts

nextCheck4    
    cmp #TRACKER_COL_INDEX_OCT_CH2
    bne nextCheck5

    ldy #2
    lda (_copy_mem_src),y
    tax
    and #$0f
    sta _lo_nibble
    txa
    and #$f0
    lsr
    lsr 
    lsr
    lsr
    sta _hi_nibble
    clc
    cmp #07
    bcc incrementOctChannel2
    jmp done

    incrementOctChannel2 // Add to oct value channel 2
    clc
    adc #$01
    asl
    asl
    asl
    asl

    adc _lo_nibble
    ldy #2
    sta (_copy_mem_src),y
    rts

nextCheck5
    cmp #TRACKER_COL_INDEX_LEN_CH2
    bne nextCheck6

    ldy #3
    lda (_copy_mem_src),y
    tax
    and #$F0
    sta _hi_nibble
    txa
    and #$0f
    sta _lo_nibble
    cmp #15
    bmi incrementLenChannel2
    jmp done

    incrementLenChannel2 // Add to length value channel 2
    tax
    inx
    txa
    clc
    sta _lo_nibble
    adc _hi_nibble
    ldy #3
    sta (_copy_mem_src),y
    rts

nextCheck6
    cmp #TRACKER_COL_INDEX_VOL_CH2
    bne done

    ldy #3
    lda (_copy_mem_src),y
    tax
    and #$0f
    sta _lo_nibble
    txa
    and #$f0
    lsr
    lsr 
    lsr
    lsr
    sta _hi_nibble
    clc
    cmp #15
    bcc incrementVolChannel2
    jmp done

    incrementVolChannel2 // Add to oct value channel 2
    clc
    adc #$01
    asl
    asl
    asl
    asl

    adc _lo_nibble
    ldy #3
    sta (_copy_mem_src),y
    rts

done
    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; processMinus: 
;   handle the plus key being pressed to decrement a column value
;   for the current step in the tracker display
; ------------------------------------------------------------------------------  
processMinus
.(

    ldy _tracker_selected_row_index
    lda trackerMusicDataLo,Y
    sta _copy_mem_src_lo
    lda trackerMusicDataHi,y
    sta _copy_mem_src_hi

    lda _tracker_selected_col_index
    cmp #TRACKER_COL_INDEX_NOTE_CH1
    bne nextCheck0

    ldy #0
    lda (_copy_mem_src),y
    tax
    and #$F0
    sta _hi_nibble
    txa
    and #$0f
    sta _lo_nibble
    clc
    cmp #02
    bcs decrementNoteChanel1
    jmp done

    decrementNoteChanel1 // subtract from note value channel 1
    tax
    dex
    txa
    clc
    sta _lo_nibble
    adc _hi_nibble
    ldy #0
    sta (_copy_mem_src),y
    rts

nextCheck0
    cmp #TRACKER_COL_INDEX_OCT_CH1
    bne nextCheck1
    ldy #0
    lda (_copy_mem_src),y
    tax
    and #$0f
    sta _lo_nibble
    txa
    and #$f0
    lsr
    lsr 
    lsr
    lsr
    sta _hi_nibble
    clc
    cmp #0
    bne decrementOctChannel1
    jmp done

    decrementOctChannel1 // Add to oct value channel 1
    tax
    dex
    txa
    asl
    asl
    asl
    asl
    adc _lo_nibble
    ldy #0
    sta (_copy_mem_src),y
    rts



nextCheck1
    cmp #TRACKER_COL_INDEX_LEN_CH1
    bne nextCheck2

    
    ldy #1
    lda (_copy_mem_src),y
    tax
    and #$F0
    sta _hi_nibble
    txa
    and #$0f
    sta _lo_nibble
    clc
    cmp #01
    bne decrementLenChannel1
    jmp done

    decrementLenChannel1 // subtract from length value channel 1
    tax
    dex
    txa
    clc
    sta _lo_nibble
    adc _hi_nibble
    ldy #1
    sta (_copy_mem_src),y
    rts

nextCheck2
    cmp #TRACKER_COL_INDEX_VOL_CH1
    bne nextCheck3

    
    ldy #1
    lda (_copy_mem_src),y
    tax
    and #$0f
    sta _lo_nibble
    txa
    and #$f0
    lsr
    lsr 
    lsr
    lsr
    sta _hi_nibble
    clc
    cmp #0
    bne decrementVolChannel1
    jmp done

    decrementVolChannel1 // Add to oct value channel 1
    tax
    dex
    txa
    asl
    asl
    asl
    asl

    adc _lo_nibble
    ldy #1
    sta (_copy_mem_src),y
    rts

nextCheck3
    cmp #TRACKER_COL_INDEX_NOTE_CH2
    bne nextCheck4

    ldy #2
    lda (_copy_mem_src),y
    tax
    and #$F0
    sta _hi_nibble
    txa
    and #$0f
    sta _lo_nibble
    clc
    cmp #02
    bcs decrementNoteChanel2
    jmp done

    decrementNoteChanel2 // subtract from note value channel 2
    tax
    dex
    txa
    clc
    sta _lo_nibble
    adc _hi_nibble
    ldy #2
    sta (_copy_mem_src),y
    rts


nextCheck4    
    cmp #TRACKER_COL_INDEX_OCT_CH2
    bne nextCheck5

    ldy #2
    lda (_copy_mem_src),y
    tax
    and #$0f
    sta _lo_nibble
    txa
    and #$f0
    lsr
    lsr 
    lsr
    lsr
    sta _hi_nibble
    clc
    cmp #0
    bne decrementOctChannel2
    jmp done

    decrementOctChannel2 // subtract from oct value channel 2
    tax
    dex
    txa
    asl
    asl
    asl
    asl

    adc _lo_nibble
    ldy #2
    sta (_copy_mem_src),y
    rts

nextCheck5
    cmp #TRACKER_COL_INDEX_LEN_CH2
    bne nextCheck6
    ldy #3
    lda (_copy_mem_src),y
    tax
    and #$F0
    sta _hi_nibble
    txa
    and #$0f
    sta _lo_nibble
    clc
    cmp #01
    bne decrementLenChannel2
    jmp done

    decrementLenChannel2 // subtract from length value channel 1
    tax
    dex
    txa
    clc
    sta _lo_nibble
    adc _hi_nibble
    ldy #3
    sta (_copy_mem_src),y
    rts


nextCheck6
    cmp #TRACKER_COL_INDEX_VOL_CH2
    bne done

    ldy #3
    lda (_copy_mem_src),y
    tax
    and #$0f
    sta _lo_nibble
    txa
    and #$f0
    lsr
    lsr 
    lsr
    lsr
    sta _hi_nibble
    clc
    cmp #0
    bne decrementVolChannel2
    jmp done

    decrementVolChannel2 // Add to oct value channel 1
    tax
    dex
    txa
    asl
    asl
    asl
    asl
    adc _lo_nibble
    ldy #3
    sta (_copy_mem_src),y
    rts


done
    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 




; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; printTrackerInstructions: 
;   Print some instructions in the status line at the top of the screen
; ------------------------------------------------------------------------------
printTrackerInstructions
    lda #<TrackerInstructions
    sta loadMessageLoop+1
    lda #>TrackerInstructions
    sta loadMessageLoop+2
    jsr printStatusMessage
    rts
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; printTrackerScreen: 
;   Display the tracker on the screen for the current selected bar
; ------------------------------------------------------------------------------
printTrackerScreen
.(    
    ldy #0
    sty _line_no
    loopy
    lda ScreenLineLookupLo,Y
    sta _copy_mem_dest_lo
    lda ScreenLineLookupHi,y
    sta _copy_mem_dest_hi
    lda trackerScreenDataLo,y
    sta _copy_mem_src_lo
    lda trackerScreenDataHi,Y
    sta _copy_mem_src_hi

    ldy #0
    loopx
    lda (_copy_mem_src),y
    sta (_copy_mem_dest),y
    iny
    cpy #40
    bne loopx
    ldy _line_no

    iny
    sty _line_no
    cpy #27
    bne loopy

    lda #04
    sta _tracker_screen_line
    lda #00
    sta _tracker_step_line
    
    :printMusicLoop
    jsr printTrackerLineData

    ldy _tracker_screen_line
    iny
    cpy #20
    beq screenPlotted
    inc _tracker_screen_line
    inc _tracker_step_line
    jmp printMusicLoop

    screenPlotted 
    // Highlight selected cell
    lda _tracker_selected_row_index
    adc #3
    tay 
    lda ScreenLineLookupLo,Y
    sta _copy_mem_dest_lo
    lda ScreenLineLookupHi,y
    sta _copy_mem_dest_hi
    ldy _tracker_selected_col_index
    lda trackerAttributeColumns,y
    tay
    lda #PAPER_WHITE
    sta (_copy_mem_dest),Y
    lda #PAPER_BLACK
    iny 
    iny 
    iny
    sta (_copy_mem_dest),Y
    
    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; printTrackerLineData: 
;   Display the tracker on the screen for a specific line
; ------------------------------------------------------------------------------
printTrackerLineData
.( 
    ldy _tracker_screen_line; plotting of bar data starts at line 4
    lda ScreenLineLookupLo,Y
    sta _copy_mem_dest_lo
    lda ScreenLineLookupHi,y
    sta _copy_mem_dest_hi


    ldy _tracker_step_line ; plotting of data for bar 1 starts at zero
    lda trackerMusicDataLo,Y
    sta _music_info_byte_lo
    lda trackerMusicDataHi,y
    sta _music_info_byte_hi

    // PRINT PART 1 INFO
    ldy #0 ; Load 1st byte of line
    lda (_music_info_byte_addr),y
    cmp #00
    bne printNote1Data

    // printEmptyNote1
    ldy #TRACKER_COL_NOTE_CH_1
    lda #ASCII_SPACE
    clearNoteLoop1
    sta (_copy_mem_dest),Y
    iny
    cpy #19
    bne clearNoteLoop1
    jmp processNote2Data


    printNote1Data
    tax ; make a copy of the value (the lower 4 bits will be used for note)
    ; get Part 1 Octave
    and #$F0
    lsr
    lsr
    lsr 
    lsr
    and #$0F
    sta _music_octave
    ;convert octave to digit and print on screen
    adc #48
    ldy #TRACKER_COL_OCT_CH_1
    sta (_copy_mem_dest),y

    ; get Part 1 Note
    txa
    and #$0F
    sta _music_note
    adc _music_note ;double the value to lookup string
    tax
    ; lookup string for note and display on screen
    lda notesToDisplay,x
    ldy #TRACKER_COL_NOTE_CH_1
    sta (_copy_mem_dest),Y
    inx
    lda notesToDisplay,x
    iny
    sta (_copy_mem_dest),Y
    
    
    ;get Second Music Info Byte
    ldy #01
    lda (_music_info_byte_addr),y ; 
    sta _music_data_temp ; make a copy of the value (the lower 4 bits will be used for volume)

    ;get Part 1 Vol
    and #$F0
    lsr
    lsr
    lsr 
    lsr
    and #$0f
    sta _music_vol
    adc _music_vol
    tax
    lda numbersToDisplay,x
    ldy #TRACKER_COL_VOL_CH_1
    sta (_copy_mem_dest),Y
    inx
    lda numbersToDisplay,x
    iny
    sta (_copy_mem_dest),Y

    ;get Part 1 Len
    lda _music_data_temp
    and #$0F
    sta _music_len
    adc _music_len
    tax
    lda numbersToDisplay,x
    ldy #TRACKER_COL_LEN_CH_1
    sta (_copy_mem_dest),Y
    inx
    lda numbersToDisplay,x
    iny
    sta (_copy_mem_dest),Y


    :processNote2Data
    // PRINT PART 2 INFO
    ldy #02 
    lda (_music_info_byte_addr),y
    cmp #00
    bne printNote2Data
    
    ldy #TRACKER_COL_NOTE_CH_2
    lda #ASCII_SPACE
    clearNoteLoop2
    sta (_copy_mem_dest),Y
    iny
    cpy #38
    bne clearNoteLoop2
    rts

    printNote2Data
    tax ; make a copy of the value (the lower 4 bits will be used for note)
    txa

    ; get Part 2 Octave
    and #$F0
    lsr
    lsr
    lsr 
    lsr
    and #$0F
    sta _music_octave
    ;convert octave to digit and print on screen
    adc #48
    ldy #TRACKER_COL_OCT_CH_2
    sta (_copy_mem_dest),y

    ; get Part 2 Note
    txa
    and #$0F
    sta _music_note
    adc _music_note ;double the value to lookup string
    tax
    ; lookup string for note and display on screen
    lda notesToDisplay,x
    ldy #TRACKER_COL_NOTE_CH_2
    sta (_copy_mem_dest),Y
    inx
    lda notesToDisplay,x
    iny
    sta (_copy_mem_dest),Y

    ldy #03
    ;get Second Music Info Byte
    lda (_music_info_byte_addr),y ; 
    sta _music_data_temp ; make a copy of the value (the lower 4 bits will be used for volume)

    ;get Part 2 Vol
    and #$F0
    lsr
    lsr
    lsr 
    lsr
    and #$0f
    sta _music_vol
    adc _music_vol
    tax
    lda numbersToDisplay,x
    ldy #TRACKER_COL_VOL_CH_2
    sta (_copy_mem_dest),Y
    inx
    lda numbersToDisplay,x
    iny
    sta (_copy_mem_dest),Y

    ;get Part 2 Len
    lda _music_data_temp
    and #$0F
    sta _music_len
    adc _music_len
    tax
    lda numbersToDisplay,x
    ldy #TRACKER_COL_LEN_CH_2
    sta (_copy_mem_dest),Y
    inx
    lda numbersToDisplay,x
    iny
    sta (_copy_mem_dest),Y

    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  




