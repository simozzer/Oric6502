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
// VOL (1-15 - volume level, 0 = use envelope from play) (4 bits)
// LENGTH (1-15) ( 4 bits)

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
    bne readAgain
    lda _tracker_selected_col_index
    cmp #01
    bmi readAgain
    dec _tracker_selected_col_index
    jmp refreshTrackerScreen



    rts
.)

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
    jsr printLineData

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

printLineData
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


notesToDisplay
.byt "   CC# DD# E FF# GG# AA# B"

numbersToDisplay
.byt "   1 2 3 4 5 6 7 8 910111213141516"


trackerScreenData
.byt PAPER_WHITE, INK_BLACK,  "    CHANNEL 1           CHANNEL 2     "
.byt PAPER_WHITE, INK_BLACK,  " NOTE OCT LEN VOL    NOTE OCT LEN VOL "
.byt PAPER_WHITE, INK_BLACK,  "++++++++++++++++++++++++++++++++++++++"
.byt PAPER_BLACK, INK_BLACK,  "                                      "
.byt PAPER_BLACK, INK_GREEN,  ">                                    <"
.byt PAPER_BLACK, INK_BLUE,   "|                                     "
.byt PAPER_BLACK, INK_BLUE,   "|                                     "
.byt PAPER_BLACK, INK_BLUE,   "|                                     "
.byt PAPER_BLACK, INK_GREEN,  ">                                    <"
.byt PAPER_BLACK, INK_BLUE,   "|                                     "
.byt PAPER_BLACK, INK_BLUE,   "|                                     "
.byt PAPER_BLACK, INK_BLUE,   "|                                     "
.byt PAPER_BLACK, INK_GREEN,  ">                                    <"
.byt PAPER_BLACK, INK_BLUE,   "|                                     "
.byt PAPER_BLACK, INK_BLUE,   "|                                     "
.byt PAPER_BLACK, INK_BLUE,   "|                                     "
.byt PAPER_BLACK, INK_GREEN,  ">                                    <"
.byt PAPER_BLACK, INK_BLUE,   "|                                     "
.byt PAPER_BLACK, INK_BLUE,   "|                                     "
.byt PAPER_BLACK, INK_BLUE,   "|                                     "
.byt PAPER_BLACK, INK_BLACK,  "                                      "
.byt PAPER_WHITE, INK_BLACK,  "++++++++++++++++++++++++++++++++++++++"
.byt PAPER_WHITE, INK_BLUE,   "  Press arrows to navigate, please.   "
.byt PAPER_WHITE, INK_BLUE,   "  Kindly use +/  to change a value.   "
.byt PAPER_WHITE, INK_BLUE,   " Respectfully click 'del' to delete.  "
.byt PAPER_WHITE, INK_BLUE,   "    Click on </> to change bar.       "
.byt PAPER_WHITE, INK_BLACK,  "                                      "

trackerScreenDataLo
    .byt <trackerScreenData + 0,<trackerScreenData + 40,<trackerScreenData + 80,<trackerScreenData + 120,<trackerScreenData + 160
    .byt <trackerScreenData + 200,<trackerScreenData + 240,<trackerScreenData + 280,<trackerScreenData + 320,<trackerScreenData + 360
    .byt <trackerScreenData + 400,<trackerScreenData + 440,<trackerScreenData + 480,<trackerScreenData + 520,<trackerScreenData + 560
    .byt <trackerScreenData + 600,<trackerScreenData + 640,<trackerScreenData + 680,<trackerScreenData + 720,<trackerScreenData + 760
    .byt <trackerScreenData + 800,<trackerScreenData + 840,<trackerScreenData + 880,<trackerScreenData + 920,<trackerScreenData + 960
    .byt <trackerScreenData + 1000,<trackerScreenData + 1040,<trackerScreenData + 1080


