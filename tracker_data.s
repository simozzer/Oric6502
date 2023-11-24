
notesToDisplay
.byt "   CC# DD# E FF# GG# AA# B"

numbersToDisplay
.byt " 0 1 2 3 4 5 6 7 8 910111213141516"


trackerScreenData
.byt PAPER_WHITE, INK_BLACK,  "  CHANNEL 1   CHANNEL 2   CHANNEL 3   "
.byt PAPER_WHITE, INK_BLACK,  " NOT OCT VOL NOT OCT VOL NOT OCT VOL  "
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
.byt PAPER_WHITE, INK_BLUE,   " Arrows to navigate. +/- Change value."
.byt PAPER_WHITE, INK_BLUE,   " Del to Delete. Q to Quit.            "
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
.byt $00,$00,$00,$00,$00,$00 // position 0
.byt $00,$00,$00,$00,$00,$00 // position 1
.byt $00,$00,$00,$00,$00,$00 // position 2
.byt $00,$00,$00,$00,$00,$00 // position 3
.byt $00,$00,$00,$00,$00,$00 // position 4
.byt $00,$00,$00,$00,$00,$00 // position 5
.byt $00,$00,$00,$00,$00,$00 // position 6
.byt $00,$00,$00,$00,$00,$00 // position 7
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 10
.byt $00,$00,$00,$00,$00,$00 // position 11
.byt $00,$00,$00,$00,$00,$00 // position 12
.byt $00,$00,$00,$00,$00,$00 // position 13
.byt $00,$00,$00,$00,$00,$00 // position 14
.byt $00,$00,$00,$00,$00,$00 // position 15
// bar 1
.byt $00,$00,$00,$00,$00,$00 // position 0
.byt $00,$00,$00,$00,$00,$00 // position 1
.byt $00,$00,$00,$00,$00,$00 // position 2
.byt $00,$00,$00,$00,$00,$00 // position 3
.byt $00,$00,$00,$00,$00,$00 // position 4
.byt $00,$00,$00,$00,$00,$00 // position 5
.byt $00,$00,$00,$00,$00,$00 // position 6
.byt $00,$00,$00,$00,$00,$00 // position 7
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 10
.byt $00,$00,$00,$00,$00,$00 // position 11
.byt $00,$00,$00,$00,$00,$00 // position 12
.byt $00,$00,$00,$00,$00,$00 // position 13
.byt $00,$00,$00,$00,$00,$00 // position 14
.byt $00,$00,$00,$00,$00,$00 // position 15
// bar 2

.byt $00,$00,$00,$00,$00,$00 // position 0
.byt $00,$00,$00,$00,$00,$00 // position 1
.byt $00,$00,$00,$00,$00,$00 // position 2
.byt $00,$00,$00,$00,$00,$00 // position 3
.byt $00,$00,$00,$00,$00,$00 // position 4
.byt $00,$00,$00,$00,$00,$00 // position 5
.byt $00,$00,$00,$00,$00,$00 // position 6
.byt $00,$00,$00,$00,$00,$00 // position 7
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 10
.byt $00,$00,$00,$00,$00,$00 // position 11
.byt $00,$00,$00,$00,$00,$00 // position 12
.byt $00,$00,$00,$00,$00,$00 // position 13
.byt $00,$00,$00,$00,$00,$00 // position 14
.byt $00,$00,$00,$00,$00,$00 // position 15
// bar 3
.byt $00,$00,$00,$00,$00,$00 // position 0
.byt $00,$00,$00,$00,$00,$00 // position 1
.byt $00,$00,$00,$00,$00,$00 // position 2
.byt $00,$00,$00,$00,$00,$00 // position 3
.byt $00,$00,$00,$00,$00,$00 // position 4
.byt $00,$00,$00,$00,$00,$00 // position 5
.byt $00,$00,$00,$00,$00,$00 // position 6
.byt $00,$00,$00,$00,$00,$00 // position 7
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 10
.byt $00,$00,$00,$00,$00,$00 // position 11
.byt $00,$00,$00,$00,$00,$00 // position 12
.byt $00,$00,$00,$00,$00,$00 // position 13
.byt $00,$00,$00,$00,$00,$00 // position 14
.byt $00,$00,$00,$00,$00,$00 // position 15

