from ply import yacc
from lex import lexer, tokens

def p_error(p):
    raise Exception(f'syntax error')

def p_document(p):
    '''document : stmt_list
                | NEWLINE stmt_list'''
    if len(p) == 2:
        p[0] = p[1]
    else:
        p[0] = p[2]
    print('document: ' + str(p[0]))

def p_stmt_list(p):
    '''stmt_list : stmt stmt_list
                 | '''
    if len(p) == 3:
        p[0] = [p[1],] + p[2]
    else:
        p[0] = []
    print('stmt_list: ' + str(p[0]))

def p_stmt(p):
    '''stmt : instruction arg_list NEWLINE'''
    if len(p) == 6:
        p[0] = p[1] + ''.join(p[2])
    else:
        p[0] = p[1] + ''.join(p[2])
    p[0] = p[0] + '0'*(16 - len(p[0]))
    print('stmt: ' + p[0])

def p_instruction(p):
    '''instruction : NOP
                   | ADD
                   | SUB
                   | MULT
                   | DIV
                   | SHIFTL
                   | SHIFTR
                   | CMP
                   | LOAD
                   | MOV
                   | JMP
                   | OR
                   | AND
                   | NOT
                   | XOR'''
    p[0] = p[1]
    print('instruction: ' + p[0])

def p_arg_list(p):
    '''arg_list : arg COMMA arg_list
                | arg '''
    if len(p) == 2:
        p[0] = [p[1],]
    else:
        p[0] = [p[1],] + p[3]
    print('arg_list: ' + ''.join(p[0]))

def p_arg(p):
    '''arg : REGISTER
           | IMMEDIATE'''
    p[0] = p[1]
    print('arg: ' + p[0])

yacc.yacc()

if __name__ == '__main__':
    from pathlib import Path
    from sys import argv
    if len(argv) == 1:
        raise Exception('no input file')
    yacc.parse(open(argv[1]).read())
