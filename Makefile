#NO_LIB=1

SRC=vars.s define.s main.s utils.s maze_procs.s screen_render.s movement.s computer_player.s spranimation.s keyboard.s fourbar.s tracker_interrupt.s tracker_data.s messages.s spr.s lookup.s maze_data.s
BIN=scroll
OBJ=$(SRC:.s=.o)

include ../../rules.mk

all: $(SRC) $(BIN)