trackerMusicDataLo
    ;bar 0
    .byt <trackerMusicData+0,<trackerMusicData+6,<trackerMusicData+12,<trackerMusicData+18
    .byt <trackerMusicData+24,<trackerMusicData+30,<trackerMusicData+36,<trackerMusicData+42
    .byt <trackerMusicData+48,<trackerMusicData+54,<trackerMusicData+60,<trackerMusicData+66
    .byt <trackerMusicData+72,<trackerMusicData+78,<trackerMusicData+84,<trackerMusicData+90
    ;bar 1
    .byt <trackerMusicData+96,<trackerMusicData+102,<trackerMusicData+108,<trackerMusicData+114
    .byt <trackerMusicData+120,<trackerMusicData+126,<trackerMusicData+132,<trackerMusicData+138
    .byt <trackerMusicData+144,<trackerMusicData+150,<trackerMusicData+156,<trackerMusicData+162
    .byt <trackerMusicData+168,<trackerMusicData+174,<trackerMusicData+180,<trackerMusicData+186
    ;bar 2
    .byt <trackerMusicData+192,<trackerMusicData+198,<trackerMusicData+204,<trackerMusicData+210
    .byt <trackerMusicData+216,<trackerMusicData+222,<trackerMusicData+228,<trackerMusicData+234
    .byt <trackerMusicData+240,<trackerMusicData+246,<trackerMusicData+252,<trackerMusicData+258
    .byt <trackerMusicData+264,<trackerMusicData+270,<trackerMusicData+276,<trackerMusicData+282
    ;bar 3
    .byt <trackerMusicData+288,<trackerMusicData+294,<trackerMusicData+300,<trackerMusicData+306
    .byt <trackerMusicData+312,<trackerMusicData+318,<trackerMusicData+324,<trackerMusicData+330
    .byt <trackerMusicData+336,<trackerMusicData+342,<trackerMusicData+348,<trackerMusicData+354
    .byt <trackerMusicData+360,<trackerMusicData+366,<trackerMusicData+372,<trackerMusicData+378

trackerMusicDataHi
    ;bar 0
    .byt >trackerMusicData+0,>trackerMusicData+6,>trackerMusicData+12,>trackerMusicData+18
    .byt >trackerMusicData+24,>trackerMusicData+30,>trackerMusicData+36,>trackerMusicData+42
    .byt >trackerMusicData+48,>trackerMusicData+54,>trackerMusicData+60,>trackerMusicData+66
    .byt >trackerMusicData+72,>trackerMusicData+78,>trackerMusicData+84,>trackerMusicData+90
    ;bar 1
    .byt >trackerMusicData+96,>trackerMusicData+102,>trackerMusicData+108,>trackerMusicData+114
    .byt >trackerMusicData+120,>trackerMusicData+126,>trackerMusicData+132,>trackerMusicData+138
    .byt >trackerMusicData+144,>trackerMusicData+150,>trackerMusicData+156,>trackerMusicData+162
    .byt >trackerMusicData+168,>trackerMusicData+174,>trackerMusicData+180,>trackerMusicData+186
    ;bar 2
    .byt >trackerMusicData+192,>trackerMusicData+198,>trackerMusicData+204,>trackerMusicData+210
    .byt >trackerMusicData+216,>trackerMusicData+222,>trackerMusicData+228,>trackerMusicData+234
    .byt >trackerMusicData+240,>trackerMusicData+246,>trackerMusicData+252,>trackerMusicData+258
    .byt >trackerMusicData+264,>trackerMusicData+270,>trackerMusicData+276,>trackerMusicData+282
    ;bar 3
    .byt >trackerMusicData+288,>trackerMusicData+294,>trackerMusicData+300,>trackerMusicData+306
    .byt >trackerMusicData+312,>trackerMusicData+318,>trackerMusicData+324,>trackerMusicData+330
    .byt >trackerMusicData+336,>trackerMusicData+342,>trackerMusicData+348,>trackerMusicData+354
    .byt >trackerMusicData+360,>trackerMusicData+366,>trackerMusicData+372,>trackerMusicData+378


trackerAttributeColumns
.byt 3,7,10,14,18,21

trackerAttributeColWidth
.byt 3,2,3,3,2,3
