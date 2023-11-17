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

trackerScreenData
.byt "    CHANNEL 1          CHANNEL 2",0
.byt " NOTE OCT LEN VOL   NOTE OCT LEN VOL",0
.byt "-------------------------------------",0
.byt ">----|---|---|---| |----|---|---|---<",0
.byt "|----|---|---|---| |----|---|---|---|",0
.byt "|----|---|---|---| |----|---|---|---|",0
.byt "|----|---|---|---| |----|---|---|---|",0
.byt ">----|---|---|---| |----|---|---|---<",0
.byt "|----|---|---|---| |----|---|---|---|",0
.byt "|----|---|---|---| |----|---|---|---|",0
.byt "|----|---|---|---| |----|---|---|---|",0
.byt ">----|---|---|---| |----|---|---|---<",0
.byt "|----|---|---|---| |----|---|---|---|",0
.byt "|----|---|---|---| |----|---|---|---|",0
.byt "|----|---|---|---| |----|---|---|---|",0
.byt ">----|---|---|---| |----|---|---|---<",0
.byt "|----|---|---|---| |----|---|---|---|",0
.byt "|----|---|---|---| |----|---|---|---|",0
.byt "|----|---|---|---| |----|---|---|---|",0
.byt "-------------------------------------",0
.byt "Arrows to navigate.",0
.byt "1+/- to change value.",0
.byt "</> to change bar.",0
*/

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

