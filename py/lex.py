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
    'STRING',
    'OFFSET',
    'REFERENCE',

    'NOP',
    'ADD',
    'SUB',
    'MUL',
    'DIV',
    'OR',
    'AND',
    'NOT',
    'XOR',
    'CMP',
    'JZE',
    'JNZ',
    'CALL',
    'SYSCALL',
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
    'JZE': '1010',
    'JNZ': '1011',
    'CALL': '1100',
    'SYSCALL': '1101',
    'MLO': '1110', # Move immediate into lower byte (RESERVED)
    'MHI': '1111', # Move immediate into upper byte (RESERVED)
}

register = {
    '0': '0000',
    'ax': '0001',
    'bx': '0010',
    'cx': '0011',
    'dx': '0100',
    'ex': '0101',
    'ac': '0110',
    'bp': '0111',
    '1': '1000',
    '2': '1001',
    '3': '1010',
    '4': '1011',
    'ai': '1100', # RESERVED
    'bi': '1101', # RESERVED
    'ci': '1110', # RESERVED
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
    if tok.lexer.lexstate != 'INITIAL':
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

def t_OFFSET(tok):
    r'-?[0-9]+\(%[a-z0-9]+\)'
    tok.offset = int(tok.value[:tok.value.index('(')])
    tok.value = tok.value[tok.value.index('%'):tok.value.index(')')]
    return t_REGISTER(tok)

def t_IMMEDIATE(tok):
    r'-?\$[0-9]+'
    tok.name = tok.value
    tok.value = int(tok.value[tok.value.index('$')+1:])
    if tok.name[0] == '-':
        tok.value *= -1
    return tok

def t_LABEL(tok):
    r'[a-zA-Z][a-zA-Z0-9_]*:'
    tok.value = tok.value[:-1]
    tok.lexer.begin('label')
    return tok

def t_label_VALUE(tok):
    r'-?[0-9]+'
    tok.value = int(tok.value)
    return tok

def t_label_STRING(tok):
    r'".*"'
    tok.value = tok.value[1:-1]
    return tok

def t_REFERENCE(tok):
    r'\.[a-zA-Z][a-zA-Z0-9_]*'
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
