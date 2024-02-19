#DEFINE PAPER_BLACK 16
#DEFINE PAPER_RED 17
#DEFINE PAPER_GREEN 18
#DEFINE PAPER_YELLOW 19
#DEFINE PAPER_BLUE 20
#DEFINE PAPER_MAGENTA 21
#DEFINE PAPER_CYAN 22
#DEFINE PAPER_WHITE 23

#DEFINE INK_BLACK 0
#DEFINE INK_RED 1
#DEFINE INK_GREEN 2
#DEFINE INK_YELLOW 3
#DEFINE INK_BLUE 4
#DEFINE INK_MAGENTA 5
#DEFINE INK_CYAN 6
#DEFINE INK_WHITE 7


#DEFINE ATTRIBUTE_COLUMN_COUNT 2

#DEFINE KEY_UP_ARROW 156
#DEFINE KEY_DOWN_ARROW 180
#DEFINE KEY_LEFT_ARROW 172
#DEFINE KEY_RIGHT_ARROW 188
#DEFINE KEY_SPACE 132
#DEFINE KEY_Q 177
#DEFINE KEY_PRESS_NONE 56
#DEFINE KEY_PLUS 191
#DEFINE KEY_MINUS 155
#DEFINE KEY_LESS_THAN 140
#DEFINE KEY_GREATER_THAN 159
#DEFINE KEY_DELETE 173
#DEFINE KEY_C 186
#DEFINE KEY_V 152
#DEFINE KEY_B 146
#DEFINE KEY_N 136
#DEFINE KEY_S 182
#DEFINE KEY_F 153
#DEFINE KEY_Z 170
#DEFINE KEY_X 176
#DEFINE KEY_D 185
#DEFINE KEY_A 174
#DEFINE KEY_L 143
#DEFINE KEY_P 157
#DEFINE KEY_T 137
#DEFINE KEY_M 130

#DEFINE KEY_1 168
#DEFINE KEY_2 178
#DEFINE KEY_3 184
#DEFINE KEY_4 154
#DEFINE KEY_5 144
#DEFINE KEY_6 138
#DEFINE KEY_7 128
#DEFINE KEY_8 135
#DEFINE KEY_9 139
#DEFINE KEY_0 151


#DEFINE KEY_PRESS_LOOKUP $0208

#DEFINE TRACKER_PLAY_MODE_BAR 0
#DEFINE TRACKER_PLAY_MODE_SONG 1


#DEFINE ASCII_SPACE 32
#DEFINE ASCII_MINUS 45

#DEFINE PARAMS_0 $02E0
#DEFINE PARAMS_1 $02E1
#DEFINE PARAMS_2 $02E2
#DEFINE PARAMS_3 $02E3
#DEFINE PARAMS_4 $02E4
#DEFINE PARAMS_5 $02E5
#DEFINE PARAMS_6 $02E6
#DEFINE PARAMS_7 $02E7

#DEFINE COPY_MUSIC_BUFFER_START $9000; // music will be copied here for load and save then copied to where it's needed
#DEFINE COPY_MUSIC_BUFFER_BYTE_COUNT $300


#DEFINE ROM_CHECK_ADDR $EDAD; Contains 49 on Atmos and 32 on oric 1
#DEFINE ROM_CHECK_ATMOS 49;

#DEFINE INTSL_ATMOS $024A ; Return from interrupt handler (normally RTI)
#DEFINE INTSL_ORIC1 $0230 ;

#DEFINE TRACKER_STEP_LENGTH 12 ;// number of times interrupts handler should be called before advancing to the next step



#DEFINE PLAYER_DIRECTION_LEFT 0;
#DEFINE PLAYER_DIRECTION_RIGHT 1;
#DEFINE PLAYER_DIRECTION_UP 2;
#DEFINE PLAYER_DIRECTION_DOWN 3;

