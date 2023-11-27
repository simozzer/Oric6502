
notesToDisplay
.byt "   CC# DD# E FF# GG# AA# B"

numbersToDisplay
.byt " 0 1 2 3 4 5 6 7 8 910111213141516"


trackerScreenData
.byt PAPER_WHITE, INK_BLACK,  "     CH1         CH2         CH3      "
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
.byt PAPER_WHITE, INK_BLUE,   " Del Delete. Q Quit. C copy, V Paste. "
.byt PAPER_WHITE, INK_BLUE,   " Speed: 5 slower, 6 faster.           "
.byt PAPER_WHITE, INK_BLUE,   " Select Bar: 1,2,3,4                  "
.byt PAPER_WHITE, INK_BLACK,  " Toggle song/pattern: B               "

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


// 4 bars of music data (for 3 channels, each word uses the format described above)
trackerMusicData
;(oct/note)(vol/len)
// bar 0
.byt $21,$08,$3A,$08,$35,$08 // position 0
.byt $00,$00,$00,$00,$00,$00 // position 1
.byt $00,$00,$00,$00,$00,$00 // position 2
.byt $21,$06,$3A,$06,$35,$06 // position 3
.byt $00,$00,$00,$00,$00,$00 // position 4
.byt $00,$00,$00,$00,$00,$00 // position 5
.byt $21,$04,$3A,$04,$35,$04 // position 6
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
.byt $33,$08,$35,$08,$3a,$08 // position 0
.byt $00,$00,$00,$00,$00,$00 // position 1
.byt $00,$00,$00,$00,$00,$00 // position 2
.byt $33,$06,$35,$06,$3a,$06 // position 3
.byt $00,$00,$00,$00,$00,$00 // position 4
.byt $00,$00,$00,$00,$00,$00 // position 5
.byt $33,$04,$35,$04,$3a,$04 // position 6
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
.byt $21,$08,$3A,$08,$35,$08 // position 0
.byt $00,$00,$00,$00,$00,$00 // position 1
.byt $00,$00,$00,$00,$00,$00 // position 2
.byt $21,$06,$3A,$06,$35,$06 // position 3
.byt $00,$00,$00,$00,$00,$00 // position 4
.byt $00,$00,$00,$00,$00,$00 // position 5
.byt $21,$04,$3A,$04,$35,$04 // position 6
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
.byt $33,$08,$35,$08,$3a,$08 // position 0
.byt $00,$00,$00,$00,$00,$00 // position 1
.byt $00,$00,$00,$00,$00,$00 // position 2
.byt $33,$06,$35,$06,$3a,$06 // position 0
.byt $00,$00,$00,$00,$00,$00 // position 4
.byt $00,$00,$00,$00,$00,$00 // position 5
.byt $33,$04,$35,$04,$3a,$04 // position 0
.byt $00,$00,$00,$00,$00,$00 // position 7
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 10
.byt $00,$00,$00,$00,$00,$00 // position 11
.byt $00,$00,$00,$00,$00,$00 // position 12
.byt $00,$00,$00,$00,$00,$00 // position 13
.byt $00,$00,$00,$00,$00,$00 // position 14
.byt $00,$00,$00,$00,$00,$00 // position 15
// bar 4
.byt $21,$08,$3A,$08,$35,$08 // position 0
.byt $00,$00,$00,$00,$00,$00 // position 1
.byt $00,$00,$00,$00,$00,$00 // position 2
.byt $21,$06,$3A,$06,$35,$06 // position 3
.byt $00,$00,$00,$00,$00,$00 // position 4
.byt $00,$00,$00,$00,$00,$00 // position 5
.byt $21,$04,$3A,$04,$35,$04 // position 6
.byt $00,$00,$00,$00,$00,$00 // position 7
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 10
.byt $00,$00,$00,$00,$00,$00 // position 11
.byt $00,$00,$00,$00,$00,$00 // position 12
.byt $00,$00,$00,$00,$00,$00 // position 13
.byt $00,$00,$00,$00,$00,$00 // position 14
.byt $00,$00,$00,$00,$00,$00 // position 15
// bar 5
.byt $33,$08,$35,$08,$3a,$08 // position 0
.byt $00,$00,$00,$00,$00,$00 // position 1
.byt $00,$00,$00,$00,$00,$00 // position 2
.byt $33,$06,$35,$06,$3a,$06 // position 3
.byt $00,$00,$00,$00,$00,$00 // position 4
.byt $00,$00,$00,$00,$00,$00 // position 5
.byt $33,$04,$35,$04,$3a,$04 // position 6
.byt $00,$00,$00,$00,$00,$00 // position 7
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 10
.byt $00,$00,$00,$00,$00,$00 // position 11
.byt $00,$00,$00,$00,$00,$00 // position 12
.byt $00,$00,$00,$00,$00,$00 // position 13
.byt $00,$00,$00,$00,$00,$00 // position 14
.byt $00,$00,$00,$00,$00,$00 // position 15
// bar 6
.byt $21,$08,$3A,$08,$35,$08 // position 0
.byt $00,$00,$00,$00,$00,$00 // position 1
.byt $00,$00,$00,$00,$00,$00 // position 2
.byt $21,$06,$3A,$06,$35,$06 // position 3
.byt $00,$00,$00,$00,$00,$00 // position 4
.byt $00,$00,$00,$00,$00,$00 // position 5
.byt $21,$04,$3A,$04,$35,$04 // position 6
.byt $00,$00,$00,$00,$00,$00 // position 7
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 10
.byt $00,$00,$00,$00,$00,$00 // position 11
.byt $00,$00,$00,$00,$00,$00 // position 12
.byt $00,$00,$00,$00,$00,$00 // position 13
.byt $00,$00,$00,$00,$00,$00 // position 14
.byt $00,$00,$00,$00,$00,$00 // position 15
// bar 7
.byt $33,$08,$35,$08,$3a,$08 // position 0
.byt $00,$00,$00,$00,$00,$00 // position 1
.byt $00,$00,$00,$00,$00,$00 // position 2
.byt $33,$06,$35,$06,$3a,$06 // position 0
.byt $00,$00,$00,$00,$00,$00 // position 4
.byt $00,$00,$00,$00,$00,$00 // position 5
.byt $33,$04,$35,$04,$3a,$04 // position 0
.byt $00,$00,$00,$00,$00,$00 // position 7
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 9
.byt $00,$00,$00,$00,$00,$00 // position 10
.byt $00,$00,$00,$00,$00,$00 // position 11
.byt $00,$00,$00,$00,$00,$00 // position 12
.byt $00,$00,$00,$00,$00,$00 // position 13
.byt $00,$00,$00,$00,$00,$00 // position 14
.byt $00,$00,$00,$00,$00,$00 // position 15

