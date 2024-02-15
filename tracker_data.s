// 8 bars of music data (for 3 channels, each word uses the format described above)
trackerMusicData
.byt $25,$06,$00,$00,$01,$8B,$25,$86,$00,$00,$00,$00,$38,$05,$21,$07
.byt $76,$94,$38,$85,$00,$00,$00,$00,$00,$00,$00,$00,$02,$8B,$38,$05
.byt $00,$00,$00,$00,$38,$85,$21,$87,$76,$94,$00,$00,$00,$87,$00,$00
.byt $00,$00,$31,$86,$01,$8B,$45,$07,$00,$00,$00,$00,$00,$00,$21,$07
.byt $76,$94,$43,$07,$00,$00,$00,$00,$00,$00,$00,$00,$02,$8B,$31,$07
.byt $21,$07,$00,$10,$00,$07,$21,$87,$76,$D4,$21,$07,$00,$00,$00,$00
.byt $25,$06,$00,$00,$01,$8B,$25,$86,$00,$00,$00,$00,$48,$05,$23,$07
.byt $76,$94,$48,$85,$00,$00,$00,$00,$00,$00,$00,$00,$02,$8B,$45,$05
.byt $00,$00,$00,$00,$48,$85,$21,$87,$76,$94,$00,$00,$00,$87,$00,$00
.byt $00,$00,$31,$86,$01,$8B,$45,$07,$00,$00,$00,$10,$00,$00,$21,$07
.byt $76,$84,$43,$07,$00,$00,$00,$10,$00,$00,$00,$00,$02,$8B,$31,$07
.byt $21,$07,$00,$00,$00,$07,$21,$87,$76,$94,$21,$07,$00,$00,$00,$00
.byt $25,$06,$31,$87,$01,$8B,$25,$86,$21,$87,$00,$00,$38,$05,$00,$87
.byt $76,$94,$38,$85,$21,$07,$00,$00,$00,$00,$41,$07,$02,$8B,$38,$05
.byt $21,$87,$00,$10,$38,$85,$00,$87,$76,$84,$00,$00,$21,$07,$00,$10
.byt $00,$00,$31,$86,$01,$8B,$45,$07,$21,$07,$00,$00,$00,$00,$00,$87
.byt $76,$94,$43,$07,$21,$87,$00,$00,$00,$00,$21,$07,$02,$8B,$31,$07
.byt $21,$07,$00,$10,$00,$07,$00,$87,$76,$A4,$21,$07,$51,$07,$00,$10
.byt $25,$06,$00,$00,$01,$8B,$25,$86,$00,$00,$00,$00,$48,$05,$23,$87
.byt $76,$A4,$48,$85,$23,$07,$00,$00,$00,$00,$23,$87,$02,$8B,$45,$05
.byt $00,$00,$00,$00,$48,$85,$21,$87,$76,$A4,$00,$00,$00,$87,$00,$00
.byt $00,$00,$31,$86,$01,$8B,$45,$07,$00,$00,$00,$00,$00,$00,$21,$87
.byt $76,$A4,$43,$07,$21,$07,$00,$00,$00,$00,$00,$00,$02,$8B,$31,$07
.byt $21,$07,$00,$00,$00,$07,$21,$87,$76,$94,$21,$07,$21,$07,$00,$10
.byt $35,$06,$00,$00,$01,$BB,$35,$86,$00,$00,$00,$00,$48,$05,$21,$07
.byt $76,$84,$48,$85,$00,$00,$00,$00,$00,$00,$00,$00,$02,$BB,$48,$05
.byt $00,$00,$00,$00,$48,$85,$21,$87,$76,$84,$00,$00,$00,$87,$00,$00
.byt $00,$00,$31,$86,$01,$BB,$55,$07,$00,$00,$00,$00,$00,$00,$21,$07
.byt $76,$84,$53,$07,$00,$00,$00,$00,$00,$00,$00,$00,$02,$BB,$41,$07
.byt $21,$07,$00,$00,$00,$07,$21,$87,$76,$84,$31,$07,$00,$00,$00,$00
.byt $35,$06,$00,$00,$01,$CB,$35,$86,$00,$00,$00,$00,$58,$05,$23,$07
.byt $76,$94,$58,$85,$00,$00,$00,$00,$00,$00,$00,$00,$02,$CB,$55,$05
.byt $00,$00,$00,$00,$48,$85,$21,$87,$76,$94,$00,$00,$00,$87,$00,$00
.byt $00,$00,$31,$86,$01,$CB,$55,$07,$00,$00,$00,$00,$00,$00,$21,$07
.byt $76,$94,$53,$07,$00,$00,$00,$00,$00,$00,$00,$00,$02,$CB,$41,$07
.byt $21,$07,$00,$00,$00,$07,$21,$87,$76,$94,$31,$07,$00,$00,$00,$00
.byt $35,$06,$31,$87,$01,$8B,$35,$86,$21,$87,$00,$10,$48,$05,$21,$87
.byt $76,$A4,$48,$85,$21,$07,$00,$10,$00,$00,$41,$07,$02,$8B,$48,$05
.byt $21,$87,$00,$10,$48,$85,$11,$87,$76,$A4,$00,$00,$21,$07,$00,$90
.byt $00,$00,$31,$86,$01,$8B,$55,$07,$21,$07,$00,$10,$00,$00,$41,$87
.byt $76,$A4,$53,$07,$21,$87,$00,$10,$00,$00,$21,$07,$02,$8B,$41,$07
.byt $21,$07,$00,$10,$00,$07,$31,$87,$76,$A4,$31,$07,$51,$07,$00,$10
.byt $35,$06,$00,$00,$01,$8B,$35,$86,$00,$00,$00,$00,$58,$05,$23,$87
.byt $76,$84,$58,$85,$23,$07,$00,$00,$00,$00,$23,$87,$02,$8B,$55,$05
.byt $00,$00,$00,$00,$58,$85,$21,$87,$76,$84,$00,$00,$00,$87,$00,$00
.byt $00,$00,$31,$86,$01,$8B,$55,$07,$00,$00,$00,$00,$00,$00,$21,$87
.byt $76,$84,$53,$07,$21,$07,$00,$00,$00,$00,$00,$00,$02,$8B,$51,$07
.byt $21,$07,$00,$00,$00,$07,$21,$87,$76,$84,$41,$07,$21,$07,$00,$00

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


trackerBarStartLookup
.byt 0,16,32,48,64,80,96,112,128

soundParamCopyBuffer
.byt 00,00,00,00,00,00,00,00,00

barSequenceData
.byt 00,01,02,03,04,05,06,07,$ff

noisePitchLookup
.byt 4,8,12,16,20,24,28

noiseVolumeLookup
.byt 8,8,8,8,8,8,8



