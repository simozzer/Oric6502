;////////////////////////////////////
; Lookup tables for lo and hi bytes 
; of each line in text mode
;////////////////////////////////////
:ScreenLineLookupLo 
  .byt $A8,$D0,$F8,$20,$48,$70,$98,$C0,$E8,$10                        
  .byt $38,$60,$88,$B0,$D8,$00,$28,$50,$78,$A0                            
  .byt $C8,$F0,$18,$40,$68,$90,$B8  

:ScreenLineLookupHi 
  .byt $BB,$BB,$BB,$BC,$BC,$BC,$BC,$BC,$BC,$BD                        
  .byt $BD,$BD,$BD,$BD,$BD,$BE,$BE,$BE,$BE,$BE                            
  .byt $BE,$BE,$BF,$BF,$BF,$BF,$BF