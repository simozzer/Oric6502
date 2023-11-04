; // DATA FOR MAZE .. currently only an empty area with walls on each edge
; // (and some test data on row 1)
; // Each BIT which is set will be a block of the wall
; // Each row is 31 bytes long - allowing for 255 sections of wall for each row (with 80 rows we will use 20400 bytes to store
; the expanded maze, 255 bytes per row)

;// currently have 80 rows of data, (need to expand the lookup tables in further rows added)
:MazeData1
.byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$fe ; last bit in last byte is not used
.byt $80,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$02
.byt $BF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$20,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$1F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$02
.byt $A0,$80,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$02
.byt $AF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$E0,$10,$01,$00,$10,$00,$00,$08,$40,$80,$00,$00,$07,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F5,$02
.byt $A8,$00,$10,$00,$00,$00,$00,$00,$00,$00,$08,$00,$80,$48,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$02
.byt $AB,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$40,$08,$20,$00,$00,$00,$80,$00,$00,$00,$01,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$D5,$02
.byt $AA,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$22,$04,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$02
.byt $AA,$FF,$7F,$DF,$EB,$FF,$FF,$BF,$FE,$00,$00,$01,$00,$00,$00,$12,$00,$00,$01,$00,$02,$80,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$55,$02
.byt $AA,$80,$40,$10,$08,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$09,$18,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$55,$02
.byt $AA,$FF,$FF,$FF,$FF,$FB,$FF,$FF,$F9,$00,$20,$00,$00,$00,$40,$00,$14,$00,$00,$08,$00,$00,$1F,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$55,$02
.byt $AA,$A0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$08,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$55,$02
.byt $AA,$AB,$FF,$FF,$FF,$FB,$FF,$FF,$F0,$00,$10,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$07,$FF,$FF,$FF,$FF,$FF,$FF,$F5,$55,$02
.byt $AA,$AA,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$55,$02
.byt $AA,$AB,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$20,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$01,$FF,$FF,$FF,$FF,$FF,$FF,$D5,$55,$02
.byt $AA,$AA,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55,$02
.byt $AA,$AA,$7F,$FF,$FF,$FF,$FF,$FE,$00,$00,$00,$00,$80,$20,$00,$00,$00,$02,$00,$00,$00,$00,$00,$7F,$FF,$FF,$FF,$FF,$FF,$55,$55,$02
.byt $AA,$AA,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$55,$55,$02
.byt $AA,$AA,$BF,$FF,$FF,$FF,$FF,$F9,$10,$00,$00,$00,$40,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$1F,$FF,$FF,$FF,$FF,$FD,$55,$55,$02
.byt $A2,$AA,$A0,$00,$00,$C0,$00,$01,$80,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$55,$55,$02
.byt $AE,$AA,$EF,$DF,$FF,$BF,$FF,$E0,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$FF,$FF,$FF,$FF,$F5,$55,$55,$02
.byt $AA,$AA,$A8,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$55,$55,$02
.byt $AA,$AA,$AB,$FF,$FF,$FF,$FF,$81,$00,$04,$00,$00,$00,$20,$00,$00,$10,$00,$00,$00,$00,$00,$00,$01,$FF,$FF,$FF,$FF,$D5,$55,$55,$02
.byt $AA,$AA,$AA,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55,$55,$02
.byt $AA,$AA,$AA,$FE,$FF,$FF,$FE,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$7F,$FF,$FF,$FF,$55,$55,$55,$02
.byt $AA,$AA,$AA,$80,$00,$00,$00,$00,$10,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$55,$55,$55,$02
.byt $AA,$AA,$AA,$BF,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$FF,$FF,$FD,$55,$55,$55,$02
.byt $AA,$AA,$AA,$A0,$00,$00,$00,$04,$00,$00,$00,$20,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AF,$FF,$FF,$E0,$02,$00,$20,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$07,$FF,$FF,$F5,$55,$55,$55,$02
.byt $AA,$AA,$AA,$A8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AB,$FF,$FF,$80,$10,$00,$04,$00,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$FF,$FF,$D5,$55,$55,$55,$02
.byt $AA,$BA,$AA,$AA,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AA,$FF,$FE,$00,$3C,$00,$00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$7F,$FF,$55,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AA,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$55,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AA,$BF,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$FD,$55,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AA,$A0,$00,$02,$08,$40,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$55,$55,$55,$55,$02
.byt $AA,$A8,$AA,$AA,$AF,$E0,$00,$01,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$F5,$55,$55,$55,$55,$02
.byt $AA,$AB,$AA,$AA,$A8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$55,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AA,$AB,$80,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$D5,$55,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AA,$AA,$04,$08,$04,$0A,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AA,$AA,$00,$00,$02,$00,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AA,$AB,$90,$00,$88,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$D5,$55,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AA,$A8,$00,$08,$08,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$55,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AA,$AF,$E0,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$F5,$55,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AA,$A0,$00,$00,$88,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$55,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AA,$BF,$F8,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$FD,$55,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AA,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$55,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AA,$FF,$FE,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$7F,$FF,$55,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AA,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55,$55,$55,$02
.byt $AA,$AA,$A2,$AB,$FF,$FF,$80,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$FF,$FF,$D5,$55,$55,$55,$02
.byt $AA,$AA,$AA,$A8,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$55,$55,$55,$02
.byt $AA,$AA,$AA,$AF,$FF,$FF,$E0,$08,$00,$00,$01,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$FF,$FF,$F5,$55,$55,$55,$02
.byt $AA,$AA,$AA,$A0,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$55,$55,$55,$02
.byt $AA,$AA,$AA,$BF,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$FF,$FF,$FD,$55,$55,$55,$02
.byt $AA,$AA,$AA,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$55,$55,$55,$02
.byt $AA,$AA,$AA,$FF,$FF,$FF,$FE,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$7F,$FF,$FF,$FF,$55,$55,$55,$02
.byt $AA,$AA,$AA,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55,$55,$02
.byt $AA,$AA,$AB,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$FF,$FF,$FF,$FF,$D5,$55,$55,$02
.byt $AA,$AA,$A8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$55,$55,$02
.byt $AA,$AA,$AF,$FF,$FF,$FF,$FF,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$FF,$FF,$FF,$FF,$F5,$55,$55,$02
.byt $AA,$AA,$A0,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$55,$55,$02
.byt $AA,$AA,$BF,$FF,$FF,$FF,$7F,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$FF,$FF,$FF,$FF,$FD,$55,$55,$02
.byt $AA,$AA,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$55,$55,$02
.byt $AA,$AA,$FF,$FD,$FF,$FF,$FF,$FE,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$7F,$FF,$FF,$FF,$FF,$FF,$55,$55,$02
.byt $AA,$AA,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55,$02
.byt $AA,$AB,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$FF,$FF,$FF,$FF,$FF,$FF,$D5,$55,$02
.byt $AA,$A8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$55,$02
.byt $AA,$AF,$FF,$FF,$FF,$FF,$FF,$FF,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$07,$FF,$FF,$FF,$FF,$FF,$FF,$F5,$55,$02
.byt $AA,$A0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$55,$02
.byt $AA,$BF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$55,$02
.byt $AA,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$55,$02
.byt $AA,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$55,$02
.byt $AA,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$02
.byt $AB,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$D5,$02
.byt $A8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$02
.byt $AF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F5,$02
.byt $A0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$02
.byt $BF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$02
.byt $80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$02
.byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$Fe
:mazeRowLookupTableLo
.byt <MazeData1,<MazeData1+32,<MazeData1+64,<MazeData1+96,<MazeData1+128,<MazeData1+160,<MazeData1+192,<MazeData1+224,<MazeData1+256,
.byt <MazeData1+288,<MazeData1+320,<MazeData1+352,<MazeData1+384,<MazeData1+416,<MazeData1+448,<MazeData1+480,<MazeData1+512,<MazeData1+544,
.byt <MazeData1+576,<MazeData1+608,<MazeData1+640,<MazeData1+672,<MazeData1+704,<MazeData1+736,<MazeData1+768,<MazeData1+800,<MazeData1+832,
.byt <MazeData1+864,<MazeData1+896,<MazeData1+928,<MazeData1+960,<MazeData1+992,<MazeData1+1024,<MazeData1+1056,<MazeData1+1088,<MazeData1+1120,
.byt <MazeData1+1152,<MazeData1+1184,<MazeData1+1216,<MazeData1+1248,<MazeData1+1280,<MazeData1+1312,<MazeData1+1344,<MazeData1+1376,<MazeData1+1408,
.byt <MazeData1+1440,<MazeData1+1472,<MazeData1+1504,<MazeData1+1536,<MazeData1+1568,<MazeData1+1600,<MazeData1+1632,<MazeData1+1664,<MazeData1+1696,
.byt <MazeData1+1728,<MazeData1+1760,<MazeData1+1792,<MazeData1+1824,<MazeData1+1856,<MazeData1+1888,<MazeData1+1920,<MazeData1+1952,<MazeData1+1984,
.byt <MazeData1+2016,<MazeData1+2048,<MazeData1+2080,<MazeData1+2112,<MazeData1+2144,<MazeData1+2176,<MazeData1+2208,<MazeData1+2240,<MazeData1+2272,
.byt <MazeData1+2304,<MazeData1+2336,<MazeData1+2368,<MazeData1+2400,<MazeData1+2432,<MazeData1+2464,<MazeData1+2496,<MazeData1+2528

