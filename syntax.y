%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "Lista.h"

FILE *yyin;

int yyerror();
int yylex();

%}

%union {
	char str_val[400];
}

%token <str_val> CONST_REAL
%token <str_val> CONST_INT
%token <str_val> CONST_STR
%token <str_val> ID

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
%token PUNTOYCOMA
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

/* START SYMBOL */
%start inicio

%%
inicio: 
    programa        {printf("the bluetooth is connected succesfuley");}
;

programa:
    init
    |init bloque
    |bloque
;

bloque:
    bloque sentencia
    |sentencia
;

sentencia:
    struct_condicional
    |asignacion
    |leer
    |escribir
    |funcion_especial
;

init:
    INIT LLAVE_OP declaraciones LLAVE_CL
;

declaraciones:
    declaraciones declaracion
    |declaracion
;

declaracion:
    lista_ids DOSPUNTOS tipo_dato
;

lista_ids:
    lista_ids COMA ID
    |ID
;

tipo_dato:
    T_STRING
    |T_FLOAT
    |T_INT
;

struct_condicional:
    IF PAR_OP condicional PAR_CL LLAVE_OP bloque LLAVE_CL ELSE LLAVE_OP bloque LLAVE_CL
    |IF PAR_OP condicional PAR_CL LLAVE_OP bloque LLAVE_CL
    |WHILE PAR_OP condicional PAR_CL LLAVE_OP bloque LLAVE_CL
;

condicional:
    condicion
    |condicion operador_logico condicion
    |OP_NOT condicion
;

condicion: //TODO: ver de manejar constantes string también (No lo hacemos)
    expresion comparador expresion
;

comparador:
    OP_EQ
    |OP_NEQ
    |OP_GT
    |OP_GEQ
    |OP_LT
    |OP_LEQ
;    

operador_logico:
    OP_AND
    |OP_OR
;

asignacion:
    ID OP_ASIG expresion
    |ID OP_ASIG CONST_STR
    |ID OP_ASIG funcion_especial
;

expresion:
    expresion OP_ADD termino
    |expresion OP_SUB termino
    |termino
;

termino:
    termino OP_MUL factor
    |termino OP_DIV factor
    |factor
;

factor:
    ID                          {printf("factor: %s", $1);}
    |CONST_INT
    |CONST_REAL
    |PAR_OP expresion PAR_CL
;

leer:
    READ PAR_OP ID PAR_CL
;

escribir:
    WRITE PAR_OP expresion PAR_CL
    |WRITE PAR_OP CONST_STR PAR_CL
;

funcion_especial:
    ID OP_EQ nombre_funcion PAR_OP CONST_INT PUNTOYCOMA CORCHETE_OP lista_const CORCHETE_CL PAR_CL
;

nombre_funcion:
    GETPENULTIMATEPOSITION
    |SUMALOSULTIMOS
;

lista_const:
    lista_const COMA CONST_REAL
    |lista_const COMA CONST_INT
    |CONST_INT
    |CONST_REAL
;

%%

int main(int argc, char *argv[])
{
    if((yyin = fopen(argv[1], "rt")) == NULL){
        printf("\nNo se puede abrir el archivo de prueba: %s\n", argv[1]);
    } else{ 
        yyparse();
    }
	
    fclose(yyin);
    return 0;
}

int yyerror()
{
    printf("\nError Sintactico\n");
    exit (1);
}
