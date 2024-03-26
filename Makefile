#NO_LIB=1

SRC=vars.s define.s ./SoundEffects/sound_effect_defines.s main.s maze_procs.s screen_render.s trail_memory.s ./Keyboard/whole_keyboard.s joystick_ijk.s collision_info.s keyboard_mapper.s setScreenMetrics.s movement.s  ./SoundEffects/sound_effects.s computer_player.s utils.s rom_independent_sound.s tracker_interrupt.s spranimation.s spr.s tracker_data.s messages.s lookup.s ./Keyboard/keyboard_mapper_data.s maze_data.s 
BIN=scroll
OBJ=$(SRC:.s=.o)

include ../../rules.mk

all: $(SRC) $(BIN)




