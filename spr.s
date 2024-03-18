; #######################################
; #######################################
;        All sprites of the game
; #######################################
; ########################F###############


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Characters appearing before numbers in the
; ascii code list, redfined for game mode
preNumericSpriteData
    ; BLACK HOLE
    .byt 7,8,9,18,36,36,41,42 ;33
    .byt 56,4,36,18,9,9,37,21 ;34
    .byt 42,41,36,36,18,9,8,7 ;35
    .byt 21,37,9,9,18,36,4,56 ;36

    ; eraser
    .byt 30,33,33,33,63,63,63,30 ;37

    ; SLOW
    .byt 0,29,33,33,25,5,5,57 ;38
    .byt 0,9,21,21,20,20,20,8 ;39
    .byt 0,1,1,1,42,42,42,20  ;40

    ; arrows
    .byt 16,24,28,30,28,24,16,0 ;41 right arrow
    .byt 2,6,14,30,14,6,2,0 ;42 left arrow
    .byt 0,4,4,14,14,31,31,0 ;43 up arrow
    .byt 0,31,31,14,14,4,4,0 ;44 down arrow

    ;FAST
    .byt 57,34,34,59,34,34,34,0 ;45
    .byt 6,41,40,38,33,41,38,0 ;46
    .byt 31,4,4,4,4,4,4,0 ;47

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Letters a-z redefined	for game mode		
; ---------------------------------------    
:_AltSpriteData
    // 17 character of 'random' data to fill background (so that scrolling motion can be seen when screen is empty)
    .byt 00,08,00,00,00,00,00,00 ;a ;ascii code 97   
    .byt 00,00,04,00,00,00,00,00 ;b       
    .byt 00,00,00,01,00,00,00,00 ;c    
    .byt 00,00,00,00,16,00,00,00 ;d
    .byt 00,00,00,00,00,02,00,00 ;e 
    .byt 00,00,00,00,00,00,01,00 ;f           
    .byt 00,01,00,00,00,00,00,00 ;g   
    .byt 00,00,00,04,00,00,00,00 ;h          
    .byt 00,00,00,00,04,00,00,00 ;i      
    .byt 00,00,00,04,00,00,16,00 ;j  
    .byt 00,02,00,00,00,00,00,00 ;k
    .byt 00,00,02,00,00,00,00,00 ;l
    .byt 01,00,00,00,00,00,00,00 ;m
    .byt 00,00,00,16,00,00,00,00 ;n
    .byt 00,00,00,02,00,00,00,00 ;o
    .byt 00,00,00,00,00,00,00,08 ;p
    .byt 00,16,00,00,00,00,00,00 ;q ;ascii code 113
    .byt 63,63,63,63,63,63,63,63 ;r ; brick (ascii code 114)
 :_Player1_Game_Sprite_Start
    .byt 0,30,30,30,30,30,30,0 ;s  ;segment of player 1 light trail (ascii code 115)
    .byt 0,30,18,18,18,18,30,0 ;t  ; another player 1 segment (116)
    .byt 0,30,18,12,12,18,30,0 ;u  ; another player 2 segment (117)
:_Player2_Game_Sprite_Start
    .byt 00,18,18,12,12,18,18,00 ;v ;segment of player 2 light trail (ascii code 118)   
    .byt 00,00,18,12,12,18,00,00 ;w ; another player 1 segment (119)      
    .byt 00,00,00,12,12,00,00,00 ;x ; another player 1 segment (120)  


    .byt 01,01,01,01,01,01,01,01 ;y side by side screen splitter (left side - ascii code 121)         
    .byt 32,32,32,32,32,32,32,32 ;z side by side screen splitter (right side - ascii code 122)
    .byt 61,33,33,33,33,33,33,61 ;{123
    .byt 00,30,30,30,30,30,30,00 ;¦124
    .byt 42,21,42,21,42,21,42,21 ;}125
    .byt 00,00,63,00,00,63,00,00 ;~ top/bottom screen splitter (ascii code 126)12
:_SpriteBackup_
    .dsb 255,1 ;208 would work for 26 characters
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   



; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Letters a-z redefined	backup of 
; characters in 'game' mode		
; --------------------------------------- 
:_animationBackup 
    .byt 00,08,00,00,00,00,00,00 ;a ;ascii code 97   
    .byt 00,00,04,00,00,00,00,00 ;b       
    .byt 00,00,00,01,00,00,00,00 ;c    
    .byt 00,00,00,00,16,00,00,00 ;d
    .byt 00,00,00,00,00,02,00,00 ;e 
    .byt 00,00,00,00,00,00,01,00 ;f           
    .byt 00,01,00,00,00,00,00,00 ;g   
    .byt 00,00,00,04,00,00,00,00 ;h          
    .byt 00,00,00,00,04,00,00,00 ;i      
    .byt 00,00,00,04,00,00,16,00 ;j  
    .byt 00,02,00,00,00,00,00,00 ;k
    .byt 00,00,02,00,00,00,00,00 ;l
    .byt 01,00,00,00,00,00,00,00 ;m
    .byt 00,00,00,16,00,00,00,00 ;n
    .byt 00,00,00,02,00,00,00,00 ;o
    .byt 00,00,00,00,00,00,00,08 ;p
    .byt 00,16,00,00,00,00,00,00 ;q ;ascii code 113
    .byt 63,63,63,63,63,63,63,63 ;r ; brick (ascii code 114)
 :_Player1_Game_Sprite_Backup_Start
    .byt 0,30,30,30,30,30,30,0 ;s  ;segment of player 1 light trail (ascii code 115)
    .byt 0,30,18,18,18,18,30,0 ;t  ; another player 1 segment (116)
    .byt 0,30,18,12,12,18,30,0 ;u  ; another player 2 segment (117)
 :_Player2_Game_Sprite_Backup_Start
    .byt 00,20,10,20,10,20,10,00 ;v ;segment of player 2 light trail (ascii code 118)   
    .byt 61,04,04,04,04,04,04,04 ;w ; another player 1 segment (119)      
    .byt 61,08,08,08,08,08,08,08 ;x ; another player 1 segment (120)  
    .byt 01,01,01,01,01,01,01,01 ;y side by side screen splitter (left side - ascii code 121)         
    .byt 32,32,32,32,32,32,32,32 ;z side by side screen splitter (right side - ascii code 122)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    .byt 61,33,33,33,33,33,33,61 ;{ random individual blocks 123
    .byt 00,30,30,30,30,30,30,00 ;¦124
    .byt 42,21,42,21,42,21,42,21 ;}125
    .byt 61,00,61,00,61,00,61,00 ;~126

;    .byt 61,33,33,33,33,33,33,61 ;[91
;    .byt 00,30,30,30,30,30,30,00 ;\92
;    .byt 42,21,42,21,42,21,42,21 ;]93
;    .byt 61,00,61,00,61,00,61,00 ;^94
;_95
;`96


