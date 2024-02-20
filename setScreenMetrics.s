setMetricsForFullScreen
.(
    lda #FULL_SCREEN_WIDTH
    sta screen_area_width
    lda #FULL_SCREEN_HEIGHT
    sta screen_area_height
    lda _player1_x
    sta player_x
    lda _player1_y
    sta player_y
    lda #FULLSCREEN_TEXT_FIRST_COLUMN
    sta screen_area_left
    lda #FULLSCREEN_TEXT_FIRST_ROW
    sta screen_area_top
    rts
.)

setMetricsForLeftScreen
.(
    lda #LEFT_SCREEN_WIDTH
    sta screen_area_width
    lda #LEFT_SCREEN_HEIGHT
    sta screen_area_height
    lda _player1_x
    sta player_x
    lda _player1_y
    sta player_y
    lda #LEFTSCREEN_TEXT_FIRST_COLUMN
    sta screen_area_left
    lda #LEFTSCREEN_TEXT_FIRST_ROW
    sta screen_area_top
    rts
.)

setMetricsForRightScreen
.(
    lda #RIGHT_SCREEN_WIDTH
    sta screen_area_width
    lda #RIGHT_SCREEN_HEIGHT
    sta screen_area_height
    lda _player2_x
    sta player_x
    lda _player2_y
    sta player_y
    lda #RIGHTSCREEN_TEXT_FIRST_COLUMN
    sta screen_area_left
    lda #RIGHTSCREEN_TEXT_FIRST_ROW
    sta screen_area_top
    rts
.)


setMetricsForTopScreen
.(
    lda #TOP_SCREEN_WIDTH
    sta screen_area_width
    lda #TOP_SCREEN_HEIGHT
    sta screen_area_height
    lda _player1_x
    sta player_x
    lda _player1_y
    sta player_y
    lda #TOPSCREEN_TEXT_FIRST_COLUMN
    sta screen_area_left
    lda #TOPSCREEN_TEXT_FIRST_ROW
    sta screen_area_top
    rts
.)

setMetricsForBottomScreen
.(
    lda #BOTTOM_SCREEN_WIDTH
    sta screen_area_width
    lda #BOTTOM_SCREEN_HEIGHT
    sta screen_area_height
    lda _player2_x
    sta player_x
    lda _player2_y
    sta player_y
    lda #BOTTOMSCREEN_TEXT_FIRST_COLUMN
    sta screen_area_left
    lda #BOTTOMSCREEN_TEXT_FIRST_ROW
    sta screen_area_top
    rts
.)
