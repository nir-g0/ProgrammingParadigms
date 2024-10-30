grammar Expr;

// ***Lexing rules***

INT     : [0-9]+ ;
ID  : [a-zA-Z]+ ;
NEWLINE : '\r'? '\n' ;
WS      : [ \t]+ -> skip ; // ignore whitespace

MUL : '*' ;
DIV : '/' ;
ADD : '+' ;
SUB : '-' ;
ASSIGN : '=' ;

// ***Parsing rules ***

/** The start rule */
prog: stat+ ;

stat: expr NEWLINE              # printExpr
    | ID ASSIGN expr NEWLINE    # assign
    | NEWLINE                   # blank
    ;

expr: expr op=( '*' | '/' ) expr   # MulDiv
    | expr op=( '+' | '-' ) expr   # AddSub
    | INT                       # int
    | ID                        # id
    | '(' expr ')'              # parens
    ;