trackerScreenDataHi
    .byt >trackerScreenData + 0,>trackerScreenData + 40,>trackerScreenData + 80,>trackerScreenData + 120,>trackerScreenData + 160
    .byt >trackerScreenData + 200,>trackerScreenData + 240,>trackerScreenData + 280,>trackerScreenData + 320,>trackerScreenData + 360
    .byt >trackerScreenData + 400,>trackerScreenData + 440,>trackerScreenData + 480,>trackerScreenData + 520,>trackerScreenData + 560
    .byt >trackerScreenData + 600,>trackerScreenData + 640,>trackerScreenData + 680,>trackerScreenData + 720,>trackerScreenData + 760
    .byt >trackerScreenData + 800,>trackerScreenData + 840,>trackerScreenData + 880,>trackerScreenData + 920,>trackerScreenData + 960
    .byt >trackerScreenData + 1000,>trackerScreenData + 1040,>trackerScreenData + 1080


// 4 bars of music data (for 2 channels, each word uses the format described above)
trackerMusicData
;(oct/note)(vol/len)
// bar 0
.byt $11,$54,$23,$15 // position 0
.byt $00,$00,$00,$00 // position 1
.byt $00,$00,$00,$00 // position 2
.byt $00,$00,$00,$00 // position 3
.byt $22,$63,$34,$24 // position 4
.byt $00,$00,$00,$00 // position 5
.byt $00,$00,$00,$00 // position 6
.byt $00,$00,$00,$00 // position 7
.byt $33,$72,$45,$33 // position 8
.byt $00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00 // position 10
.byt $00,$00,$00,$00 // position 11
.byt $44,$81,$56,$42 // position 12
.byt $00,$00,$00,$00 // position 13
.byt $00,$00,$00,$00 // position 14
.byt $00,$00,$00,$00 // position 15
// bar 1
.byt $11,$15,$33,$15 // position 0
.byt $00,$00,$00,$00 // position 1
.byt $00,$00,$00,$00 // position 2
.byt $00,$00,$00,$00 // position 3
.byt $11,$15,$33,$15 // position 4
.byt $00,$00,$00,$00 // position 5
.byt $00,$00,$00,$00 // position 6
.byt $00,$00,$00,$00 // position 7
.byt $11,$15,$33,$15 // position 8
.byt $00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00 // position 10
.byt $00,$00,$00,$00 // position 11
.byt $11,$15,$33,$15 // position 12
.byt $00,$00,$00,$00 // position 13
.byt $00,$00,$00,$00 // position 14
.byt $00,$00,$00,$00 // position 15
// bar 2
.byt $11,$15,$33,$15 // position 0
.byt $00,$00,$00,$00 // position 1
.byt $00,$00,$00,$00 // position 2
.byt $00,$00,$00,$00 // position 3
.byt $11,$15,$33,$15 // position 4
.byt $00,$00,$00,$00 // position 5
.byt $00,$00,$00,$00 // position 6
.byt $00,$00,$00,$00 // position 7
.byt $11,$15,$33,$15 // position 8
.byt $00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00 // position 10
.byt $00,$00,$00,$00 // position 11
.byt $11,$15,$33,$15 // position 12
.byt $00,$00,$00,$00 // position 13
.byt $00,$00,$00,$00 // position 14
.byt $00,$00,$00,$00 // position 15
// bar 3
.byt $11,$15,$33,$15 // position 0
.byt $00,$00,$00,$00 // position 1
.byt $00,$00,$00,$00 // position 2
.byt $00,$00,$00,$00 // position 3
.byt $11,$15,$33,$15 // position 4
.byt $00,$00,$00,$00 // position 5
.byt $00,$00,$00,$00 // position 6
.byt $00,$00,$00,$00 // position 7
.byt $11,$15,$33,$15 // position 8
.byt $00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00 // position 10
.byt $00,$00,$00,$00 // position 11
.byt $11,$15,$33,$15 // position 12
.byt $00,$00,$00,$00 // position 13
.byt $00,$00,$00,$00 // position 14
.byt $00,$00,$00,$00 // position 15

