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
    'CMP', # Compare
    'MOV', # Move
    'JNZ', # Jump if not zero
    'SAVE',
    'LOAD',
    'PRNT', # Print
)

instruction = {
    'NOP': '0000',
    'ADD': '0001',
    'MUL': '0010',
    'DIV': '0011',
    'OR': '0100',
    'AND': '0101',
    'NOT': '0110',
    'XOR': '0111',
    'CMP': '1000',
    'MOV': '1001',
    'JNZ': '1010',
    'SAVE': '1011',
    'LOAD': '1100',
    'PRNT': '1101', # Print
    'LMOV': '1110', # Move immediate into lower byte
    'UMOV': '1111', # Move immediate into upper byte
}

register = {
    '0': '0000',
    'ax': '0001',
    'bx': '0010',
    'cx': '0011',
    'dx': '0100',
    'ac': '0101',
    'si': '0110', # Reserved
    'di': '0111', # Reserved
    '1': '1000',
    '2': '1001',
    '3': '1010',
    '4': '1011',
    '5': '1100',
    '6': '1101',
    '7': '1110',
    'pc': '1111',
}

t_ignore = ' \t'
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
        print(f'parse error: unknown register: {tok.value[1:]}')
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

def t_NOP(tok):
    r'nop'
    tok.value = instruction[tok.value.upper()]
    return tok

def t_ADD(tok):
    r'add'
    tok.value = instruction[tok.value.upper()]
    return tok

def t_MUL(tok):
    r'mul'
    tok.value = instruction[tok.value.upper()]
    return tok

def t_DIV(tok):
    r'div'
    tok.value = instruction[tok.value.upper()]
    return tok

def t_OR(tok):
    r'or'
    tok.value = instruction[tok.value.upper()]
    return tok

def t_AND(tok):
    r'and'
    tok.value = instruction[tok.value.upper()]
    return tok

def t_NOT(tok):
    r'not'
    tok.value = instruction[tok.value.upper()]
    return tok

def t_XOR(tok):
    r'xor'
    tok.value = instruction[tok.value.upper()]
    return tok

def t_CMP(tok):
    r'cmp'
    tok.value = instruction[tok.value.upper()]
    return tok

def t_MOV(tok):
    r'mov'
    tok.value = instruction[tok.value.upper()]
    return tok

def t_JNZ(tok):
    r'jnz'
    tok.value = instruction[tok.value.upper()]
    return tok

def t_SAVE(tok):
    r'save'
    tok.value = instruction[tok.value.upper()]
    return tok

def t_LOAD(tok):
    r'load'
    tok.value = instruction[tok.value.upper()]
    return tok

def t_PRNT(tok):
    r'prnt'
    tok.value = instruction[tok.value.upper()]
    return tok

lexer = lex()
