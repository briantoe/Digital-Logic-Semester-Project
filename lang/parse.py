from lex import lexer, instruction, register
from sys import argv

binary_instructions = (
    'ADD',
    'SUB',
    'MULT',
    'DIV',
    'CMP',
    'OR',
    'AND',
    'XOR',
)

unary_instructions = (
    'SHIFTL',
    'SHIFTR',
    'MOV',
    'NOT',
)

meta_instructions = ()

line = 0
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
    if not token:
        return False
    if token.type == 'NEWLINE':
        lex()
    while token:
        stmt()
    return True

def stmt():
    if not token.type in instruction:
        parse_error('statement', f'expected instruction, got token of type {token.type}')
    if not (
        nop_stmt()
        or binary_stmt()
        or unary_stmt()
        or meta_stmt()
    ):
        parse_error('statement', f'unknown instruction: {token.value}')
    if token.type != 'NEWLINE':
        parse_error('statement', 'malformed statement. expected a newline')
    output.write('\n')
    lex()
    return True

def nop_stmt():
    if token.type != 'NOP':
        return False
    lex()
    if token.type == 'COMMA':
        parse_error('nop statement', 'unexpected comma')
    if arg():
        parse_error('nop statement', 'unexpected arguments')
    output.write(16*'0')
    return True

def binary_stmt():
    if not token.type in binary_instructions:
        return False
    ins = token.type
    ins_code = token.value
    arg_code = ''
    lex()
    if token.type == 'COMMA':
        parse_error('binary statement', 'unexpected comma')
    for i in range(3):
        if not arg():
            parse_error('binary statement', f'unknown argument: {token.value}')
        arg_code += token.value
        lex()
        if token.type == 'COMMA':
            lex()
            if i == 2 and arg():
                parse_error('unary statement', 'too many arguments')
        elif i != 2:
            parse_error('binary statement', 'insufficient arguments')
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
        parse_error('unary statement', 'unexpected comma')
    for i in range(2):
        if not arg():
            parse_error('unary statement', f'unknown argument: {token.value}')
        arg_code += token.value
        lex()
        if token.type == 'COMMA':
            lex()
            if i == 1 and arg():
                parse_error('unary statement', 'too many arguments')
        elif i != 1:
            parse_error('unary statement', 'insufficient arguments')
    output.write(ins_code)
    output.write(arg_code)
    output.write(4*'0')
    output.write(' // ' + ins)
    return True

def meta_stmt():
    if not token.type in meta_instructions:
        return False
    ins = token.type
    ins_code = token.value
    lex()
    if token.type == 'COMMA':
        parse_error('meta statement', 'unexpected comma')
    if not arg():
        parse_error('meta statement', 'missing argument')
    output.write(ins_code)
    output.write(token.value)
    output.write(8*'0')
    output.write(' // ' + ins)
    lex()
    return True

def arg():
    'NOTE: does not call lex()'
    global ireg
    if not token.type in ('REGISTER', 'IMMEDIATE'):
        return False
    if token.type == 'IMMEDIATE':
        binary = bin(token.value)[2:]
        if len(binary) > 16:
            parse_error('immediate', 'value exceeds 16-bit maximum')
        upper = (len(binary) > 8)
        binary = '0'*(16 - len(binary)) + binary
        output.write(instruction['LLOAD'])
        output.write(register[ireg])
        output.write(binary[8:])
        output.write(' // LLOAD\n')
        if upper:
            output.write(instruction['ULOAD'])
            output.write(register[ireg])
            output.write(binary[:8])
            output.write(' // ULOAD\n')
        token.value = register[ireg]
        ireg = 'di' if ireg == 'si' else 'si'
    return True

if __name__ == '__main__':
    if len(argv) == 1:
        exit(1)
    if '--debug' in argv[1:]:
        debug = True
    if '-o' in argv[1:]:
        i = argv.index('-o')
        if (i+1) == len(argv):
            print(f'{argv[0]}: missing output filename')
            exit(1)
        output = argv[i+1]
    output = open(output, 'w')
    lexer.input(open(argv[1]).read())
    lex()
    document()
