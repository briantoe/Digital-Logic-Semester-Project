# DoomTeam

## Style

### Files

* Source files go in `/src`.

* All important modules should have a test module in `/src/test`.

* Each module should belong to a single file.

* The file name should be the same as the module name.

* Modules that are built from smaller modules should be collected in its own
directory (such as the modules in `/src/add`).

### Naming

* File names, module names, and unit names should use `snake_case` with lower
case lettering.

* Names should be short but intuitive.

* Files for test modules should start with `test_` followed by the module being
tested.

### Code

* Modules that operate asynchronously should not use registers.

* Outputs should come before inputs in module ports. The clock should always
come first when needed.

* Try to stick to using the gate modules `and, or, xor, etc.`, rather than
behavioral operators.

* Parameters should be defined in all caps.

* Test modules should use `$monitor` to output results, and the output should
be prefaced with the name of the module being tested followed by a colon (such
as `add: ...`).

* Ports for a module should not have their type declared in the module
declaration line. Instead, their type declaration should follow immediately
after.

```verilog
module name (clk, out, in);
input clk;

output out;
input in;
```

### Formatting

* Avoid any trailing whitespace at the end of lines.
* Make sure your files use Unix style newlines.
* Use two spaces for tabs.

### Makefile

* Modules that are within their own directory need to be added to the
`LIB_DIRS` variable:

```
LIB_DIRS += ${SRC_DIR}/<your module directory>
```

* The test module needs to be defined as its own variable:

```
ADD_TEST = ${TEST_DIR}/test_add.v
```

* A build rule needs to be defined for your module:

```
add:
    $(call compile, ${ADD_TEST})
```

* Finally, add the rule you defined to the requirements for `all`.

## Building

To build the project, first run `./configure`, then use `make`. Use
`./configure -h` for available options.

## Language

*DoomScript* is a rough assembly language used to generate text files that can
be used to program the verilog ALU.

The Python used to parse the language requires
[PLY](https://www.dabeaz.com/ply/ply.html) to run.  You can install it using
`pip`.

To compile your script, use `lang/parse.py`:
```bash
$ python parse.py example.doom
```

### Syntax

The syntax for *DoomScript* follows a format similar to MIPS but with a naming
convention more along the lines of x86 assembly. Source files are made up of
instruction statements that follow the grammatical rule:
```
<instruction> <arg 1>, <arg 2>, <arg 2>
```
Where an argument can either be a register, a literal, or sometimes a
reference.

Comments are denoted by a leading `#`.

### Registers

Registers are denoted by `%` as a prefix. The available registers are

* `%ax`: Variable register.
* `%bx`: Variable register.
* `%cx`: Variable register.
* `%dx`: Variable register.
* `%ac`: Accumulator.
* `%bp`: Base pointer.
* `%hi`: Multiplication high-bit output.
* `%0`: Zero constant.
* `%1`: System call identifier.
* `%2`: System call argument.
* `%3`: System call argument.
* `%4`: Return address.
* `%pc`: Program counter.

### Literals

Literals are prefixed with `$` and can represent 16-bit numbers. Though keep in
mind that using a literal does require additional instructions. Namely 8-bit
numbers require one additional instruction under the hood, while 16-bit numbers
will require two.

### Labels and References

References are special kinds of literal values that represent a location in the
program's execution.  They are prefixed with `.` and require an associated
label in order to function. A label is defined by `<identifier>:` on a single
line and marks that location in the instruction list. References are used for
jump calls and function calls.

The label `MAIN` is required to denote the starting point of the program.

Additionally, if a number is placed following the colon of a label declaration,
then the label will represent that number rather than the program counter.

### Instructions

The available instruction set is as follows:

* `nop`: Do nothing.
* `add`: Add.
* `sub`: Subtract.
* `mul`: Multiply.
* `div`: Divide.
* `or`: Logical or.
* `and`: Logical and.
* `not`: Logical not.
* `xor`: Logical xor.
* `cmp`: Compare two signed numbers (coded by -1, 0, 1).
* `jze`: Jump if zero.
* `jnz`: Jump if not zero.
* `call`: Jump to a label. Setting `%4` to the appropriate return address.
* `syscall`: System call.

Instructions all take at least one argument. For instructions that take more
than one, the first argument almost always identifies a destination for the
result of an operation (the exception being `jnz` and `sys`). Therefore, a call
like `mov %bx %ax` will store the value in register `%bx` in register `%ax`.

System calls are essentially the way in which the assembly will call anything
that we want to implement using behavioral verilog modules.  These include
things like loading a value from memory, saving a value in memory, halting the
program, and printing to the screen. The type of system call is designated in
the `%1` register.

### Example

```
MSG_PREFIX: "GCD = "
A: 1071
B: 462

GCD:
  or %ax, %1, %0
  or %bx, %2, %0
L0:
  cmp %cx, %ax, %bx
  xor %dx, %cx, -$1
  jnz .L1, %dx
  or %1, %bx, %0
  or %2, %ax, %0
  jze .GCD, %0 # recurse when %ax < %bx
L1:
  sub %ax, %ax, %bx
  jnz .L0, %ax
  or %3, %bx, %0
  jze %4, %0 # return %bx if %ax == 0

MAIN:
  or %1, .A, %0
  or %2, .B, %0
  call .GCD
  or %ax, %3, %0 # store return value

  or %1, $5, %0
  or %2, .MSG_PREFIX, %0
  syscall # print string

  or %1, $3, %0
  or %2, %ax, %0
  syscall # print integer

  or %1, $4, %0
  or %2, $10, %0 # newline
  syscall # print character

  or %1, %0, %0
  syscall # halt
```
