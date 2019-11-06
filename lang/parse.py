from lex import lexer, instruction, register
from sys import argv

binary_instructions = (
    'ADD',
    'MUL',
    'DIV',
    'OR',
    'AND',
    'XOR',
    'CMP',
)

unary_instructions = (
    'MOV',
    'NOT',
    'JNZ',
)

meta_instructions = (
    'JMP',
)

special_instructions = (
    'NOP',
    'SYS',
)

arg_types = (
    'REGISTER',
    'IMMEDIATE',
    'REFERENCE',
)

pc = 0
labels = {}
ireg = 'si'
debug = False
output = 'doom.mem'
token = None

def parse_error(sym, msg):
    print(f'syntax error (line {token.lexer.lineno}): {sym}: ' + msg)
    exit(1)

def lex():
    global token
    if token and debug:
        print(f'{token.type:9}: {token.value}')
    token = lexer.token()

def document():
    global pc
    if not token:
        return False
    if token.type == 'NEWLINE':
        lex()
    while token:
        while label():
            pass
        stmt()
        pc += 1
    return True

def label():
    if token.type != 'LABEL':
        return False
    name = token.value
    lex()
    if token.type == 'VALUE':
        labels.update({name: token.value})
        lex()
    else:
        labels.update({name: pc})
    if token.type != 'NEWLINE':
        parse_error('label', 'malformed label declaration. expected a newline')
    lex()
    return True

def stmt():
    if not token.type in instruction:
        parse_error('statement', f'expected instruction, got token of type {token.type}')
    if not (
        binary_stmt()
        or unary_stmt()
        or meta_stmt()
        or special_stmt()
    ):
        parse_error('statement', f'instruction `{token.value.lower()}` not implemented')
    if token.type != 'NEWLINE':
        parse_error('statement', 'malformed statement. expected a newline')
    output.write('\n')
    lex()
    return True

def special_stmt():
    if not token.type in special_instructions:
        return False
    ins = token.type
    ins_code = token.value
    lex()
    if token.type == 'COMMA':
        parse_error(f'special statement ({ins.lower()})', 'unexpected comma')
    if arg():
        parse_error(f'special statement ({ins.lower()})', f'unexpected argument `{token.name}`')
    output.write(ins_code)
    output.write(12*'0')
    output.write(' // ' + ins)
    return True

def binary_stmt():
    if not token.type in binary_instructions:
        return False
    ins = token.type
    ins_code = token.value
    arg_code = ''
    lex()
    if token.type == 'COMMA':
        parse_error(f'binary statement ({ins.lower()})', 'unexpected comma')
    for i in range(3):
        if not arg():
            if token.type != 'NEWLINE':
                parse_error(f'binary statement ({ins.lower()})', f'unknown argument `{token.name}`')
            else:
                token.lexer.lineno -= 1
                parse_error(f'binary statement ({ins.lower()})', 'missing argument')
        arg_code += token.value
        lex()
        if token.type == 'COMMA':
            lex()
            if i == 2 and arg():
                parse_error(f'binary statement ({ins.lower()})', f'trailing argument `{token.name}`')
        elif i != 2:
            parse_error(f'binary statement ({ins.lower()})', 'malformed argument. expected comma')
    output.write(ins_code)
    output.write(arg_code)
    output.write(' // ' + ins)
    return True

def unary_stmt():
    if not token.type in unary_instructions:
        return False
    ins = token.type
    ins_code = token.value
    arg_code = ''
    lex()
    if token.type == 'COMMA':
        parse_error(f'unary statement ({ins.lower()})', 'unexpected comma')
    for i in range(2):
        if not arg():
            if token.type != 'NEWLINE':
                parse_error(f'unary statement ({ins.lower()})', f'unknown argument `{token.name}`')
            else:
                token.lexer.lineno -= 1
                parse_error(f'unary statement ({ins.lower()})', 'missing argument')
        arg_code += token.value
        lex()
        if token.type == 'COMMA':
            lex()
            if i == 1 and arg():
                parse_error(f'unary statement ({ins.lower()})', f'trailing argument `{token.name}`')
        elif i != 1:
            parse_error(f'unary statement ({ins.lower()})', 'malformed argument. expected comma')
    output.write(ins_code)
    if ins == 'JNZ':
        output.write(register['pc'])
        output.write(arg_code)
    else:
        output.write(arg_code)
        output.write(register['0'])
    output.write(' // ' + ins)
    return True

def meta_stmt():
    if not token.type in meta_instructions:
        return False
    ins = token.type
    ins_code = token.value
    lex()
    if token.type == 'COMMA':
        parse_error(f'meta statement ({ins.lower()})', 'unexpected comma')
    if not arg():
        parse_error(f'meta statement ({ins.lower()})', 'missing argument')
    arg_code = token.value
    lex()
    if token.type == 'COMMA':
        lex()
        if arg():
            parse_error(f'meta statement ({ins.lower()})', f'trailing argument `{token.name}`')
        else:
            parse_error(f'meta statement ({ins.lower()})', 'unexpected comma')
    output.write(ins_code)
    if ins == 'JMP':
        output.write(register['pc'])
        output.write(arg_code)
        output.write(register['0'])
    else:
        output.write(arg_code)
        output.write(2*register['0'])
    output.write(' // ' + ins)
    return True

def arg():
    'NOTE: does not call lex()'
    global ireg
    if not token.type in arg_types:
        return False
    if token.type == 'IMMEDIATE':
        load_value(ireg, token.value)
        token.value = register[ireg]
        ireg = 'di' if ireg == 'si' else 'si'
    elif token.type == 'REFERENCE':
        if not token.value in labels:
            parse_error('argument', f'unknown label `{token.value}`')
        load_value(ireg, labels[token.value])
        token.value = register[ireg]
        ireg = 'di' if ireg == 'si' else 'si'
    return True

def load_value(reg, value):
    global pc
    binary = bin(value)[2:]
    if len(binary) > 16:
        parse_error('immediate', 'value exceeds 16-bit maximum')
    upper = (len(binary) > 8)
    binary = '0'*(16 - len(binary)) + binary

    output.write(instruction['LMOV'])
    output.write(register[reg])
    output.write(binary[8:])
    output.write(' // LMOV\n')
    pc += 1

    if upper:
        output.write(instruction['UMOV'])
        output.write(register[reg])
        output.write(binary[:8])
        output.write(' // UMOV\n')
        pc += 1

if __name__ == '__main__':
    if len(argv) == 1:
        print(f'{argv[0]}: missing input file')
        exit(1)
    if '--debug' in argv[2:]:
        debug = True
    if '-o' in argv[2:]:
        i = argv.index('-o')
        if (i+1) == len(argv):
            print(f'{argv[0]}: missing output filename')
            exit(1)
        output = argv[i+1]
    output = open(output, 'w')
    lexer.input(open(argv[1]).read())
    lex()
    document()
