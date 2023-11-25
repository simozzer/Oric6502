#define _getKey		$EB78

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

#DEFINE MAZE_COLUMN_COUNT 255
#DEFINE MAZE_ROW_COUNT 80

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

#DEFINE KEY_PRESS_LOOKUP $0208

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

//todo .. check values
#DEFINE RIGHT_SCREEN_SCROLL_LEFT_MAZE_X_THRESHOLD 247
#DEFINE RIGHT_SCREEN_SCROLL_RIGHT_MAZE_X_THRESHOLD 9; when moving right maze will not scroll if near left edge
#DEFINE RIGHT_SCREEN_SCROLL_RIGHT_MAX_MAZE_X 237;
#DEFINE RIGHT_SCREEN_SCROLL_UP_MAZE_Y_THRESHOLD 68
#DEFINE RIGHT_SCREEN_SCROLL_DOWN_MAX_MAZE_Y 13;
#DEFINE RIGHT_SCREEN_SCROLL_DOWN_MAZE_Y_THRESHOLD 53


#DEFINE OFFSCREEN_LAST_COLUMN 254
#DEFINE OFFSCREEN_LAST_ROW 80

#DEFINE PLAYER_DIRECTION_LEFT 0;
#DEFINE PLAYER_DIRECTION_RIGHT 1;
#DEFINE PLAYER_DIRECTION_UP 2;
#DEFINE PLAYER_DIRECTION_DOWN 3;

#DEFINE PLAYER_STATUS_BOTH_ALIVE 0
#DEFINE PLAYER_STATUS_DEAD_PLAYER_1 1
#DEFINE PLAYER_STATUS_DEAD_PLAYER_2 2

#DEFINE PLAYER_1_START_X 85;
#DEFINE PLAYER_1_START_Y 39;

#DEFINE PLAYER_2_START_X 170;
#DEFINE PLAYER_2_START_Y 39;

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

#DEFINE TRACKER_COL_NOTE_CH_1 4
#DEFINE TRACKER_COL_OCT_CH_1 8
#DEFINE TRACKER_COL_VOL_CH_1 11
#DEFINE TRACKER_COL_NOTE_CH_2 16
#DEFINE TRACKER_COL_OCT_CH_2 20
#DEFINE TRACKER_COL_VOL_CH_2 23
#DEFINE TRACKER_COL_NOTE_CH_3 28
#DEFINE TRACKER_COL_OCT_CH_3 32
#DEFINE TRACKER_COL_VOL_CH_3 35

#DEFINE TRACKER_COL_INDEX_NOTE_CH1 0
#DEFINE TRACKER_COL_INDEX_OCT_CH1 1
#DEFINE TRACKER_COL_INDEX_VOL_CH1 2
#DEFINE TRACKER_COL_INDEX_NOTE_CH2 3
#DEFINE TRACKER_COL_INDEX_OCT_CH2 4
#DEFINE TRACKER_COL_INDEX_VOL_CH2 5
#DEFINE TRACKER_COL_INDEX_NOTE_CH3 6
#DEFINE TRACKER_COL_INDEX_OCT_CH3 7
#DEFINE TRACKER_COL_INDEX_VOL_CH3 8

#DEFINE ASCII_SPACE 32

#DEFINE PARAMS_0 $02E0
#DEFINE PARAMS_1 $02E1
#DEFINE PARAMS_2 $02E2
#DEFINE PARAMS_3 $02E3
#DEFINE PARAMS_4 $02E4
#DEFINE PARAMS_5 $02E5
#DEFINE PARAMS_6 $02E6
#DEFINE PARAMS_7 $02E7

#DEFINE MUSIC_ATMOS $fc18
#DEFINE PLAY_ATMOS $FBd0

#DEFINE INTSL $024A ; Retrun from interupt handler (normally RTI)

#DEFINE TRACKER_STEP_LENGTH 10 ;// number of times interrupts handler should be called before advancing to the next step
