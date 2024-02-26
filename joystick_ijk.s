// Code taken from https://wiki.defence-force.org/doku.php?id=oric:hardware:ijk_drivers

GenericIJKBits
      .byt 0,2,1,3,32,34,33,0,8,10,9,0,40,42,41,0
      .byt 16,18,17,0,48,50,49,0,0,0,0,0,0,0,0,0

GenericReadIJK
         ;Ensure Printer Strobe is set to Output
         LDA #%10110111
         STA via_ddrb
         ;Set Strobe Low
         LDA #%00000000
         STA via_portb
         ;Set Top two bits of PortA to Output and rest as Input
         LDA #%11000000
         STA via_ddra
         ;Select Left Joystick
         LDA #%01111111
         STA via_porta
         ;Read back Left Joystick state
         LDA via_porta
         ;Mask out unused bits
         AND #%00011111
         ;Invert Bits
         EOR #%00011111
         ;Index table to conform to Generic Format
         TAX
         LDA GenericIJKBits,X
         STA joy_Left
         ;Select Right Joystick
         LDA #%10111111
         STA via_porta
         ;Read back Right Joystick state and rejig bits
         LDA via_porta
         AND #%00011111
         EOR #%00011111
         TAX
         LDA GenericIJKBits,X
         STA joy_Right
         ;Restore VIA PortA state
         LDA #%11111111
         STA via_ddra
         RTS



checkIJKPresent ; sets carry flag if present
.(
    LDA #%11000000
    STA via_ddra
    STA via_porta
    LDA via_porta
    AND #%00100000
    clc
    BNE ijkPresent
    rts

    ijkPresent
    sec
    rts

.)