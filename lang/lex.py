from ply.lex import lex

states = (
    ('label', 'exclusive'),
)

tokens = (
    'NEWLINE',
    'COMMA',

    'REGISTER',
    'IMMEDIATE',
    'LABEL',
    'VALUE',
    'REFERENCE',

    'NOP',
    'ADD',
    'MUL',
    'DIV',
    'OR',
    'AND',
    'NOT',
    'XOR',
    'CMP',
    'MOV',
    'JNZ',
    'JMP',
    'SYS',
)

instruction = {
    'NOP': '0000',
    'ADD': '0001',
    'SUB': '0010',
    'MUL': '0011',
    'DIV': '0100',
    'OR': '0101',
    'AND': '0110',
    'NOT': '0111',
    'XOR': '1000',
    'CMP': '1001',
    'MOV': '1010',
    'JNZ': '1011',
    'JMP': '1100',
    'SYS': '1101',
    'LMOV': '1110', # Move immediate into lower byte (RESERVED)
    'UMOV': '1111', # Move immediate into upper byte (RESERVED)
}

register = {
    '0': '0000',
    'ax': '0001',
    'bx': '0010',
    'cx': '0011',
    'dx': '0100',
    'ac': '0101',
    'bp': '0110',
    'hi': '0111',
    'lo': '1000',
    '1': '1001',
    '2': '1010',
    '3': '1011',
    '4': '1100',
    'si': '1101', # RESERVED
    'di': '1110', # RESERVED
    'pc': '1111',
}

t_ANY_ignore = ' \t'
t_ANY_ignore_COMMENT = r'\#.*'

def t_ANY_error(tok):
    tok.value = tok.value.splitlines()[0].partition(' ')[0]
    print(f'parse error: illegal token `{tok.value}`')
    exit(1)

def t_ANY_NEWLINE(tok):
    r'\n+'
    tok.lexer.lineno += len(tok.value)
    if tok.lexer.lexstate == 'label':
        tok.lexer.begin('INITIAL')
    return tok

def t_COMMA(tok):
    r','
    return tok

def t_REGISTER(tok):
    r'%[a-z0-9]+'
    tok.name = tok.value
    if not tok.value[1:] in register:
        print(f'parse error: unknown register `{tok.value}`')
        exit(1)
    tok.value = register[tok.value[1:]]
    return tok

def t_IMMEDIATE(tok):
    r'\$[0-9]+'
    tok.name = tok.value
    tok.value = int(tok.value[1:])
    return tok

def t_LABEL(tok):
    r'[a-zA-Z][a-zA-Z0-9]*:'
    tok.value = tok.value[:-1]
    tok.lexer.begin('label')
    return tok

def t_label_VALUE(tok):
    r'[0-9]+'
    tok.value = int(tok.value)
    return tok

def t_REFERENCE(tok):
    r'\.[a-zA-Z][a-zA-Z0-9]*'
    tok.name = tok.value
    tok.value = tok.value[1:]
    return tok

def t_INSTRUCTION(tok):
    r'[a-z]+'
    tok.type = tok.value.upper()
    if not tok.type in instruction:
        print(f'parse error: unknown instruction `{tok.value}`')
        exit(1)
    tok.value = instruction[tok.type]
    return tok

lexer = lex()
