    .zero

    *= $50

_zp_start_

_plot_ch_x .byt 1
_plot_ch_y .byt 1
_plot_ascii .byt 1
_line_start
_line_start_lo .byt 1
_line_start_hi .byt 1

_copy_mem_src
_copy_mem_src_lo .byt 1
_copy_mem_src_hi .byt 1
_copy_mem_dest
_copy_mem_dest_lo .byt 1
_copy_mem_dest_hi .byt 1
_copy_mem_count
_copy_mem_count_lo .byt 1
_copy_mem_count_hi .byt 1

_maze_left .byt 1
_maze_top .byt 1
_maze_byte .byt 1
_bits_to_process .byt 1
_maze_bitmask .byt 1
_maze_x_tmp .byt 1
_maze_y_tmp .byt 1
_maze_line_start
_maze_line_start_lo .byt 1
_maze_line_start_hi .byt 1

_maze_right .byt 1

_player1_x .byt 1
_player1_y .byt 1
_player1_direction .byt 1
_player_status .byt 1
_player1_maze_x .byt 1
_player1_maze_y .byt 1

_player2_x .byt 1
_player2_y .byt 1
_player2_direction .byt 1
_player2_maze_x .byt 1
_player2_maze_y .byt 1


_screen_render_right .byt 1
_screen_render_bottom .byt 1
_maze_render_offset_x .byt 1
_screen_render_x_wrap .byt 1 ; the value x must hit to go to the previous line
_screen_render_y_wrap .byt 1 ; the value y must be for render complete

_scroll_left_maze_x_threshold .byt 1
_scroll_right_maze_x_threshold .byt 1
_scroll_right_max_maze_x .byt 1
_scroll_up_maze_y_threshold .byt 1
_scroll_down_maze_y_threshold .byt 1
_scroll_down_max_maze_y .byt 1

_display_mode .byt 1

_possible_directions .byt 1

_player_animation_index .byt 1

_zp_end_

// Part of code copied from Kong, which was supplied with the OSDK
rand_low		.dsb 1		;// Random number generator, low part
rand_high		.dsb 1		;// Random number generator, high part
b_tmp1          .dsb 1

.text