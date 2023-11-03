; // DATA FOR MAZE .. currently only an empty area with walls on each edge
; // (and some test data on row 1)
; // Each BIT which is set will be a block of the wall
; // Each row is 31 bytes long - allowing for 248 sections of wall for each row (with 80 rows we will use 20400 bytes to store
; the expanded maze, 255 bytes per row)

;// currently have 80 rows of data, (need to expand the lookup tables in further rows added)
:MazeData1
.byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.byt $80,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
.byt $BF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$20,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$1F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD
.byt $A0,$80,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05
.byt $AF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$E0,$10,$01,$00,$10,$00,$00,$08,$40,$80,$00,$00,$07,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F5
.byt $A8,$00,$10,$00,$00,$00,$00,$00,$00,$00,$08,$00,$80,$48,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15
.byt $AB,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$40,$08,$20,$00,$00,$00,$80,$00,$00,$00,$01,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$D5
.byt $AA,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$22,$04,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55
.byt $AA,$FF,$7F,$DF,$EB,$FF,$FF,$BF,$FE,$00,$00,$01,$00,$00,$00,$12,$00,$00,$01,$00,$02,$80,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$55
.byt $AA,$80,$40,$10,$08,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$09,$18,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$55
.byt $AA,$FF,$FF,$FF,$FF,$FB,$FF,$FF,$F9,$00,$20,$00,$00,$00,$40,$00,$14,$00,$00,$08,$00,$00,$1F,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$55
.byt $AA,$A0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$08,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$55
.byt $AA,$AB,$FF,$FF,$FF,$FB,$FF,$FF,$F0,$00,$10,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$07,$FF,$FF,$FF,$FF,$FF,$FF,$F5,$55
.byt $AA,$AA,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$55
.byt $AA,$AB,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$20,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$01,$FF,$FF,$FF,$FF,$FF,$FF,$D5,$55
.byt $AA,$AA,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55
.byt $AA,$AA,$7F,$FF,$FF,$FF,$FF,$FE,$00,$00,$00,$00,$80,$20,$00,$00,$00,$02,$00,$00,$00,$00,$00,$7F,$FF,$FF,$FF,$FF,$FF,$55,$55
.byt $AA,$AA,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$55,$55
.byt $AA,$AA,$BF,$FF,$FF,$FF,$FF,$F9,$10,$00,$00,$00,$40,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$1F,$FF,$FF,$FF,$FF,$FD,$55,$55
.byt $A2,$AA,$A0,$00,$00,$C0,$00,$01,$80,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$55,$55
.byt $AE,$AA,$EF,$DF,$FF,$BF,$FF,$E0,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$FF,$FF,$FF,$FF,$F5,$55,$55
.byt $AA,$AA,$A8,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$55,$55
.byt $AA,$AA,$AB,$FF,$FF,$FF,$FF,$81,$00,$04,$00,$00,$00,$20,$00,$00,$10,$00,$00,$00,$00,$00,$00,$01,$FF,$FF,$FF,$FF,$D5,$55,$55
.byt $AA,$AA,$AA,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55,$55
.byt $AA,$AA,$AA,$FE,$FF,$FF,$FE,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$7F,$FF,$FF,$FF,$55,$55,$55
.byt $AA,$AA,$AA,$80,$00,$00,$00,$00,$10,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$55,$55,$55
.byt $AA,$AA,$AA,$BF,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$FF,$FF,$FD,$55,$55,$55
.byt $AA,$AA,$AA,$A0,$00,$00,$00,$04,$00,$00,$00,$20,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$55,$55,$55
.byt $AA,$AA,$AA,$AF,$FF,$FF,$E0,$02,$00,$20,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$07,$FF,$FF,$F5,$55,$55,$55
.byt $AA,$AA,$AA,$A8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$55,$55,$55
.byt $AA,$AA,$AA,$AB,$FF,$FF,$80,$10,$00,$04,$00,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$FF,$FF,$D5,$55,$55,$55
.byt $AA,$BA,$AA,$AA,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55,$55,$55
.byt $AA,$AA,$AA,$AA,$FF,$FE,$00,$3C,$00,$00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$7F,$FF,$55,$55,$55,$55
.byt $AA,$AA,$AA,$AA,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$55,$55,$55,$55
.byt $AA,$AA,$AA,$AA,$BF,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$FD,$55,$55,$55,$55
.byt $AA,$AA,$AA,$AA,$A0,$00,$02,$08,$40,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$55,$55,$55,$55
.byt $AA,$A8,$AA,$AA,$AF,$E0,$00,$01,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$F5,$55,$55,$55,$55
.byt $AA,$AB,$AA,$AA,$A8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$55,$55,$55,$55
.byt $AA,$AA,$AA,$AA,$AB,$80,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$D5,$55,$55,$55,$55
.byt $AA,$AA,$AA,$AA,$AA,$04,$08,$04,$0A,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55,$55,$55,$55
.byt $AA,$AA,$AA,$AA,$AA,$00,$00,$02,$00,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55,$55,$55,$55
.byt $AA,$AA,$AA,$AA,$AB,$90,$00,$88,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$D5,$55,$55,$55,$55
.byt $AA,$AA,$AA,$AA,$A8,$00,$08,$08,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$55,$55,$55,$55
.byt $AA,$AA,$AA,$AA,$AF,$E0,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$F5,$55,$55,$55,$55
.byt $AA,$AA,$AA,$AA,$A0,$00,$00,$88,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$55,$55,$55,$55
.byt $AA,$AA,$AA,$AA,$BF,$F8,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$FD,$55,$55,$55,$55
.byt $AA,$AA,$AA,$AA,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$55,$55,$55,$55
.byt $AA,$AA,$AA,$AA,$FF,$FE,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$7F,$FF,$55,$55,$55,$55
.byt $AA,$AA,$AA,$AA,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55,$55,$55
.byt $AA,$AA,$A2,$AB,$FF,$FF,$80,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$FF,$FF,$D5,$55,$55,$55
.byt $AA,$AA,$AA,$A8,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$55,$55,$55
.byt $AA,$AA,$AA,$AF,$FF,$FF,$E0,$08,$00,$00,$01,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$FF,$FF,$F5,$55,$55,$55
.byt $AA,$AA,$AA,$A0,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$55,$55,$55
.byt $AA,$AA,$AA,$BF,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$FF,$FF,$FD,$55,$55,$55
.byt $AA,$AA,$AA,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$55,$55,$55
.byt $AA,$AA,$AA,$FF,$FF,$FF,$FE,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$7F,$FF,$FF,$FF,$55,$55,$55
.byt $AA,$AA,$AA,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55,$55
.byt $AA,$AA,$AB,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$FF,$FF,$FF,$FF,$D5,$55,$55
.byt $AA,$AA,$A8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$55,$55
.byt $AA,$AA,$AF,$FF,$FF,$FF,$FF,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$FF,$FF,$FF,$FF,$F5,$55,$55
.byt $AA,$AA,$A0,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$55,$55
.byt $AA,$AA,$BF,$FF,$FF,$FF,$7F,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$FF,$FF,$FF,$FF,$FD,$55,$55
.byt $AA,$AA,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$55,$55
.byt $AA,$AA,$FF,$FD,$FF,$FF,$FF,$FE,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$7F,$FF,$FF,$FF,$FF,$FF,$55,$55
.byt $AA,$AA,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55
.byt $AA,$AB,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$FF,$FF,$FF,$FF,$FF,$FF,$D5,$55
.byt $AA,$A8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$55
.byt $AA,$AF,$FF,$FF,$FF,$FF,$FF,$FF,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$07,$FF,$FF,$FF,$FF,$FF,$FF,$F5,$55
.byt $AA,$A0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$55
.byt $AA,$BF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$55
.byt $AA,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$55
.byt $AA,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$55
.byt $AA,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55
.byt $AB,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$D5
.byt $A8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15
.byt $AF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F5
.byt $A0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05
.byt $BF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD
.byt $80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
.byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
:mazeRowLookupTableLo
    .byt <MazeData1,<MazeData1+31,<MazeData1+62,<MazeData1+93,<MazeData1+124,<MazeData1+155,<MazeData1+186
    .byt <MazeData1+217,<MazeData1+248,<MazeData1+279,<MazeData1+310,<MazeData1+341,<MazeData1+372,<MazeData1+403
    .byt <MazeData1+434,<MazeData1+465,<MazeData1+496,<MazeData1+527,<MazeData1+558,<MazeData1+589,<MazeData1+620
    .byt <MazeData1+651,<MazeData1+682,<MazeData1+713,<MazeData1+744,<MazeData1+775,<MazeData1+806,<MazeData1+837
    .byt <MazeData1+868,<MazeData1+899,<MazeData1+930,<MazeData1+961,<MazeData1+992
    .byt <MazeData1+1023,<MazeData1+1054,<MazeData1+1085,<MazeData1+1116,<MazeData1+1147,<MazeData1+1178,<MazeData1+1209
    .byt <MazeData1+1240,<MazeData1+1271,<MazeData1+1302,<MazeData1+1333,<MazeData1+1364,<MazeData1+1395,<MazeData1+1426
    .byt <MazeData1+1457,<MazeData1+1488,<MazeData1+1519,<MazeData1+1550,<MazeData1+1581,<MazeData1+1612,<MazeData1+1643
    .byt <MazeData1+1674,<MazeData1+1705,<MazeData1+1736,<MazeData1+1767,<MazeData1+1798,<MazeData1+1829,<MazeData1+1860
    .byt <MazeData1+1891,<MazeData1+1922,<MazeData1+1953,<MazeData1+1984,<MazeData1+2015,<MazeData1+2046,<MazeData1+2077
    .byt <MazeData1+2108,<MazeData1+2139,<MazeData1+2170,<MazeData1+2201,<MazeData1+2232,<MazeData1+2263,<MazeData1+2294
    .byt <MazeData1+2325,<MazeData1+2356,<MazeData1+2387,<MazeData1+2418,<MazeData1+2449

