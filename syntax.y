%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "Lista.h"

FILE *yyin;
FILE *ts;

int yyerror();
int yylex();
void guardar_TS();

char* tabla_simbolos = "symbols.txt";
t_lista lista_simbolos;

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


%left '+' '-'
%left '*' '/'
%right MENOS_UNARIO

%%
inicio: 
    programa        {printf("\nThe bluetooth is connected succesfuley\n");guardar_TS();}
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

condicion:
    expresion comparador expresion {printf("entra aca");}
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
    ID OP_ASIG expresion            {printf("\nAsignacion: %s <-", $1);}
    |ID OP_ASIG CONST_STR
    |ID OP_ASIG funcion_especial
;

expresion:
    expresion OP_ADD termino        {printf("\nExpresion + termino");}
    |expresion OP_SUB termino       {printf("\nExpresion - termino");}
    |termino                        {printf("\nTermino");}
;

termino:
    termino OP_MUL factor           {printf("\nTermino * factor");}
    |termino OP_DIV factor          {printf("\nTermino / factor");}
    |factor                         {printf("\nFactor");}
;

factor:
    ID                          {printf("\nElemento: %s", $1);}
    |OP_SUB PAR_OP expresion PAR_CL %prec MENOS_UNARIO      {printf("\nMenos unario a (-expresion)");}
    |OP_SUB ID %prec MENOS_UNARIO                           {printf("\nMenos unario: - %s", $2);}
    |CONST_INT                  {printf("\nInt: %s", $1);}
    |CONST_REAL                 {printf("\nFloat: %s", $1);}
    |PAR_OP expresion PAR_CL    {printf("\nExpresion ()");}
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
    crearLista(&lista_simbolos);

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

void guardar_TS(){
    ts = fopen(tabla_simbolos, "wt");
    if (ts == NULL) {
        printf("\nError al intentar guardar en la tabla de simbolos");
        return;
    }

    t_lexema lex;

    fprintf(ts, "NOMBRE|TIPO|VALOR|LONGITUD\n");
    while(quitarPrimeroDeLista(&lista_simbolos, &lex)) {
        fprintf(ts, "%s|%s|%s|%s\n", lex.nombre, lex.tipodato, lex.valor, lex.longitud);
    }

    fclose(ts);

    vaciarLista(&lista_simbolos);

    return;
}