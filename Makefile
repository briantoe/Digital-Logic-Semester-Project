SHELL = /bin/bash

VERILOG=iverilog
BIN_DIR=bin
SRC_DIR=src
LIB_DIRS=${SRC_DIR}
TEST_DIR=${SRC_DIR}/test

LIB_DIRS += ${SRC_DIR}/cmp
LIB_DIRS += ${SRC_DIR}/add
LIB_DIRS += ${SRC_DIR}/mult
LIB_DIRS += ${SRC_DIR}/mux
LIB_DIRS += ${SRC_DIR}/dec
LIB_DIRS += ${SRC_DIR}/dff
LIB_DIRS += ${SRC_DIR}/cpu

ADD_TEST=${TEST_DIR}/test_add.v
SUB_TEST=${TEST_DIR}/test_sub.v
MULT_TEST=${TEST_DIR}/test_mult.v
DEC_TEST=${TEST_DIR}/test_dec.v
MUX_TEST=${TEST_DIR}/test_mux.v
SHIFT_TEST=${TEST_DIR}/test_shift.v
CMP_TEST=${TEST_DIR}/test_cmp.v
DIV_TEST=${TEST_DIR}/test_div.v
DFF_TEST=${TEST_DIR}/test_dff.v
ALU_TEST=${TEST_DIR}/test_alu.v
COUNTER_TEST=${TEST_DIR}/test_counter.v
CPU_TEST=${TEST_DIR}/test_cpu.v

define compile
  ${VERILOG} $(addprefix -y, ${LIB_DIRS}) -o ${BIN_DIR}/$(notdir $(basename $1))$1
endef

all: bin add mult mux shift cmp dec div dff alu counter cpu

add:
	$(call compile, ${ADD_TEST})
	$(call compile, ${SUB_TEST})

mult:
	$(call compile, ${MULT_TEST})

dec:
	$(call compile, ${DEC_TEST})

mux:
	$(call compile, ${MUX_TEST})

shift:
	$(call compile, ${SHIFT_TEST})

cmp:
	$(call compile, ${CMP_TEST})

div:
	$(call compile, ${DIV_TEST})

dff:
	$(call compile, ${DFF_TEST})

alu:
	$(call compile, ${ALU_TEST})
	
counter:
	$(call compile, ${COUNTER_TEST})

cpu:
	$(call compile, ${CPU_TEST})

bin:
	[[ -d ${BIN_DIR} ]] || mkdir ${BIN_DIR}

clean:
	rm -r ${BIN_DIR}/