:mazeRowLookupTableHi
.byt >MazeData1,>MazeData1+32,>MazeData1+64,>MazeData1+96,>MazeData1+128,>MazeData1+160,>MazeData1+192,>MazeData1+224,>MazeData1+256,
.byt >MazeData1+288,>MazeData1+320,>MazeData1+352,>MazeData1+384,>MazeData1+416,>MazeData1+448,>MazeData1+480,>MazeData1+512,>MazeData1+544,
.byt >MazeData1+576,>MazeData1+608,>MazeData1+640,>MazeData1+672,>MazeData1+704,>MazeData1+736,>MazeData1+768,>MazeData1+800,>MazeData1+832,
.byt >MazeData1+864,>MazeData1+896,>MazeData1+928,>MazeData1+960,>MazeData1+992,>MazeData1+1024,>MazeData1+1056,>MazeData1+1088,>MazeData1+1120,
.byt >MazeData1+1152,>MazeData1+1184,>MazeData1+1216,>MazeData1+1248,>MazeData1+1280,>MazeData1+1312,>MazeData1+1344,>MazeData1+1376,>MazeData1+1408,
.byt >MazeData1+1440,>MazeData1+1472,>MazeData1+1504,>MazeData1+1536,>MazeData1+1568,>MazeData1+1600,>MazeData1+1632,>MazeData1+1664,>MazeData1+1696,
.byt >MazeData1+1728,>MazeData1+1760,>MazeData1+1792,>MazeData1+1824,>MazeData1+1856,>MazeData1+1888,>MazeData1+1920,>MazeData1+1952,>MazeData1+1984,
.byt >MazeData1+2016,>MazeData1+2048,>MazeData1+2080,>MazeData1+2112,>MazeData1+2144,>MazeData1+2176,>MazeData1+2208,>MazeData1+2240,>MazeData1+2272,
.byt >MazeData1+2304,>MazeData1+2336,>MazeData1+2368,>MazeData1+2400,>MazeData1+2432,>MazeData1+2464,>MazeData1+2496,>MazeData1+2528

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

#DEFINE OffscreenScrollArea $6000

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