:mazeRowLookupTableHi
    .byt >MazeData1,>MazeData1+31,>MazeData1+62,>MazeData1+93,>MazeData1+124,>MazeData1+155,>MazeData1+186
    .byt >MazeData1+217,>MazeData1+248,>MazeData1+279,>MazeData1+310,>MazeData1+341,>MazeData1+372,>MazeData1+403
    .byt >MazeData1+434,>MazeData1+465,>MazeData1+496,>MazeData1+527,>MazeData1+558,>MazeData1+589,>MazeData1+620
    .byt >MazeData1+651,>MazeData1+682,>MazeData1+713,>MazeData1+744,>MazeData1+775,>MazeData1+806,>MazeData1+837
    .byt >MazeData1+868,>MazeData1+899,>MazeData1+930,>MazeData1+961,>MazeData1+992
    .byt >MazeData1+1023,>MazeData1+1054,>MazeData1+1085,>MazeData1+1116,>MazeData1+1147,>MazeData1+1178,>MazeData1+1209
    .byt >MazeData1+1240,>MazeData1+1271,>MazeData1+1302,>MazeData1+1333,>MazeData1+1364,>MazeData1+1395,>MazeData1+1426
    .byt >MazeData1+1457,>MazeData1+1488,>MazeData1+1519,>MazeData1+1550,>MazeData1+1581,>MazeData1+1612,>MazeData1+1643
    .byt >MazeData1+1674,>MazeData1+1705,>MazeData1+1736,>MazeData1+1767,>MazeData1+1798,>MazeData1+1829,>MazeData1+1860
    .byt >MazeData1+1891,>MazeData1+1922,>MazeData1+1953,>MazeData1+1984,>MazeData1+2015,>MazeData1+2046,>MazeData1+2077
    .byt >MazeData1+2108,>MazeData1+2139,>MazeData1+2170,>MazeData1+2201,>MazeData1+2232,>MazeData1+2263,>MazeData1+2294
    .byt >MazeData1+2325,>MazeData1+2356,>MazeData1+2387,>MazeData1+2418,>MazeData1+2449

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

