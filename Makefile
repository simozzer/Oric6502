#NO_LIB=1

SRC=main.s spr.s lookup.s vars.s
BIN=scroll
OBJ=$(SRC:.s=.o)

include ../../rules.mk

all: $(SRC) $(BIN)




