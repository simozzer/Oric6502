#NO_LIB=1

SRC=main.s spr.s lookup.s
BIN=game_scroll
OBJ=$(SRC:.s=.o)

include ../../rules.mk

all: $(SRC) $(BIN)




