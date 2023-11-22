
notesToDisplay
.byt "   CC# DD# E FF# GG# AA# B"

numbersToDisplay
.byt " 0 1 2 3 4 5 6 7 8 910111213141516"


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
.byt 4,8,12,16,23,27,31,35
