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
    ID OP_ASIG CONST_INT        {printf("\nAsignacion de entero: %s := %s", $1, $3);}
    |ID OP_ASIG CONST_REAL      {printf("\nAsignacion de float: %s := %s", $1, $3);}
    |ID OP_ASIG CONST_STR       {printf("\nAsignacion de string: %s := %s", $1, $3);}
    |ID OP_ASIG ID              {printf("\nAsignacion entre variables: %s := %s", $1, $3);}
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
    ID comparador ID            {printf("\nCondicion: %s", $1);}
    |ID comparador CONST_INT    {printf("\nCondicion entera: %s", $3);}
    |ID comparador CONST_REAL   {printf("\nCondicion: %s %s", $1, $3);}
    |ID comparador CONST_STR    {printf("\nCondicion: %s %s", $1, $3);}
    |CONST_STR comparador ID    {printf("\nCondicion: %s %s", $1, $3);}
    |CONST_INT comparador ID    {printf("\nCondicion: %s %s", $1, $3);}
    |CONST_REAL comparador ID   {printf("\nCondicion: %s %s", $1, $3);}
    |CONST_INT comparador CONST_INT {printf("\nCondicion: %s %s", $1, $3);}
;

comparador:
    OP_EQ      
    |OP_NEQ    
    |OP_GT     
    |OP_GEQ    
    |OP_LT     
    |OP_LEQ    
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
