
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

_line_no .dsb 1

_gKey .dsb 1

_music_octave .dsb 1
_music_note .dsb 1
_music_vol .dsb 1
_noise_pitch .dsb 1
_music_data_temp .dsb 1
_music_info_byte_addr
_music_info_byte_lo .dsb 1
_music_info_byte_hi .dsb 1
_tracker_screen_line .dsb 1
_tracker_step_line .dsb 1
_first_visible_tracker_step_line .dsb 1
_tracker_play_mode .dsb 1
_tracker_last_step .dsb 1

_tracker_bar_index .dsb 1
_tracker_bar_step_index .dsb 1

_tracker_selected_col_index .dsb 1
_tracker_selected_row_index .dsb 1

_hi_nibble .dsb 1
_lo_nibble .dsb 1

_last_key .dsb 1

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
_player1_maze_x .dsb 1
_player1_maze_y .dsb 1

_player2_x .dsb 1
_player2_y .dsb 1
_player2_direction .dsb 1
_player2_maze_x .dsb 1
_player2_maze_y .dsb 1

_maze_line_start
_maze_line_start_lo .dsb 1
_maze_line_start_hi .dsb 1
_maze_left .dsb 1
_maze_top .dsb 1
_maze_right .dsb 1
_maze_byte .dsb 1
_maze_x_tmp .dsb 1
_maze_y_tmp .dsb 1

_screen_render_right .dsb 1
_screen_render_bottom .dsb 1
_maze_render_offset_x .dsb 1
_screen_render_x_wrap .dsb 1 ; the value x must hit to go to the previous line
_screen_render_y_wrap .dsb 1 ; the value y must be for render complete


_scroll_left_maze_x_threshold .dsb 1
_scroll_right_maze_x_threshold .dsb 1   
_scroll_right_max_maze_x .dsb 1
_scroll_up_maze_y_threshold .dsb 1
_scroll_down_maze_y_threshold .dsb 1
_scroll_down_max_maze_y .dsb 1


_display_mode .dsb 1

_possible_directions .dsb 1

_player_animation_index .dsb 1


_plot_ch_x .dsb 1
_plot_ch_y .dsb 1
_plot_ascii .dsb 1
_line_start
_line_start_lo .dsb 1
_line_start_hi .dsb 1





_zp_end_


.text