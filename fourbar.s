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
// OCTAVE 0-7 (3 bits, but will use 4),
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
;rts
.)
jmp printTrackerScreen


trackerScreenData
.byt PAPER_WHITE, INK_BLACK,  "    CHANNEL 1           CHANNEL 2     "
.byt PAPER_WHITE, INK_BLACK,  " NOTE OCT LEN VOL    NOTE OCT LEN VOL "
.byt PAPER_WHITE, INK_BLACK,  "++++++++++++++++++++++++++++++++++++++"
.byt PAPER_BLACK, INK_BLACK,  "                                      "
.byt PAPER_BLACK, INK_GREEN,  ">  --   -  --  --      --   -  --  --<"
.byt PAPER_BLACK, INK_BLUE,   "|  --   -  --  --      --   -  --  -- "
.byt PAPER_BLACK, INK_BLUE,   "|  --   -  --  --      --   -  --  -- "
.byt PAPER_BLACK, INK_BLUE,   "|  --   -  --  --      --   -  --  -- "
.byt PAPER_BLACK, INK_GREEN,  ">  --   -  --  --      --   -  --  --<"
.byt PAPER_BLACK, INK_BLUE,   "|  --   -  --  --      --   -  --  -- "
.byt PAPER_BLACK, INK_BLUE,   "|  --   -  --  --      --   -  --  -- "
.byt PAPER_BLACK, INK_BLUE,   "|  --   -  --  --      --   -  --  -- "
.byt PAPER_BLACK, INK_GREEN,  ">  --   -  --  --      --   -  --  --<"
.byt PAPER_BLACK, INK_BLUE,   "|  --   -  --  --      --   -  --  -- "
.byt PAPER_BLACK, INK_BLUE,   "|  --   -  --  --      --   -  --  -- "
.byt PAPER_BLACK, INK_BLUE,   "|  --   -  --  --      --   -  --  -- "
.byt PAPER_BLACK, INK_GREEN,  ">  --   -  --  --      --   -  --  --<"
.byt PAPER_BLACK, INK_BLUE,   "|  --   -  --  --      --   -  --  -- "
.byt PAPER_BLACK, INK_BLUE,   "|  --   -  --  --      --   -  --  -- "
.byt PAPER_BLACK, INK_BLUE,   "|  --   -  --  --      --   -  --  -- "
.byt PAPER_BLACK, INK_BLACK,  "                                      "
.byt PAPER_WHITE, INK_BLACK,  "++++++++++++++++++++++++++++++++++++++"
.byt PAPER_WHITE, INK_BLUE,   "  Press arrows to navigate, please.   "
.byt PAPER_WHITE, INK_BLUE,   "  Kindly use +/- to change a value.   "
.byt PAPER_WHITE, INK_BLUE,   " Respectfully click 'del' to delete.  "
.byt PAPER_WHITE, INK_BLUE,   "    Click on </> to change bar.       "
.byt PAPER_WHITE, INK_BLACK,  "--------------------------------------"

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
// bar 0
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

