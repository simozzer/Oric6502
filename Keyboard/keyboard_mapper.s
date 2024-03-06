; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; runKeyboardMapper: launch a screen to allow a user to 
; define custom keys for playing the game
; Params : none
; Returns :null
; ------------------------------------------------------------
runKeyboardMapper
.(
  lda #<keyboard_mapper_screen_data
  sta _copy_mem_src_lo
  lda #>keyboard_mapper_screen_data
  sta _copy_mem_src_hi

  lda #$60
  sta _copy_mem_count_lo
  lda #$04
  sta _copy_mem_count_hi

  lda #$A8
  sta _copy_mem_dest_lo
  lda #$BB
  sta _copy_mem_dest_hi

  ; print the basic layout on the screen
  jsr CopyMemory

  jsr CopyCharsFromROM

  jsr displayAllKeyMappings

  jsr highlightSelectedRow

  loop
    ldy #4
    lda _KeyMatrix,y
    and #$40
    cmp #$40
    bne k0

    inc _keyboard_mapper_selected_row_index
    ldy _keyboard_mapper_selected_row_index
    lda _keyboard_mapper_row_indexes,y
    beq goToFirstItem
    bne doHighlight0

    goToFirstItem
    ldy #0
    sty _keyboard_mapper_selected_row_index
    doHighlight0
    jsr highlightSelectedRow
    jsr keyDelay

  k0
    ldy #4
    lda _KeyMatrix,Y
    and #$08
    cmp #$08
    bne k1
    lda _keyboard_mapper_selected_row_index
    beq goToLastItem
    dec _keyboard_mapper_selected_row_index
    jmp doHighlight1

    goToLastItem
    ldy #07
    sty _keyboard_mapper_selected_row_index
    :doHighlight1
    jsr highlightSelectedRow
    jsr keyDelay
    jmp loop

  k1
    ldy #7
    lda _KeyMatrix,Y
    cmp #$20
    and #$20
    bne edit
    beq k2
    edit
    jsr editSelectedKey
    jsr displayAllKeyMappings
    jsr highlightSelectedRow
    jsr keyDelay
    jmp loop
  k2
    ldy #6
    lda _KeyMatrix,Y
    cmp #$40
    and #$40
    bne quit
    jmp loop
    quit
    jsr keyDelay
    rts

  k3
  jmp loop
  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Holds the y positions of the rows containing items to be mapped
_keyboard_mapper_row_indexes
.byt 12,13,14,15,19,20,21,22,00

; The index of the currently selected row
_keyboard_mapper_selected_row_index 
.byt 0

; the index of the selected key within the keyboard matrix
_selectedKey_matrix_index .byt 0

; used to store the index of the start of a row for a key within the keyboard matrix
_row_start_index .byt 0

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; getMatrixIndexForAsciiCode: returns the index within the
; keyboard matrix for a given ascii code.
; params:
;    temp_param_0: ascii code to find
; returns
;    temp_return: the index of the ascii code within the matrix
; ----------------------------------------------------------------
getMatrixIndexForAsciiCode
.(
  ldy #00
  :loop
    cpy #64
    beq done
    lda _KeyAsciiUpper,Y
    cmp temp_param_0
    beq found
    iny
    jmp loop

  found
    sty temp_result

  done 
    rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; editSelectedKey: starts an editor for the selected key, checks
; that the key selection is valid and stores the result.
; Params: none
; Returns: null
; ----------------------------------------------------------------
editSelectedKey
.(
  jsr keyDelay
  ldy _keyboard_mapper_selected_row_index
  lda _keyboard_mapper_row_indexes,y
  tay
  tax

  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,y
  sta _line_start_hi

  lda #PAPER_WHITE
  ldy #18
  sta (_line_start),y

  lda #<PRESS_KEY_STR
  sta temp_param_2
  lda #>PRESS_KEY_STR
  sta temp_param_3
  lda #19
  sta temp_param_0
  stx temp_param_1
  jsr printStr


  jsr keyDelay
  lda #01

  :loop
  sei
  jsr _ReadKeyNoBounce
  cli
  cpx #00
  beq loop
  jsr keyDelay

  setKey
  // register x should now contain the ascii code of the character pressed.
  // Check that key selection is acceptable (i.e. not used elsewhere)
  stx temp_param_0
  jsr getMatrixIndexForAsciiCode
  lda temp_result
  sta _selectedKey_matrix_index
  jsr getKeyUnique
  lda temp_result
  cmp #0
  beq keyIsUnique
  jmp loop

  keyIsUnique
  doSetKey
  lda _selectedKey_matrix_index
  ; divide by 8 to find keyboard matrix row
  lsr
  lsr
  lsr
  clc
  ; store matrix row value for selected item
  ldy _keyboard_mapper_selected_row_index
  sta keyboardRows,y 

  ; multiply row by 8 
  asl
  asl
  asl
  sta _row_start_index
  
  ;subtract value from _selectedKey_matrix_index
  lda _selectedKey_matrix_index
  clc
  sbc _row_start_index
  tay
  iny

  ; a should now contain the index for the bitmask
  lda key_column_bitmasks,Y
  ldy _keyboard_mapper_selected_row_index
  sta keyboardColMasks,y

  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; holds the ascii code of the newly selected key
_selected_ascii_code .byt 0


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; getKeyUnique : returns whether the key pressed, for the 
; selected user action, is unique amongst the key presses 
; (or the same as the existing key).
; params:
;   temp_param_0: ascii code selected for the key
; returns:
;   temp_result: will be set to zero id the key is unique 
;      (or the same as the existing selection)
;-------------------------------------------------------------
getKeyUnique
.(
  lda temp_param_0
  sta _selected_ascii_code

  ;find the stored ascii code for the currently selected row
  ldy _keyboard_mapper_selected_row_index
  sty temp_param_0
  jsr getAsciiCodeForActionIndex
  lda temp_result

  cmp _selected_ascii_code
  bne checkOtherKeys

  ;ascii code is the same as the current selection
  lda #0
  sta temp_result
  rts

  checkOtherKeys
  ldy #0
  loop
    cpy _keyboard_mapper_selected_row_index
    beq skip
    sty temp_param_0
    jsr getAsciiCodeForActionIndex
    lda temp_result
    cmp _selected_ascii_code
    beq exists

  skip
    iny
    cpy #08
    bne loop

    ; we've reached the end with no match
    lda #0
    sta temp_result
    rts
  exists
    lda #1
    sta temp_result
    rts

.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; getAsciiCodeForActionIndex: returns the ascii code for a given user action
; index
; params:
;   temp_param_0: the index of the user action
; returns:
;   temp_result: the asctii code assigned to the user action
; ------------------------------------------------------------
getAsciiCodeForActionIndex
.(
  tya
  pha
  ldy temp_param_0;
  lda keyboardRows,Y
  sta temp_param_0
  lda keyboardColMasks,y
  sta temp_param_1
  jsr getAsciiCodeForKeyPosition ; sets temp_result to asciiCode
  pla
  tay
  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; highlightSelectedRow: Changes the background color of 
; the currently selected item.
; params: none
; returns: null
; ------------------------------------------------------------
highlightSelectedRow
.(

  ; Clear any existing row highlights
  ldy #00
  sty temp_value
  loop
  ldy temp_value
  lda _keyboard_mapper_row_indexes,y
  cmp #00
  beq cleared
  
  tay
  lda ScreenLineLookupLo,y
  sta _line_start_lo
  lda ScreenLineLookupHi,Y
  sta _line_start_hi

  ldy #18
  lda #PAPER_CYAN
  sta (_line_start),Y
  inc temp_value
  jmp loop

  cleared
    ;highhtlight the selected row
    ldy _keyboard_mapper_selected_row_index
    lda _keyboard_mapper_row_indexes,Y
    tay

    lda ScreenLineLookupLo,Y
    sta _line_start_lo
    lda ScreenLineLookupHi,Y
    sta _line_start_hi

    ldy #18
    lda #PAPER_YELLOW
    sta (_line_start),Y
    
    rts

.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; displayAllKeyMappings: displays the keys mapped to each
; keyboard action
; params: none
; returns: null
; ------------------------------------------------------------
displayAllKeyMappings
.(
  lda key_up_player1_row
  sta temp_param_0
  lda key_up_player1_col_mask
  sta temp_param_1
  lda #19
  sta temp_param_2
  lda #12
  sta temp_param_3
  jsr displayKeyMapping

  lda key_down_player1_row
  sta temp_param_0
  lda key_down_player1_col_mask
  sta temp_param_1
  lda #19
  sta temp_param_2
  lda #13
  sta temp_param_3
  jsr displayKeyMapping


  lda key_left_player1_row
  sta temp_param_0
  lda key_left_player1_col_mask
  sta temp_param_1
  lda #19
  sta temp_param_2
  lda #14
  sta temp_param_3
  jsr displayKeyMapping

  lda key_right_player1_row
  sta temp_param_0
  lda key_right_player1_col_mask
  sta temp_param_1
  lda #19
  sta temp_param_2
  lda #15
  sta temp_param_3
  jsr displayKeyMapping

 
 
  lda key_up_player2_row
  sta temp_param_0
  lda key_up_player2_col_mask
  sta temp_param_1
  lda #19
  sta temp_param_2
  lda #19
  sta temp_param_3
  jsr displayKeyMapping

  lda key_down_player2_row
  sta temp_param_0
  lda key_down_player2_col_mask
  sta temp_param_1
  lda #19
  sta temp_param_2
  lda #20
  sta temp_param_3
  jsr displayKeyMapping


  lda key_left_player2_row
  sta temp_param_0
  lda key_left_player2_col_mask
  sta temp_param_1
  lda #19
  sta temp_param_2
  lda #21
  sta temp_param_3
  jsr displayKeyMapping

  lda key_right_player2_row
  sta temp_param_0
  lda key_right_player2_col_mask
  sta temp_param_1
  lda #19
  sta temp_param_2
  lda #22
  sta temp_param_3
  jsr displayKeyMapping

 
 
  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; displayAllKeyMappings: Displays the key for a given position
; in the keyboard matrix, at a specified position.
; Params:
;   temp_param_0: keyboard row
;   temp_param_1: keyboard column mask
;   temp_param_2: screen x pos
;   temp_param_3: screen y pos
;--------------------------------------------------------------
displayKeyMapping
.(
  ;no need to alter temp_param_0 & 1 as these 
  ;should have been passed correctly by the caller
  jsr getAsciiCodeForKeyPosition
  lda temp_result

  ;blank out the currently displayed result
  ldy temp_param_3
  lda ScreenLineLookupLo,Y
  sta _line_start_lo
  lda ScreenLineLookupHi,Y
  sta _line_start_hi

  lda temp_param_2
  clc
  adc #15; blank out 14 spaces
  tay
  lda #32
  loop
  dey
  cpy temp_param_2
  beq print
  sta (_line_start),y
  jmp loop

  print
  lda #PAPER_CYAN
  ldy #32
  sta (_line_start),y
  lda temp_result ; load the ascii code
  cmp #33
  bcc non_ascii
  ldy temp_param_2
  sta (_line_start),y
  rts

  non_ascii

  tax
  lda temp_param_2
  sta temp_param_0
  lda temp_param_3
  sta temp_param_1
  txa

  cmp #KEY_LCTRL
  bne n0
  lda #<KEY_LCTRL_STR
  sta temp_param_2
  lda #>KEY_LCTRL_STR
  sta temp_param_3
  jmp doPrint

  n0
  cmp #KEY_RCTRL
  bne n1
  lda #<KEY_RCTRL_STR
  sta temp_param_2
  lda #>KEY_RCTRL_STR
  sta temp_param_3
  jmp doPrint

  n1
  cmp #KEY_LSHIFT
  bne n2
  lda #<KEY_LSHIFT_STR
  sta temp_param_2
  lda #>KEY_LSHIFT_STR
  sta temp_param_3
  jmp doPrint

  n2
  cmp #KEY_RSHIFT
  bne n3
  lda #<KEY_RSHIFT_STR
  sta temp_param_2
  lda #>KEY_RSHIFT_STR
  sta temp_param_3
  jmp doPrint

  n3
  cmp #KEY_FUNCT
  bne n4
  lda #<KEY_FUNCT_STR
  sta temp_param_2
  lda #>KEY_FUNCT_STR
  sta temp_param_3
  jmp doPrint

  n4
  cmp #KEY_LEFT  
  bne n5
  lda #<KEY_LEFT_STR
  sta temp_param_2
  lda #>KEY_LEFT_STR
  sta temp_param_3
  jmp doPrint

  n5
  cmp #KEY_RIGHT
  bne n6
  lda #<KEY_RIGHT_STR
  sta temp_param_2
  lda #>KEY_RIGHT_STR
  sta temp_param_3
  jmp doPrint

  n6
  cmp #KEY_DOWN
  bne n7
  lda #<KEY_DOWN_STR
  sta temp_param_2
  lda #>KEY_DOWN_STR
  sta temp_param_3
  jmp doPrint

  n7
  cmp #KEY_UP
  bne n8
  lda #<KEY_UP_STR
  sta temp_param_2
  lda #>KEY_UP_STR
  sta temp_param_3
  jmp doPrint

  n8
  cmp #KEY_RETURN
  bne n9
  lda #<KEY_RETURN_STR
  sta temp_param_2
  lda #>KEY_RETURN_STR
  sta temp_param_3
  jmp doPrint

  n9
  cmp #KEY_ESCAPE
  bne n10
  lda #<KEY_ESCAPE_STR
  sta temp_param_2
  lda #>KEY_ESCAPE_STR
  sta temp_param_3
  jmp doPrint

  n10
  cmp #KEY_SPACE
  bne n11
  lda #<KEY_SPACE_STR
  sta temp_param_2
  lda #>KEY_SPACE_STR
  sta temp_param_3
  jmp doPrint

  n11
  cmp #KEY_DELETE
  bne key_unknown
  lda #<KEY_DELETE_STR
  sta temp_param_2
  lda #>KEY_DELETE_STR
  sta temp_param_3
  jmp doPrint

  key_unknown
  lda #<KEY_UNKNOWN_STR
  sta temp_param_2
  lda #>KEY_UNKNOWN_STR
  sta temp_param_3

  ;set x and y parameters
  :doPrint
  jsr printStr

  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; getAsciiCodeForKeyPosition: get the ascii code
; for a given keyboard row and column mask.
; params:
;   temp_param_0: keyboard row
;   temp_param_1: keyboard column mask
; returns:
;   temp_result: the ascii code
; ------------------------------------------------------------
getAsciiCodeForKeyPosition
.(
  tya
  pha

  lda #00
  clc
  ldy temp_param_0
  decRow
  beq gotRow
  clc
  adc #08
  dey
  cpy #00
  bne decRow
  sta temp_value ; store row index

  gotRow
  ldx #00
  lda temp_param_1
  shiftCol
  cmp #01
  beq gotCol
  inx
  clc
  lsr
  bne shiftCol

  gotCol
  clc
  txa
  adc temp_value

  tay
  lda _KeyAsciiUpper,Y
  sta temp_result

  pla
  tay

  rts
.)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<