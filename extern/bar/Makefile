LIB := bar
SRC := ${LIB}.cpp
TARGET := lib${LIB}.a
OBJ := lib${LIB}.o

CXX := g++
STATIC := ar rcs

all: ${TARGET}

${TARGET} : ${OBJ}
	@echo [G]generating static library $@
	${STATIC} $@ $<

${OBJ} : ${SRC}
	@echo [C]ompiling $<
	${CXX} -c $< -o $@

clean:
	rm ${OBJ}
