; // DATA FOR MAZE .. currently only an empty area with walls on each edge
; // (and some test data on row 1)
; // Each BIT which is set will be a block of the wall
; // Each row is 31 bytes long - allowing for 248 sections of wall for each row

;// TODO:: Only currently have 31 rows of data, need to expand this and the lookup tables
:MazeData1
.byt $Fe,$Fc,$F8,$F0,$e0,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byt $01,$03,$07,$0f,$1f,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $fc,$f8,$f0,$e0,$c0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $03,$07,$0f,$1f,$3f,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $f8,$f0,$e0,$c0,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $07,$0f,$1f,$3f,$7f,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $bf,$a0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
.byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

:mazeRowLookupTableLo
    .byt <MazeData1,<MazeData1+31,<MazeData1+62,<MazeData1+93,<MazeData1+124,<MazeData1+155,<MazeData1+186
    .byt <MazeData1+217,<MazeData1+248,<MazeData1+279,<MazeData1+310,<MazeData1+341,<MazeData1+372,<MazeData1+403
    .byt <MazeData1+434,<MazeData1+465,<MazeData1+496,<MazeData1+527,<MazeData1+558,<MazeData1+589,<MazeData1+620
    .byt <MazeData1+651,<MazeData1+682,<MazeData1+713,<MazeData1+744,<MazeData1+775,<MazeData1+806,<MazeData1+837
    .byt <MazeData1+868,<MazeData1+899,<MazeData1+930,<MazeData1+961,<MazeData1+992

:mazeRowLookupTableHi
    .byt >MazeData1,>MazeData1+31,>MazeData1+62,>MazeData1+93,>MazeData1+124,>MazeData1+155,>MazeData1+186
    .byt >MazeData1+217,>MazeData1+248,>MazeData1+279,>MazeData1+310,>MazeData1+341,>MazeData1+372,>MazeData1+403
    .byt >MazeData1+434,>MazeData1+465,>MazeData1+496,>MazeData1+527,>MazeData1+558,>MazeData1+589,>MazeData1+620
    .byt >MazeData1+651,>MazeData1+682,>MazeData1+713,>MazeData1+744,>MazeData1+775,>MazeData1+806,>MazeData1+837
    .byt >MazeData1+868,>MazeData1+899,>MazeData1+930,>MazeData1+961,>MazeData1+992 

:divideBy8Table
    .byt 0,0,0,0,0,0,0,0
    .byt 1,1,1,1,1,1,1,1
    .byt 2,2,2,2,2,2,2,2
    .byt 3,3,3,3,3,3,3,3
    .byt 4,4,4,4,4,4,4,4
    .byt 5,5,5,5,5,5,5,5
    .byt 6,6,6,6,6,6,6,6
    .byt 7,7,7,7,7,7,7,7
    .byt 8,8,8,8,8,8,8,8
    .byt 9,9,9,9,9,9,9,9
    .byt 10,10,10,10,10,10,10,10
    .byt 11,11,11,11,11,11,11,11
    .byt 12,12,12,12,12,12,12,12
    .byt 13,13,13,13,13,13,13,13
    .byt 14,14,14,14,14,14,14,14
    .byt 15,15,15,15,15,15,15,15
    .byt 16,16,16,16,16,16,16,16
    .byt 17,17,17,17,17,17,17,17
    .byt 18,18,18,18,18,18,18,18
    .byt 19,19,19,19,19,19,19,19
    .byt 20,20,20,20,20,20,20,20
    .byt 21,21,21,21,21,21,21,21
    .byt 22,22,22,22,22,22,22,22
    .byt 23,23,23,23,23,23,23,23
    .byt 24,24,24,24,24,24,24,24
    .byt 25,25,25,25,25,25,25,25
    .byt 26,26,26,26,26,26,26,26
    .byt 27,27,27,27,27,27,27,27
    .byt 28,28,28,28,28,28,28,28
    .byt 29,29,29,29,29,29,29,29
    .byt 30,30,30,30,30,30,30,30
    .byt 31,31,31,31,31,31,31,31

:mod8Table
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7
    .byt 0,1,2,3,4,5,6,7


:reverseBitmaskTable
    .byt %10000000
    .byt %01000000
    .byt %00100000
    .byt %00010000
    .byt %00001000
    .byt %00000100
    .byt %00000010
    .byt %00000001