:OffscreenScrollArea .dsb 20400, 1

:OffscreenLineLookupLo 
    .byt <OffscreenScrollArea+0,<OffscreenScrollArea+255,<OffscreenScrollArea+510,<OffscreenScrollArea+765,<OffscreenScrollArea+1020
    .byt <OffscreenScrollArea+1275,<OffscreenScrollArea+1530,<OffscreenScrollArea+1785,<OffscreenScrollArea+2040,<OffscreenScrollArea+2295
    .byt <OffscreenScrollArea+2550,<OffscreenScrollArea+2805,<OffscreenScrollArea+3060,<OffscreenScrollArea+3315,<OffscreenScrollArea+3570
    .byt <OffscreenScrollArea+3825,<OffscreenScrollArea+4080,<OffscreenScrollArea+4335,<OffscreenScrollArea+4590,<OffscreenScrollArea+4845,
    .byt <OffscreenScrollArea+5100,<OffscreenScrollArea+5355,<OffscreenScrollArea+5610,<OffscreenScrollArea+5865,<OffscreenScrollArea+6120,
    .byt <OffscreenScrollArea+6375,<OffscreenScrollArea+6630,<OffscreenScrollArea+6885,<OffscreenScrollArea+7140,<OffscreenScrollArea+7395,
    .byt <OffscreenScrollArea+7650,<OffscreenScrollArea+7905,<OffscreenScrollArea+8160,<OffscreenScrollArea+8415,<OffscreenScrollArea+8670,
    .byt <OffscreenScrollArea+8925,<OffscreenScrollArea+9180,<OffscreenScrollArea+9435,<OffscreenScrollArea+9690,<OffscreenScrollArea+9945,
    .byt <OffscreenScrollArea+10200,<OffscreenScrollArea+10455,<OffscreenScrollArea+10710,<OffscreenScrollArea+10965,<OffscreenScrollArea+11220,
    .byt <OffscreenScrollArea+11475,<OffscreenScrollArea+11730,<OffscreenScrollArea+11985,<OffscreenScrollArea+12240,<OffscreenScrollArea+12495,
    .byt <OffscreenScrollArea+12750,<OffscreenScrollArea+13005,<OffscreenScrollArea+13260,<OffscreenScrollArea+13515,<OffscreenScrollArea+13770,
    .byt <OffscreenScrollArea+14025,<OffscreenScrollArea+14280,<OffscreenScrollArea+14535,<OffscreenScrollArea+14790,<OffscreenScrollArea+15045,
    .byt <OffscreenScrollArea+15300,<OffscreenScrollArea+15555,<OffscreenScrollArea+15810,<OffscreenScrollArea+16065,<OffscreenScrollArea+16320,
    .byt <OffscreenScrollArea+16575,<OffscreenScrollArea+16830,<OffscreenScrollArea+17085,<OffscreenScrollArea+17340,<OffscreenScrollArea+17595,
    .byt <OffscreenScrollArea+17850,<OffscreenScrollArea+18105,<OffscreenScrollArea+18360,<OffscreenScrollArea+18615,<OffscreenScrollArea+18870,
    .byt <OffscreenScrollArea+19125,<OffscreenScrollArea+19380,<OffscreenScrollArea+19635,<OffscreenScrollArea+19890,<OffscreenScrollArea+20145

