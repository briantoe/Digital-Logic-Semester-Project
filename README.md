# doom.v

## About

This repository represents the glorious failed attempt to run a DOOM-clone
using purely structural iVerilog.

In essence, the goal of the project was to use structural VHDL in order to
design a fully programmable, 16-bit CPU and VGA that could be used to render
text-based pseudo-3D graphics to a terminal (imagine the original Wolfenstein
on a graphing calculator).

The CPU and VGA were both successfully implemented; and a rough, but
sufficient, assembly language was designed to compile programs as text-files
containing the binary instructions that iVerilog could read into an array then
feed to the CPU for execution. Most of the modules that perform meaningful
computation (except division) are indeed purely structural as well. The only
behavioural components are those that handle things such as I/O and memory.

In theory, this project as it is actually *could* render pseudo-3D graphics,
but unfortunately, the performance provided by iVerilog proved to be far too
poor to get any meaningful results. If you're interested in trying it out,
be prepared for 0.006 frames per second rendering times. Otherwise, the
example program implementing Euclid's algorithm (see below) has far more
bearable performance, and with debugging on you can see the CPU in action.

## Building

To build the project, first run `./configure`, then use `make`. Use
`./configure -h` for available options.

## Language

*DoomScript* is a rough assembly language used to generate text files that can
be used to program the verilog CPU.

The Python used to parse the language requires
[PLY](https://www.dabeaz.com/ply/ply.html) to run.  You can install it using
`pip`.

To compile your script, use `dscript`:
```bash
$ ./dscript example.doom
```

### Syntax

The syntax for *DoomScript* follows a format similar to MIPS but with a naming
convention more along the lines of x86 assembly. Source files are made up of
instruction statements that follow the grammatical rule:
```
<instruction> <arg 1>, <arg 2>, <arg 3>
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

Labels are markers in the assembly that the assembler uses to store static
data.  Most often this data represents an address to an instruction, but they
can also represent ordinary 16-bit integers and string literals.

References, on the other hand, are the invocation of a label within the
argument list of an assembly instruction.

To define a label, the syntax is as follows:
```
<identifier>: [integer | string]
```
If neither an integer or a string follow the colon, the label is assumed to
represent an instruction address.

To refer to a label using a reference, the prefix `.` is used followed by
the identifier of the label to be referenced.

The label `MAIN` is required to denote the starting point of the program.

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

All instructions except for `syscall` take at least one argument. For
instructions that take more than one, the first argument almost always
identifies a destination for the result of an operation (the exception being
`jnz`, `jze`, and `call` where the first argument identifies the
address to jump to). Therefore, a call like `not %bx %ax` will perform a
logical-not operation on the value in register `%ax` and store the result into
register `%bx`.

System calls are essentially the way in which the assembly will call anything
that we want to implement using behavioral verilog modules.  These include
things like loading a value from memory, saving a value in memory, halting the
program, and printing to the screen. The type of system call is designated in
the `%1` register.

### Example

Following is an example program that implements Euclid's algorithm for finding
the greatest common denominator (GCD) of two integers.

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
