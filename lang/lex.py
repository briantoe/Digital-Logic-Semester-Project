from ply.lex import lex

tokens = (
    'NEWLINE',
    'COMMA',

    'REGISTER',
    'IMMEDIATE',
    'LABEL',
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
    'SYS',
    'HLT',
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
    'SYS': '1100',
    'LMOV': '1101', # Move immediate into lower byte (RESERVED)
    'UMOV': '1110', # Move immediate into upper byte (RESERVED)
    'HLT': '1111', # Halt
}

register = {
    '0': '0000',
    'ax': '0001',
    'bx': '0010',
    'cx': '0011',
    'dx': '0100',
    'ac': '0101',
    'si': '0110', # (RESERVED)
    'di': '0111', # (RESERVED)
    '1': '1000',
    '2': '1001',
    '3': '1010',
    '4': '1011',
    '5': '1100',
    'hi': '1101',
    'lo': '1110',
    'pc': '1111',
}

t_ignore = ' \t'
t_ignore_COMMENT = r'\#.*'
t_COMMA = r','

def t_error(tok):
    tok.value = tok.value.splitlines()[0].partition(' ')[0]
    print(f'parse error: illegal token: {tok.value}')
    exit(1)

def t_NEWLINE(tok):
    r'\n+'
    tok.lexer.lineno += len(tok.value)
    return tok

def t_REGISTER(tok):
    r'%[a-z0-9]+'
    if not tok.value[1:] in register:
        print(f'parse error: unknown register: {tok.value}')
        exit(1)
    tok.value = register[tok.value[1:]]
    return tok

def t_IMMEDIATE(tok):
    r'\$[0-9]+'
    tok.value = int(tok.value[1:])
    return tok

def t_LABEL(tok):
    r'[a-zA-Z][a-zA-Z0-9]*:'
    tok.value = tok.value[:-1]
    return tok

def t_REFERENCE(tok):
    r'\.[a-zA-Z][a-zA-Z0-9]*'
    tok.value = tok.value[1:]
    return tok

def t_INSTRUCTION(tok):
    r'[a-z]+'
    tok.type = tok.value.upper()
    if not tok.type in instruction:
        print(f'parse error: unknown instruction `{tok.type}`')
        exit(1)
    tok.value = instruction[tok.type]
    return tok

lexer = lex()