:OffscreenLineLookupHi
    .byt >OffscreenScrollArea+0,>OffscreenScrollArea+255,>OffscreenScrollArea+510,>OffscreenScrollArea+765,>OffscreenScrollArea+1020
    .byt >OffscreenScrollArea+1275,>OffscreenScrollArea+1530,>OffscreenScrollArea+1785,>OffscreenScrollArea+2040,>OffscreenScrollArea+2295
    .byt >OffscreenScrollArea+2550,>OffscreenScrollArea+2805,>OffscreenScrollArea+3060,>OffscreenScrollArea+3315,>OffscreenScrollArea+3570
    .byt >OffscreenScrollArea+3825,>OffscreenScrollArea+4080,>OffscreenScrollArea+4335,>OffscreenScrollArea+4590,>OffscreenScrollArea+4845,
    .byt >OffscreenScrollArea+5100,>OffscreenScrollArea+5355,>OffscreenScrollArea+5610,>OffscreenScrollArea+5865,>OffscreenScrollArea+6120,
    .byt >OffscreenScrollArea+6375,>OffscreenScrollArea+6630,>OffscreenScrollArea+6885,>OffscreenScrollArea+7140,>OffscreenScrollArea+7395,
    .byt >OffscreenScrollArea+7650,>OffscreenScrollArea+7905,>OffscreenScrollArea+8160,>OffscreenScrollArea+8415,>OffscreenScrollArea+8670,
    .byt >OffscreenScrollArea+8925,>OffscreenScrollArea+9180,>OffscreenScrollArea+9435,>OffscreenScrollArea+9690,>OffscreenScrollArea+9945,
    .byt >OffscreenScrollArea+10200,>OffscreenScrollArea+10455,>OffscreenScrollArea+10710,>OffscreenScrollArea+10965,>OffscreenScrollArea+11220,
    .byt >OffscreenScrollArea+11475,>OffscreenScrollArea+11730,>OffscreenScrollArea+11985,>OffscreenScrollArea+12240,>OffscreenScrollArea+12495,
    .byt >OffscreenScrollArea+12750,>OffscreenScrollArea+13005,>OffscreenScrollArea+13260,>OffscreenScrollArea+13515,>OffscreenScrollArea+13770,
    .byt >OffscreenScrollArea+14025,>OffscreenScrollArea+14280,>OffscreenScrollArea+14535,>OffscreenScrollArea+14790,>OffscreenScrollArea+15045,
    .byt >OffscreenScrollArea+15300,>OffscreenScrollArea+15555,>OffscreenScrollArea+15810,>OffscreenScrollArea+16065,>OffscreenScrollArea+16320,
    .byt >OffscreenScrollArea+16575,>OffscreenScrollArea+16830,>OffscreenScrollArea+17085,>OffscreenScrollArea+17340,>OffscreenScrollArea+17595,
    .byt >OffscreenScrollArea+17850,>OffscreenScrollArea+18105,>OffscreenScrollArea+18360,>OffscreenScrollArea+18615,>OffscreenScrollArea+18870,
    .byt >OffscreenScrollArea+19125,>OffscreenScrollArea+19380,>OffscreenScrollArea+19635,>OffscreenScrollArea+19890,>OffscreenScrollArea+20145