trackerCopyBuffer
.byt $00,$00,$00,$00,$00,$00

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
    ;bar 4
    .byt <trackerMusicData+384,<trackerMusicData+390,<trackerMusicData+396,<trackerMusicData+402
    .byt <trackerMusicData+408,<trackerMusicData+414,<trackerMusicData+420,<trackerMusicData+426
    .byt <trackerMusicData+432,<trackerMusicData+438,<trackerMusicData+444,<trackerMusicData+450
    .byt <trackerMusicData+456,<trackerMusicData+462,<trackerMusicData+468,<trackerMusicData+474
    ;bar 5
    .byt <trackerMusicData+480,<trackerMusicData+486,<trackerMusicData+492,<trackerMusicData+498
    .byt <trackerMusicData+504,<trackerMusicData+510,<trackerMusicData+516,<trackerMusicData+522
    .byt <trackerMusicData+528,<trackerMusicData+534,<trackerMusicData+540,<trackerMusicData+546
    .byt <trackerMusicData+552,<trackerMusicData+558,<trackerMusicData+564,<trackerMusicData+570
    ;bar 6
    .byt <trackerMusicData+576,<trackerMusicData+582,<trackerMusicData+588,<trackerMusicData+594
    .byt <trackerMusicData+600,<trackerMusicData+606,<trackerMusicData+612,<trackerMusicData+618
    .byt <trackerMusicData+624,<trackerMusicData+630,<trackerMusicData+636,<trackerMusicData+642
    .byt <trackerMusicData+648,<trackerMusicData+654,<trackerMusicData+660,<trackerMusicData+666
    ;bar 7
    .byt <trackerMusicData+672,<trackerMusicData+678,<trackerMusicData+684,<trackerMusicData+690
    .byt <trackerMusicData+696,<trackerMusicData+702,<trackerMusicData+708,<trackerMusicData+714
    .byt <trackerMusicData+720,<trackerMusicData+726,<trackerMusicData+732,<trackerMusicData+738
    .byt <trackerMusicData+744,<trackerMusicData+750,<trackerMusicData+756,<trackerMusicData+762

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
    ;bar 4
    .byt >trackerMusicData+384,>trackerMusicData+390,>trackerMusicData+396,>trackerMusicData+402
    .byt >trackerMusicData+408,>trackerMusicData+414,>trackerMusicData+420,>trackerMusicData+426
    .byt >trackerMusicData+432,>trackerMusicData+438,>trackerMusicData+444,>trackerMusicData+450
    .byt >trackerMusicData+456,>trackerMusicData+462,>trackerMusicData+468,>trackerMusicData+474
    ;bar 5
    .byt >trackerMusicData+480,>trackerMusicData+486,>trackerMusicData+492,>trackerMusicData+498
    .byt >trackerMusicData+504,>trackerMusicData+510,>trackerMusicData+516,>trackerMusicData+522
    .byt >trackerMusicData+528,>trackerMusicData+534,>trackerMusicData+540,>trackerMusicData+546
    .byt >trackerMusicData+552,>trackerMusicData+558,>trackerMusicData+564,>trackerMusicData+570
    ;bar 6
    .byt >trackerMusicData+576,>trackerMusicData+582,>trackerMusicData+588,>trackerMusicData+594
    .byt >trackerMusicData+600,>trackerMusicData+606,>trackerMusicData+612,>trackerMusicData+618
    .byt >trackerMusicData+624,>trackerMusicData+630,>trackerMusicData+636,>trackerMusicData+642
    .byt >trackerMusicData+648,>trackerMusicData+654,>trackerMusicData+660,>trackerMusicData+666
    ;bar 7
    .byt >trackerMusicData+672,>trackerMusicData+678,>trackerMusicData+684,>trackerMusicData+690
    .byt >trackerMusicData+696,>trackerMusicData+702,>trackerMusicData+708,>trackerMusicData+714
    .byt >trackerMusicData+720,>trackerMusicData+726,>trackerMusicData+732,>trackerMusicData+738
    .byt >trackerMusicData+744,>trackerMusicData+750,>trackerMusicData+756,>trackerMusicData+762    


trackerAttributeColumns
.byt 3,7,10,15,19,22,27,31,34

trackerAttributeColWidth
.byt 3,2,3,3,2,3
