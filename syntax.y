%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "lista.h"
#include "y.tab.h"

int yystopparser=0;
FILE *yyin;

int yyerror();
int yylex();

%}

%token CONST_REAL
%token CONST_INT
%token CONST_STR
%token ID
%token OP_ASIG
%token OP_ADD
%token OP_SUB
%token OP_MUL
%token OP_DIV
%token OP_EQ
%token OP_NEQ
%token OP_GT
%token OP_GEQ
%token OP_LT
%token OP_LEQ
%token OP_AND
%token OP_OR
%token OP_NOT
%token PAR_OP
%token PAR_CL
%token CORCHETE_OP
%token CORCHETE_CL
%token LLAVE_OP
%token LLAVE_CL
%token COMA
%token DOSPUNTOS
%token INIT
%token IF
%token ELSE
%token WHILE
%token T_INT
%token T_FLOAT
%token T_STRING
%token READ
%token WRITE
%token GETPENULTIMATEPOSITION
%token SUMALOSULTIMOS
%token COMENTARIO
%token COMENTARIO_ANIDADO

%%

condicional:
    IF PAR_OP condicion PAR_CL
    |PAR_OP condicion operador_logico condicion PAR_CL
    |PAR_OP condicion operador_logico condicion PAR_CL
    |PAR_OP OP_NOT condicion PAR_CL

operador_logico:
    OP_AND
    |OP_OR

condicion:
    ID comparador ID
    |ID comparador CONST_INT
    |ID comparador CONST_REAL
    |ID comparador CONST_STR
    |CONST_STR comparador ID
    |CONST_INT comparador ID
    |CONST_REAL comparador ID
    |CONST_INT comparador CONST_INT

comparador:
    OP_EQ
    |OP_NEQ
    |OP_GT
    |OP_GEQ
    |OP_LT
    |OP_LEQ
    

%%