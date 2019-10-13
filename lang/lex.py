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
    'SUB',
    'MULT',
    'DIV',
    'OR',
    'AND',
    'NOT',
    'XOR',
    'SHIFTL',
    'SHIFTR',
    'CMP',
    'MOV',
    'JNE',
)

instruction = {
    'NOP': '0000',
    'ADD': '0001',
    'SUB': '0010',
    'MULT': '0011',
    'DIV': '0100',
    'OR': '0101',
    'AND': '0110',
    'NOT': '0111',
    'XOR': '1000',
    'SHIFTL': '1001',
    'SHIFTR': '1010',
    'CMP': '1011',
    'MOV': '1100',
    'JNE': '1101',
    'LLOAD': '1110', # Load lower byte
    'ULOAD': '1111', # Load upper byte
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

def t_SUB(tok):
    r'sub'
    tok.value = instruction[tok.value.upper()]
    return tok

def t_MULT(tok):
    r'mult'
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

def t_SHIFTL(tok):
    r'shiftl'
    tok.value = instruction[tok.value.upper()]
    return tok

def t_SHIFTR(tok):
    r'shiftr'
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

def t_JNE(tok):
    r'jne'
    tok.value = instruction[tok.value.upper()]
    return tok

lexer = lex()
