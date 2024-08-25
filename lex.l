%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>

#include "Lista.h"

#define MAX_STR_LEN 40
#define MIN_INT -32768  //2^15 (1 para el signo) - 1 (el mayor número representable)
#define MAX_INT 32767   //2^15 (1 para el signo) - 1 (el mayor número representable)
#define MIN_FLOAT -2147483648
#define MAX_FLOAT 2147483647

FILE *yyin;
int yylval;
t_lista lista_ts;

void guardar_en_TS();
void mostrar_token_inutil();
void validar_longitud_str(char* str);
void validar_rango_int(char* str);
void validar_rango_float(char* str);
void handleErr(char* str);
%}

%option noyywrap
%option yylineno 

/* Conjuntos */
DIGITO [0-9]
DIGITONOCERO [1-9]
LETRA [a-zA-Z]
PUNTO "."

/* Regex */
CONST_REAL  -?({DIGITO}*{PUNTO}{DIGITO}*|{DIGITO}+{PUNTO}{DIGITO}*)
CONST_INT   (-?{DIGITONOCERO}{DIGITO}+)|0
CONST_STR   \"[^"]*\"
ID      {LETRA}({LETRA}|{DIGITO}|_)*


/* Operadores */
OP_ASIG ":="
OP_ADD  "+"
OP_SUB  "-"
OP_MUL  "*"
OP_DIV  "/"
OP_EQ   "=="
OP_NEQ  "!="
OP_GT   ">"
OP_GEQ  ">="
OP_LT   "<"
OP_LEQ  "<="
OP_AND  "AND"
OP_OR   "OR"
OP_NOT  "NOT"

/* Caracteres */
PAR_OP      "("
PAR_CL      ")"
CORCHETE_OP  "["
CORCHETE_CL  "]"
LLAVE_OP    "{"
LLAVE_CL    "}"
COMA        ","
DOSPUNTOS   ":"

/* Palabras Reservadas */
INIT                    "init"
IF                      "si"
ELSE                    "sino"
WHILE                   "mientras"
T_INT                   "Int"
T_FLOAT                 "Float"
T_STRING                "String"
READ                    "leer"
WRITE                   "escribir"
GETPENULTIMATEPOSITION  "getPenultimatePosition"
SUMALOSULTIMOS          "sumaLosUltimos"

/* Comentarios */
COMENTARIO "*-"[^-*]*"-*"
COMENTARIO_ANIDADO  "*-"[^*-]*{COMENTARIO}[^-*]*"-*"

%%
{OP_ASIG}                   {}
{OP_ADD}                    {}
{OP_SUB}                    {}
{OP_MUL}                    {}
{OP_DIV}                    {}
{OP_EQ}                     {}
{OP_NEQ}                    {}
{OP_GT}                     {}
{OP_GEQ}                    {}
{OP_LT}                     {}
{OP_LEQ}                    {}
{OP_AND}                    {}
{OP_OR}                     {}
{OP_NOT}                    {}
{PAR_OP}                    {}
{PAR_CL}                    {}
{CORCHETE_OP}               {}
{CORCHETE_CL}               {}
{LLAVE_OP}                  {}
{LLAVE_CL}                  {}
{COMA}                      {}
{DOSPUNTOS}                 {}
{INIT}                      {}
{IF}                        {}
{ELSE}                      {}
{WHILE}                     {}
{T_INT}                     {}
{T_FLOAT}                   {}
{T_STRING}                  {}
{READ}                      {}
{WRITE}                     {}
{GETPENULTIMATEPOSITION}    {}
{SUMALOSULTIMOS}            {}


{ID}                    {printf("\nIdentificador: %s\n", yytext); guardar_en_TS (); }
{CONST_REAL}            {validar_rango_float(yytext); printf("\nConstante real: %s\n", yytext); guardar_en_TS ();}
{CONST_INT}             {validar_rango_int(yytext); printf("\nConstante entera: %s\n", yytext); guardar_en_TS ();}
{CONST_STR}             {validar_longitud_str(yytext); printf("\nConstante string: %s\n", yytext); guardar_en_TS ();}

{COMENTARIO}            {printf("\nEsto es un comentario: %s\n", yytext);}
{COMENTARIO_ANIDADO}    {printf("\nEsto es un comentario anidado: %s\n", yytext);}

"\n"
"\t"
"\n\t"
" "
"\r\n"

.                       {handleErr(yytext);}

%%

int main(int argc,char *argv[])
{
    chiche();

    if ((yyin = fopen(argv[1], "rt")) == NULL) {
        printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
    }

    yylex();
    fclose(yyin);

    printf("la lista vale: %p", lista_ts);
}

void guardar_en_TS(){
    printf("Guarda en TS");
}

void validar_longitud_str(char* str){
    if(strlen(str) - 2 > MAX_STR_LEN) { // - 2 por las comillas
        printf("\nERROR: String %s tiene longitud mayor a la permitida de %d caracteres\n", yytext, MAX_STR_LEN);
        exit(1);
    }
}

void validar_rango_int(char* str){
    int val = atoi(str);
    if(val < MIN_INT || val > MAX_INT){
        printf("\nERROR: Constante entera %s fuera de rango\n", yytext);
        exit(1);
    }
}

void validar_rango_float(char* str){
    float val = atof(str);
    if(val < MIN_FLOAT || val > MAX_FLOAT){
        printf("\nERROR: Constante flotante %s fuera de rango\n", yytext);
        exit(1);
    }
}

void handleErr(char* str){
    printf("\nCaracter inesperado: %s\n", yytext);
}