
; Display section of maze on screen
:MazeDisplay
;$7E is left of maze
;$7F is top position of maze
;$80 is temporary store for byte 
    lda #$10 ; left
    sta $7E
    lda #01 ; top
    sta $7F


:getMazeBit
    ldy $7F
    lda mazeRowLookupTableLo,Y    ; lookup low byte for row value and store
    sta getTheByte+1               
    lda mazeRowLookupTableHi,Y     ; lookup hi byte for row value and store
    sta getTheByte+2

; find the correct byte from that row by dividing by 8 ;;TODO: Faster with lookup
;    LDA $7E ; column
;    LDX #0
;    SEC
;:Divide		
;    INX
;    SBC #$08
;    BCS Divide
;    ; X should now contain the correct column for the byte
;    DEX ; !Experiment

    ldx $7E
    lda divideBy8Table,x


:getTheByte
    lda $ffff,X
    sta $80 ; $80 should now contain the maze byte for the column and row

; Get the remainder of the above divison to find the
; correct BIT for the maze wall  ;; TODO: Faster with lookup

;    LDA $7E  ; column
;    SEC
;Modulus:	
;    SBC #$08
;    BCS Modulus
;    ADC #$08
    ldx $7E
    lda mod8Table,X

    tax
    lda reverseBitmaskTable,X

    ; Logical AND with accumulator AND $80 should tell us if bit is set (i.e there is a wall)

    and $80

    ;; if accumulator is non zero there is a wall
    bne nowall
    lda #$01
    rts
:nowall
    lda #00
    rts
    
    
    






                                     