; #######################################
; #######################################
;        All sprites of the game
; #######################################
; #######################################


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Letters a-z redefined	for intro mode		
; ---------------------------------------
:_SpriteData_
    .byt 63,33,33,33,33,33,33,63 ;a
    .byt 00,30,18,18,18,18,30,00 ;b       
    .byt 00,00,12,12,12,12,00,00 ;c       
    .byt 00,00,00,12,12,00,00,00 ;d    
    .byt 00,00,00,12,00,00,00,00 ;e
    .byt 00,00,00,08,00,00,00,00 ;f      
    .byt 00,00,08,28,28,08,00,00 ;g      
    .byt 00,08,08,28,28,08,08,00 ;h   
    .byt 08,08,08,30,30,08,08,08 ;i      
    .byt 08,08,08,63,63,08,08,08 ;j      
    .byt 28,08,08,63,63,08,08,28 ;k      
    .byt 30,08,08,63,63,08,08,30 ;l      
    .byt 63,08,08,63,63,08,08,63 ;m      
    .byt 63,08,08,30,30,08,08,63 ;n      
    .byt 63,08,08,28,28,08,08,63 ;o      
    .byt 63,08,08,08,08,08,08,63 ;p      
    .byt 63,08,08,00,00,08,08,63 ;q      
    .byt 63,08,00,00,00,00,08,63 ;r      
    .byt 63,00,00,00,00,00,00,63 ;s      
    .byt 63,00,00,00,00,00,00,00 ;t      
    .byt 31,00,00,00,00,00,00,00 ;u      
    .byt 15,00,00,00,00,00,00,00 ;v      
    .byt 07,00,00,00,00,00,00,00 ;w     
    .byt 05,00,00,00,00,00,00,00 ;x      
    .byt 03,00,00,00,00,00,00,00 ;y     
    .byt 01,00,00,00,00,00,00,00 ;z
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   



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
    .byt 63,04,04,04,04,04,04,04 ;w ; another player 1 segment (119)      
    .byt 63,08,08,08,08,08,08,08 ;x ; another player 1 segment (120)  
    .byt 01,01,01,01,01,01,01,01 ;y side by side screen splitter (left side - ascii code 121)         
    .byt 32,32,32,32,32,32,32,32 ;z side by side screen splitter (right side - ascii code 122)
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<