#DEFINE PLAYER_STATUS_BOTH_ALIVE 0
#DEFINE PLAYER_STATUS_DEAD_PLAYER_1 1
#DEFINE PLAYER_STATUS_DEAD_PLAYER_2 2

#DEFINE PLAYER_1_START_X 85;
#DEFINE PLAYER_1_START_Y 35;

#DEFINE PLAYER_2_START_X 170;
#DEFINE PLAYER_2_START_Y 44;


#DEFINE SIDE_BY_SIDE_SPLITTER_LEFT_CHAR_CODE 121 
#DEFINE SIDE_BY_SIDE_SPLITTER_RIGHT_CHAR_CODE 122

#DEFINE MAX_NON_FATAL_CHAR_CODE 113
#DEFINE BRICK_WALL_CHAR_CODE 114
#DEFINE PLAYER1_SEGEMENT_CHAR_CODE 115 ;(with 116 and 117 as animation)
#DEFINE PLAYER2_SEGEMENT_CHAR_CODE 118 ;(with 119 and 120 as animation)

#DEFINE POSSIBLE_DIRECTION_NONE 0
#DEFINE POSSIBLE_DIRECTION_LEFT 1
#DEFINE POSSIBLE_DIRECTION_RIGHT 2
#DEFINE POSSIBLE_DIRECTION_UP 1
#DEFINE POSSIBLE_DIRECTION_DOWN 2
#DEFINE POSSIBLE_DIRECTION_BOTH 3


#DEFINE DISPLAY_MODE_FULLSCREEN 0
#DEFINE DISPLAY_MODE_SIDE_BY_SIDE 1
#DEFINE DISPLAY_MODE_TOP_TO_BOTTOM 2


#DEFINE FULLSCREEN_TEXT_FIRST_COLUMN 2
#DEFINE FULLSCREEN_TEXT_LAST_COLUMN 39
#DEFINE FULLSCREEN_TEXT_MAZE_OFFSET_X 37 ; First 2 columns on screen are for text and paper attributes
#DEFINE FULLSCREEN_TEXT_LAST_LINE 26
#DEFINE FULLSCREEN_TEXT_X_WRAP 1
#DEFINE FULLSCREEN_TEXT_Y_WRAP 0
#DEFINE FULLSCREEN_MAZE_X 67
#DEFINE FULLSCREEN_MAZE_Y 22
#DEFINE FULL_SCREEN_SCROLL_LEFT_MAZE_X_THRESHOLD 238; when moving left maze will not scroll if near right edge
#DEFINE FULL_SCREEN_SCROLL_RIGHT_MAZE_X_THRESHOLD 18; when moving right maze will not scroll if near left edge
#DEFINE FULL_SCREEN_SCROLL_RIGHT_MAX_MAZE_X 217;
#DEFINE FULL_SCREEN_SCROLL_UP_MAZE_Y_THRESHOLD 68
#DEFINE FULL_SCREEN_SCROLL_DOWN_MAX_MAZE_Y 13;
#DEFINE FULL_SCREEN_SCROLL_DOWN_MAZE_Y_THRESHOLD 53


#DEFINE TOPSCREEN_TEXT_FIRST_COLUMN 2
#DEFINE TOPSCREEN_TEXT_LAST_COLUMN 39
#DEFINE TOPSCREEN_TEXT_MAZE_OFFSET_X 37 ; First 2 columns on screen are for text and paper attributes
#DEFINE TOPSCREEN_TEXT_LAST_LINE 11
#DEFINE TOPSCREEN_TEXT_X_WRAP 1
#DEFINE TOPSCREEN_TEXT_Y_WRAP 0
#DEFINE TOPSCREEN_MAZE_X 67
#DEFINE TOPSCREEN_MAZE_Y 29
#DEFINE TOP_SCREEN_SCROLL_LEFT_MAZE_X_THRESHOLD 238; when moving left maze will not scroll if near right edge
#DEFINE TOP_SCREEN_SCROLL_RIGHT_MAZE_X_THRESHOLD 18; when moving right maze will not scroll if near left edge
#DEFINE TOP_SCREEN_SCROLL_RIGHT_MAX_MAZE_X 217;
#DEFINE TOP_SCREEN_SCROLL_UP_MAZE_Y_THRESHOLD 74
#DEFINE TOP_SCREEN_SCROLL_DOWN_MAX_MAZE_Y 5;
#DEFINE TOP_SCREEN_SCROLL_DOWN_MAZE_Y_THRESHOLD 68