trackerMusicDataLo
    ;bar 0
    .byt <trackerMusicData + 0,<trackerMusicData + 4,<trackerMusicData + 8,<trackerMusicData + 12
    .byt <trackerMusicData + 16,<trackerMusicData + 20,<trackerMusicData + 24,<trackerMusicData + 28
    .byt <trackerMusicData + 32,<trackerMusicData + 36,<trackerMusicData + 40,<trackerMusicData + 44
    .byt <trackerMusicData + 48,<trackerMusicData + 52,<trackerMusicData + 56,<trackerMusicData + 60
    ;bar 1    
    .byt <trackerMusicData + 64,<trackerMusicData + 68,<trackerMusicData + 72,<trackerMusicData + 76
    .byt <trackerMusicData + 80,<trackerMusicData + 84,<trackerMusicData + 88,<trackerMusicData + 92
    .byt <trackerMusicData + 96,<trackerMusicData + 100,<trackerMusicData + 104,<trackerMusicData + 108
    .byt <trackerMusicData + 112,<trackerMusicData + 116,<trackerMusicData + 120,<trackerMusicData + 124
    ;bar 2    
    .byt <trackerMusicData + 128,<trackerMusicData + 132,<trackerMusicData + 136,<trackerMusicData + 140
    .byt <trackerMusicData + 144,<trackerMusicData + 148,<trackerMusicData + 152,<trackerMusicData + 156
    .byt <trackerMusicData + 160,<trackerMusicData + 164,<trackerMusicData + 168,<trackerMusicData + 172
    .byt <trackerMusicData + 176,<trackerMusicData + 180,<trackerMusicData + 184,<trackerMusicData + 188    
    ;bar 3
    .byt <trackerMusicData + 192,<trackerMusicData + 196,<trackerMusicData + 200,<trackerMusicData + 204
    .byt <trackerMusicData + 208,<trackerMusicData + 212,<trackerMusicData + 216,<trackerMusicData + 220
    .byt <trackerMusicData + 224,<trackerMusicData + 228,<trackerMusicData + 232,<trackerMusicData + 236
    .byt <trackerMusicData + 240,<trackerMusicData + 244,<trackerMusicData + 248,<trackerMusicData + 252

trackerMusicDataHi
    ;bar 0
    .byt >trackerMusicData + 0,>trackerMusicData + 4,>trackerMusicData + 8,>trackerMusicData + 12
    .byt >trackerMusicData + 16,>trackerMusicData + 20,>trackerMusicData + 24,>trackerMusicData + 28
    .byt >trackerMusicData + 32,>trackerMusicData + 36,>trackerMusicData + 40,>trackerMusicData + 44
    .byt >trackerMusicData + 48,>trackerMusicData + 52,>trackerMusicData + 56,>trackerMusicData + 60
    ;bar 1    
    .byt >trackerMusicData + 64,>trackerMusicData + 68,>trackerMusicData + 72,>trackerMusicData + 76
    .byt >trackerMusicData + 80,>trackerMusicData + 84,>trackerMusicData + 88,>trackerMusicData + 92
    .byt >trackerMusicData + 96,>trackerMusicData + 100,>trackerMusicData + 104,>trackerMusicData + 108
    .byt >trackerMusicData + 112,>trackerMusicData + 116,>trackerMusicData + 120,>trackerMusicData + 124
    ;bar 2    
    .byt >trackerMusicData + 128,>trackerMusicData + 132,>trackerMusicData + 136,>trackerMusicData + 140
    .byt >trackerMusicData + 144,>trackerMusicData + 148,>trackerMusicData + 152,>trackerMusicData + 156
    .byt >trackerMusicData + 160,>trackerMusicData + 164,>trackerMusicData + 168,>trackerMusicData + 172
    .byt >trackerMusicData + 176,>trackerMusicData + 180,>trackerMusicData + 184,>trackerMusicData + 188    
    ;bar 3
    .byt >trackerMusicData + 192,>trackerMusicData + 196,>trackerMusicData + 200,>trackerMusicData + 204
    .byt >trackerMusicData + 208,>trackerMusicData + 212,>trackerMusicData + 216,>trackerMusicData + 220
    .byt >trackerMusicData + 224,>trackerMusicData + 228,>trackerMusicData + 232,>trackerMusicData + 236
    .byt >trackerMusicData + 240,>trackerMusicData + 244,>trackerMusicData + 248,>trackerMusicData + 252


trackerAttributeColumns
.byt 4,9,12,16,23,28,32,35



