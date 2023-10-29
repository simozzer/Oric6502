
; Display section of maze on screen
:MazeDisplay
;$7E is left of maze
;$7F is top position of maze
;$80 is temporary store for byte 
    lda #$0E ; left
    sta $7E
    lda #01 ; top
    sta $7F


:getMazeBit
    ldy $7F
    lda mazeRowLookupTableLo,Y    ; lookup low byte for row value and store
    sta getTheByte+1               
    lda mazeRowLookupTableHi,Y     ; lookup hi byte for row value and store
    sta getTheByte+2

; find the correct byte from that row by dividing col b y 8
    ldx $7E
    lda divideBy8Table,x
    tax

:getTheByte
    lda $ffff,X
    sta $80 ; $80 should now contain the maze byte for the column and row

; Get the remainder of the above divison to find the
; correct BIT for the maze wall  ; Faster with lookup

    ldx $7E
    lda mod8Table,X

    tax
    lda reverseBitmaskTable,X

    ; Logical AND with accumulator AND $80 should tell us if bit is set (i.e there is a wall)
    and $80

    ;; if accumulator is non zero there is a wall
    beq nowall
    lda #$01
    rts
:nowall
    lda #00
    rts
    
    
    






                                     