#DEFINE LEFT_SCREEN_TEXT_FIRST_COLUMN 2
#DEFINE LEFT_SCREEN_TEXT_LAST_COLUMN 19
#DEFINE LEFT_SCREEN_TEXT_MAZE_OFFSET_X 17 ; First 2 columns on screen are for text and paper attributes
#DEFINE LEFT_SCREEN_TEXT_LAST_LINE 26
#DEFINE LEFT_SCREEN_TEXT_X_WRAP 1
#DEFINE LEFT_SCREEN_TEXT_Y_WRAP 0
#DEFINE LEFT_SCREEN_MAZE_X 76
#DEFINE LEFT_SCREEN_MAZE_Y 22
#DEFINE LEFT_SCREEN_MAX_MAZE_X 237 ;(256 - NUMBER OF COLUMNS TO RENDER)
#DEFINE LEFT_SCREEN_SCROLL_LEFT_MAZE_X_THRESHOLD 247
#DEFINE LEFT_SCREEN_SCROLL_RIGHT_MAZE_X_THRESHOLD 9; when moving right maze will not scroll if near left edge
#DEFINE LEFT_SCREEN_SCROLL_RIGHT_MAX_MAZE_X 237;
#DEFINE LEFT_SCREEN_SCROLL_UP_MAZE_Y_THRESHOLD 68
#DEFINE LEFT_SCREEN_SCROLL_DOWN_MAX_MAZE_Y 13;
#DEFINE LEFT_SCREEN_SCROLL_DOWN_MAZE_Y_THRESHOLD 53

#DEFINE RIGHT_SCREEN_TEXT_FIRST_COLUMN 21
#DEFINE RIGHT_SCREEN_TEXT_LAST_COLUMN 39
#DEFINE RIGHT_SCREEN_TEXT_MAZE_OFFSET_X 17 ; First 2 columns on screen are for text and paper attributes
#DEFINE RIGHT_SCREEN_TEXT_LAST_LINE 26
#DEFINE RIGHT_SCREEN_TEXT_X_WRAP 21
#DEFINE RIGHT_SCREEN_TEXT_Y_WRAP 0
#DEFINE RIGHT_SCREEN_MAZE_X 161
#DEFINE RIGHT_SCREEN_MAZE_Y 22
#DEFINE RIGHT_SCREEN_MAX_MAZE_X 237 ;(256 - NUMBER OF COLUMNS TO RENDER)

#DEFINE RIGHT_SCREEN_SCROLL_LEFT_MAZE_X_THRESHOLD 247
#DEFINE RIGHT_SCREEN_SCROLL_RIGHT_MAZE_X_THRESHOLD 9; when moving right maze will not scroll if near left edge
#DEFINE RIGHT_SCREEN_SCROLL_RIGHT_MAX_MAZE_X 237;
#DEFINE RIGHT_SCREEN_SCROLL_UP_MAZE_Y_THRESHOLD 68
#DEFINE RIGHT_SCREEN_SCROLL_DOWN_MAX_MAZE_Y 13;
#DEFINE RIGHT_SCREEN_SCROLL_DOWN_MAZE_Y_THRESHOLD 53


#DEFINE OFFSCREEN_LAST_COLUMN 254
#DEFINE OFFSCREEN_LAST_ROW 80

#DEFINE ASCII_SPACE 32

#DEFINE GAME_MODE_RUNNING  0
#DEFINE GAME_MODE_WAITING  1
