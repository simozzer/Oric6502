
    .zero

    *= $50

_zp_start_


_copy_mem_src
_copy_mem_src_lo .dsb 1
_copy_mem_src_hi .dsb 1
_copy_mem_dest
_copy_mem_dest_lo .dsb 1
_copy_mem_dest_hi .dsb 1
_copy_mem_count
_copy_mem_count_lo .dsb 1
_copy_mem_count_hi .dsb 1

_music_info_byte_addr
_music_info_byte_lo .dsb 1
_music_info_byte_hi .dsb 1

_tracker_play_mode .dsb 1
_tracker_last_step .dsb 1

_tracker_bar_index .dsb 1
_tracker_bar_step_index .dsb 1

_last_key .dsb 1


temp_param_0    .dsb 1
temp_param_1    .dsb 1
temp_param_2    .dsb 1
temp_param_3    .dsb 1
temp_result     .dsb 1

_tracker_step_index .dsb 1; The index of the note to be played
_tracker_step_cycles_remaining .dsb 1; Decremented each time the interrupt is called.
_tracker_step_length .dsb 1; Length of each 16th note (speed of the tune).
_tracker_step_half_length .dsb 1

_tracker_song_bar_lookup_index .dsb 1

_playback_music_info_byte_addr; the pointer for the information for the note to be played
_playback_music_info_byte_lo .dsb 1
_playback_music_info_byte_hi .dsb 1


_player1_x .dsb 1
_player1_y .dsb 1
_player1_direction .dsb 1

_player_status .dsb 1


_player2_x .dsb 1
_player2_y .dsb 1
_player2_direction .dsb 1


_maze_line_start
_maze_line_start_lo .dsb 1
_maze_line_start_hi .dsb 1
_maze_left .dsb 1
_maze_top .dsb 1
_maze_byte .dsb 1

_display_mode .dsb 1
_last_display_mode .dsb 1

_game_mode .dsb 1

_possible_directions .dsb 1

_player_animation_index .dsb 1

_plot_ch_x .dsb 1
_plot_ch_y .dsb 1
_plot_ascii .dsb 1
_line_start
_line_start_lo .dsb 1
_line_start_hi .dsb 1


trail_data_player_1
trail_data_low_player_1 .dsb 1
trail_data_hi_player_1 .dsb 1
trail_index_player_1 .dsb 1
trail_index_player_2 .dsb 1
trailItemX .byt 1
trailItemY .byt 1
trailChar .byt 1

; <BEGIN KEYMAP WARNING>
; THESE KEY MAPPINGS ARE IN A FIXED ORDER TO MAKE WRITING
; THE KEY EDITOR EASIER.. DO NOT MODIFY
keyboardRows
key_up_player1_row .dsb 1
key_down_player1_row .dsb 1
key_left_player1_row .dsb 1
key_right_player1_row .dsb 1
key_up_player2_row .dsb 1
key_down_player2_row .dsb 1
key_left_player2_row .dsb 1
key_right_player2_row .dsb 1

keyboardColMasks
key_up_player1_col_mask .dsb 1
key_down_player1_col_mask .dsb 1
key_left_player1_col_mask .dsb 1
key_right_player1_col_mask .dsb 1
key_up_player2_col_mask .dsb 1
key_down_player2_col_mask .dsb 1
key_left_player2_col_mask .dsb 1
key_right_player2_col_mask .dsb 1
;<END KEYMAP WARNING>


screen_area_width .byt 0
screen_area_height .byt 0
screen_area_half_width .byt 0
screen_area_half_height .byt 0
screen_area_left .byt 0
screen_area_top .byt 0
screen_area_x .byt 0
screen_area_y .byt 0
screen_area_last_col .byt 0
screen_area_last_row .byt 0
player_x .byt 0
player_y .byt 0
game_area_top .byt 0
game_area_left .byt 0
temp_value .byt 0
game_area_x .byt 0
game_area_y .byt 0


rand_low		.byt 1		;// Random number generator, low part
rand_high		.byt 1		;// Random number generator, high part

player_count .byt 1

; joy_Left .byt 1
; joy_Right .byt 1


_zp_end_

.text

