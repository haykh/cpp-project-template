# # # # # Directories # # # # # # # # # # 
#
ROOT_DIR := $(realpath ${CURDIR})/
# directory for the building
BUILD_DIR := build
# directory for the executable
BIN_DIR := bin

TARGET := main
# static libraries 
LIBRARIES := bar 

SRC_DIR := src

# external header-only libraries
INC_DIR := include
# for static libraries
LIB_DIR := lib
# for source codes of external libraries (either static or dynamic)
EXT_DIR := extern
LDFLAGS := $(LDFALGS) -L${LIB_DIR} $(addprefix -l, $(LIBRARIES)) 

# appending path
# `__` means absolute path will be used
__BUILD_DIR := ${ROOT_DIR}${BUILD_DIR}
__BIN_DIR := ${ROOT_DIR}${BIN_DIR}
__SRC_DIR := ${ROOT_DIR}${SRC_DIR}
__TARGET := ${BIN_DIR}/${TARGET}
# # # # # Settings # # # # # # # # # # # # 
# 
VERBOSE ?= n
DEBUGMODE ?= n

DEFINITIONS := 

ifeq ($(strip ${VERBOSE}), y)
	HIDE = 
else
	HIDE = @
endif

# 3-rd party library configurations
# ...

# # # # # Compiler and flags # # # # # # #  
# 
CXX := g++
LINK := ${CXX}
CXXSTANDARD := -std=c++17
ifeq ($(strip ${DEBUGMODE}), y)
	CONFFLAGS := -O0 -g
	PREPFLAGS := -DDEBUG
else
	CONFFLAGS := -O3 -Ofast
	PREPFLAGS := -DNDEBUG
endif

# warning flags
WARNFLAGS := -Wall -Wextra -pedantic

# custom preprocessor flags
# ... 

CPPFLAGS := $(WARNFLAGS) $(PREPFLAGS) 
CXXFLAGS := $(CXXFLAGS) $(CONFFLAGS)

# # # # # File collection # # # # # # # # # # # 
# 
SRCS := $(shell find ${__SRC_DIR} -name *.cpp -or -name *.c)
OBJS := $(subst ${__SRC_DIR},${__BUILD_DIR},$(SRCS:%=%.o))
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find ${__SRC_DIR} -type d) ${EXT_DIR} ${INC_DIR} ${LIB_DIR}
INCFLAGS := $(addprefix -I,${INC_DIRS})

ALL_OBJS := $(OBJS)

# # # # # Targets # # # # # # # # # # # # # # 
# 
.PHONY: all help default clean 

default : help

help:
	@echo "usage: \`make all [OPTIONS]\`"
	@echo 
	@echo "options:"
	@echo "   DEBUGMODE={y|n}      -- enable/disable debug mode [default: n]"
	@echo "   VERBOSE={y|n}        -- enable/disable verbose compilation mode [default: n]"
	@echo
	@echo "cleanup: \`make clean\`"

# linking the main app
all : ${__TARGET}
	@echo [M]aking $@

${__TARGET} : $(OBJS)
	@echo [L]inking $(notdir $@) from $^
	$(HIDE)${LINK} $(LDFLAGS) $(OBJS) -o $@

# generate compilation rules for all `.o` files
define generateRules
$(1): $(2)
	@echo [C]ompiling $(2)
	$(HIDE)mkdir -p ${BIN_DIR}
	$(HIDE)mkdir -p $(dir $(1))
	$(HIDE)${CXX} ${CXXSTANDARD} $(INCFLAGS) $(DEFINITIONS) $(CPPFLAGS) $(CXXFLAGS) -c $(2) -o $(1)
endef
#$(foreach obj, $(ALL_OBJS), $(eval $(call generateRules, ${obj}, ${ROOT_DIR}$(subst .o,,$(obj)))))
$(foreach obj, $(ALL_OBJS), $(eval $(call generateRules, ${obj}, $(subst ${BUILD_DIR},${SRC_DIR},$(subst .o,,$(obj))))))

clean:
	rm -rf ${BUILD_DIR} ${BIN_DIR}

-include $(DEPS)
