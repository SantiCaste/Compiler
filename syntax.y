%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "lista.h"
#include "y.tab.h"

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

/* START SYMBOL */
%start inicio

%%
inicio: 
    programa
;

programa:
    bloque
;

bloque:
    bloque sentencia
    |sentencia
;

sentencia:
    condicional
    |ciclo
    |asignacion
    |leer
    |escribir
    |getPenultimatePosition
    |sumaLosUltimos
;

ciclo: //TODO: corregir esto y lo mismo para condicional, separar en otra regla que sea condición o algo de eso
    WHILE PAR_OP condicion PAR_CL LLAVE_OP bloque LLAVE_CL
    |WHILE PAR_OP condicion operador_logico condicion PAR_CL LLAVE_OP bloque LLAVE_CL
    |WHILE PAR_OP OP_NOT condicion PAR_CL LLAVE_OP bloque LLAVE_CL
;

condicional:
    IF PAR_OP condicion PAR_CL LLAVE_OP bloque LLAVE_CL {printf("\nentra en el de 1 condicion");}
    |IF PAR_OP condicion operador_logico condicion PAR_CL LLAVE_OP bloque LLAVE_CL{printf("\nentra en el de 2 condiciones");}
    |IF PAR_OP OP_NOT condicion PAR_CL LLAVE_OP bloque LLAVE_CL{printf("\nentra en el de 1 condicion negada");}
;

asignacion:
    ID OP_ASIG CONST_INT
    |ID OP_ASIG CONST_REAL
    |ID OP_ASIG CONST_STR
    |ID OP_ASIG ID
;

leer:
    OP_ADD
;

escribir:
    OP_SUB
;

getPenultimatePosition:
    OP_ASIG
;

sumaLosUltimos:
    OP_EQ
;

operador_logico:
    OP_AND
    |OP_OR
;

condicion:
    ID comparador ID            {printf("\nCondición: %s %s %s", $1, $2, $3);}
    |ID comparador CONST_INT    {printf("\nCondición: %s %s %s", $1, $2, $3);}
    |ID comparador CONST_REAL   {printf("\nCondición: %s %s %s", $1, $2, $3);}
    |ID comparador CONST_STR    {printf("\nCondición: %s %s %s", $1, $2, $3);}
    |CONST_STR comparador ID    {printf("\nCondición: %s %s %s", $1, $2, $3);}
    |CONST_INT comparador ID    {printf("\nCondición: %s %s %s", $1, $2, $3);}
    |CONST_REAL comparador ID   {printf("\nCondición: %s %s %s", $1, $2, $3);}
    |CONST_INT comparador CONST_INT {printf("\nCondición: %s %s %s", $1, $2, $3);}
;

comparador:
    OP_EQ       {printf("\nEl operador es: %s", $1);}
    |OP_NEQ     {printf("\nEl operador es: %s", $1);}
    |OP_GT      {printf("\nEl operador es: %s", $1);}
    |OP_GEQ     {printf("\nEl operador es: %s", $1);}
    |OP_LT      {printf("\nEl operador es: %s", $1);}
    |OP_LEQ     {printf("\nEl operador es: %s", $1);}
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
