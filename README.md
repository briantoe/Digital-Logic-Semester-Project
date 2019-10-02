# DoomTeam

## Style

### Files

* Source files go in `/src`.
* All important modules should have a test module in `/src/test`.
* Each module should belong to a single file.
* The file name should be the same as the module name.
* Modules that are built from smaller modules should be collected in it's own directory (such as the modules in `/src/add`).

### Naming

* File names, module names, and unit names should use `snake_case` with lower case lettering.
* Names should be short but intuitive.
* Files for test modules should start with `test_` followed by the module being tested.

### Code

* Modules that operate asynchronously should not use registers.
* Outputs should come before inputs in module ports. The clock should always come first when needed.
* Try to stick to using the gate modules `and, or, xor, etc.`, rather than behavioral operators.
* Parameters should be defined in all caps.
* Test modules should use `$monitor` to output results, and the output should be prefaced with the name of the module being tested followed by a colon (such as `add: ...`).
* Ports for a module should not have their type declared in the module declaration line. Instead, their type declaration should follow immediately after.
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

* Modules that are within their own directory need to be added to the `LIB_DIRS` variable:
```
LIB_DIRS += ${SRC_DIR}/<your module directory>
```
* The test module needs to be defined as it's own variable:
```
ADD_TEST = ${TEST_DIR}/test_add.v
```
* A build rule needs to be defined for your module:
```
add:
    $(call compile, ${ADD_TEST})
```
* Finally, add the rule you defined to the requirements for `all`.

## Language

*DoomScript* is a rough assembly language used to generate text files that can be used to program the verilog ALU.

The Python used to parse the language requires [PLY](https://www.dabeaz.com/ply/ply.html) to run.
You can install it using `pip`.

To compile your script, use `lang/parse.py`:
```bash
$ ./parse.py example.doom
```

[TODO] Add language syntax.
