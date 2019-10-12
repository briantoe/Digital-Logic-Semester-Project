from ply.lex import lex

tokens = (
    'NEWLINE',
    'COMMA',

    'REGISTER',
    'IMMEDIATE',
    'NOP',

    'ADD',
    'SUB',
    'MULT',
    'DIV',
    'SHIFTL',
    'SHIFTR',
    'CMP',
    'MOV',
    'OR',
    'AND',
    'NOT',
    'XOR',
)

instruction = {
    'NOP': '0000',
    'ADD': '0001',
    'SUB': '0010',
    'MULT': '0011',
    'DIV': '0100',
    'SHIFTL': '0101',
    'SHIFTR': '0110',
    'CMP': '0111',
    'MOV': '1000',
    'OR': '1001',
    'AND': '1010',
    'NOT': '1011',
    'XOR': '1100',
}

register = {
    'ax': '0001',
    'bx': '0010',
    'cx': '0011',
    'dx': '0100',
    'ac': '0101',
    'bp': '0110',
    'pc': '0111',
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
    r'%[a-z]+'
    if not tok.value[1:] in register:
        raise Exception(f'unknown register: {tok.value[1:]}')
    tok.value = register[tok.value[1:]]
    return tok

def t_IMMEDIATE(tok):
    r'\$[0-9]+'
    if int(tok.value[1:]) > 7:
        raise Exception(f'immediate out of range (must be a 3 bit value): {tok.value[1:]}')
    tok.value = '1' + f'{int(tok.value[1:]):03b}'
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

lexer = lex()
