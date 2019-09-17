VERILOG=iverilog
BIN_DIR=bin
SRC_DIR=src
LIB_DIRS=${SRC_DIR}
TEST_DIR=${SRC_DIR}/test

LIB_DIRS += ${SRC_DIR}/adder
ADDER_TEST=${TEST_DIR}/test_adder.v

MUX_TEST=${TEST_DIR}/test_mux.v

SHIFT_TEST=${TEST_DIR}/test_shift.v

define compile
  ${VERILOG} $(addprefix -y, ${LIB_DIRS}) -o ${BIN_DIR}/$(notdir $(basename $1))$1
endef

all: bin adder mux shift

adder:
	$(call compile, ${ADDER_TEST})

mux:
	$(call compile, ${MUX_TEST})

shift:
	$(call compile, ${SHIFT_TEST})

bin:
	[[ -d ${BIN_DIR} ]] || mkdir ${BIN_DIR}
