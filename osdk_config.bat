@ECHO OFF

::
:: Set the build paremeters
::
SET OSDKADDR=$2000
SET OSDKNAME=Scroll
SET OSDKLINK=-B
SET OSDKFILE=vars defines ./SoundEffects/sound_effect_defines main maze_procs screen_render trail_memory ./Keyboard/whole_keyboard joystick_ijk collision_info ./Keyboard/keyboard_mapper setScreenMetrics movement ./ScreenEffects/screen_effects ./SoundEffects/sound_effects computer_player utils rom_independent_sound tracker_interrupt spranimation spr tracker_data messages lookup ./Keyboard/keyboard_mapper_data maze_data   
