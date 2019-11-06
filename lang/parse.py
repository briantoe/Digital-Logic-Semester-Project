from lex import lexer, instruction, register
from sys import argv

binary_instructions = (
    'ADD',
    'SUB',
    'MUL',
    'DIV',
    'OR',
    'AND',
    'XOR',
    'CMP',
)

unary_instructions = (
    'NOT',
    'JZE',
    'JNZ',
)

meta_instructions = (
    'CALL',
)

special_instructions = (
    'NOP',
    'SYSCALL',
)

jump_types = (
    'JZE',
    'JNZ',
    'CALL'
)

arg_types = (
    'REGISTER',
    'IMMEDIATE',
    'REFERENCE',
    'OFFSET',
)

pc = 0
labels = {}
pending_references = {}
ireg = ('ai', 'bi', 'ci')
ireg_idx = 0
debug = False
output_name = 'doom.mem'
main_found = False
token = None

def parse_error(sym, msg):
    print(f'{argv[0]}: syntax error (line {token.lexer.lineno}): {sym}: ' + msg)
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
    global main_found
    if token.type != 'LABEL':
        return False
    name = token.value
    lex()
    if token.type == 'VALUE':
        labels.update({name: token.value})
        lex()
    else:
        labels.update({name: pc})
        if name == 'MAIN':
            main_found = True
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
    output.write(3*register['0'])
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
    if ins in jump_types:
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
    if ins in jump_types:
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
    global ireg_idx, pc
    if not token.type in arg_types:
        return False
    if token.type == 'IMMEDIATE':
        load_value(ireg[ireg_idx], token.value)
    elif token.type == 'REFERENCE':
        if not token.value in labels:
            pending_references.update({token.value: (output.tell(), ireg_idx)})
            for _ in range(2):
                output.write(instruction['NOP'])
                output.write(3*register['0'])
                output.write(' // NOP\n')
                pc += 1
        else:
            load_value(ireg[ireg_idx], labels[token.value])
    elif token.type == 'OFFSET':
        load_value(ireg[ireg_idx], token.offset)
        output.write(instruction['ADD'])
        output.write(2*register[ireg[ireg_idx]])
        output.write(token.value)
        output.write(' // ADD\n')
        pc += 1
    if token.type != 'REGISTER':
        token.value = register[ireg[ireg_idx]]
        ireg_idx = (ireg_idx + 1) % len(ireg)
    return True

def load_value(reg, value):
    global pc
    if value < 0:
        value += 2**16
    binary = bin(value)[2:]
    if len(binary) > 16:
        parse_error('immediate', 'value exceeds 16-bit maximum')
    upper = (len(binary) > 8)
    binary = '0'*(16 - len(binary)) + binary

    output.write(instruction['MLO'])
    output.write(register[reg])
    output.write(binary[8:])
    output.write(' // MLO\n')
    pc += 1

    if upper:
        output.write(instruction['MHI'])
        output.write(register[reg])
        output.write(binary[:8])
        output.write(' // MHI\n')
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
        output_name = argv[i+1]

    with open(output_name, 'w') as output:
        lexer.input(open(argv[1]).read())
        lex()
        pending_references.update({'MAIN': (output.tell(), -1)})
        for _ in range(2):
            output.write(instruction['NOP'])
            output.write(3*register['0'])
            output.write(' // NOP\n')
        output.write(instruction['JZE'])
        output.write(register['pc'])
        output.write(register[ireg[-1]])
        output.write(register['0'])
        output.write(' // JZE\n')
        pc += 3

        document()

        if not main_found:
            print(f'{argv[0]}: label MAIN missing')
            exit(1)

        for label in labels:
            if label in pending_references:
                pend = pending_references.pop(label)
                output.seek(pend[0], 0)
                load_value(ireg[pend[1]], labels[label])

    if pending_references:
        label = list(pending_references.keys())[0]
        print(f'{argv[0]}: undefined label `{label}`')
        exit(1)
