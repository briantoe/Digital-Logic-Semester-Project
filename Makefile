VERILOG=iverilog
BIN_DIR=bin
SRC_DIR=src
LIB_DIRS=${SRC_DIR}
TEST_DIR=${SRC_DIR}/test

LIB_DIRS += ${SRC_DIR}/add
ADD_TEST=${TEST_DIR}/test_add.v
SUB_TEST=${TEST_DIR}/test_sub.v

MUX_TEST=${TEST_DIR}/test_mux.v

SHIFT_TEST=${TEST_DIR}/test_shift.v

define compile
  ${VERILOG} $(addprefix -y, ${LIB_DIRS}) -o ${BIN_DIR}/$(notdir $(basename $1))$1
endef

all: bin add mux shift

add:
	$(call compile, ${ADD_TEST})
	$(call compile, ${SUB_TEST})

mux:
	$(call compile, ${MUX_TEST})

shift:
	$(call compile, ${SHIFT_TEST})

bin:
	[[ -d ${BIN_DIR} ]] || mkdir ${BIN_DIR}
clean: 
	rm -r ${BIN_DIR}/
