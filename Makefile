#NO_LIB=1

SRC=vars.s define.s main.s maze_procs.s screen_render.s movement.s computer_player.s utils.s rom_independent_sound.s tracker_interrupt.s spranimation.s spr.s tracker_data.s messages.s lookup.s maze_data.s
BIN=scroll
OBJ=$(SRC:.s=.o)

include ../../rules.mk

all: $(SRC) $(BIN)




