%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"
#include "Lista.h"

#define MAX_STR_LEN 40
#define MIN_INT -32768  //2^15 (1 para el signo) - 1 (el mayor número representable)
#define MAX_INT 32767   //2^15 (1 para el signo) - 1 (el mayor número representable)
#define MIN_FLOAT -2147483648
#define MAX_FLOAT 2147483647

enum tipoLex
{
    id,
    constInt,
    constFlt,
    constStr
};

void guardar_en_TS();
void mostrar_token_inutil();
void validar_longitud_str(char* str);
void validar_rango_int(char* str);
void validar_rango_float(char* str);
void handleErr(char* str);
void obtenerLexema(char* nombre);

void agregar_a_TS(char* lex, enum tipoLex tipo);
void eliminar_caracteres(char *s, char c);

t_lexema convertirStrALexema(char* lex);
t_lexema convertirNumALexema(char* lex, char* tipo);
t_lexema convertirIdALexema(char* lex);

extern t_lista lista_simbolos;

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
CONST_INT   (-?{DIGITONOCERO}{DIGITO}*)|0
CONST_STR   \"[^\"]*\"
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
PUNTOYCOMA  ";"

/* Palabras Reservadas */
INIT                    "init"
IF                      "si"
ELSE                    "sino"
WHILE                   "while"
T_INT                   "Int"
T_FLOAT                 "Float"
T_STRING                "String"
READ                    "leer"
WRITE                   "escribir"
GETPENULTIMATEPOSITION  "getPenultimatePosition"
SUMALOSULTIMOS          "sumaLosUltimos"

/* Comentarios */ 
COMENTARIO          "*-".*"-*"
COMENTARIO_ANIDADO  "*-".*{COMENTARIO}.*"-*"

%%
{OP_ASIG}                   {return OP_ASIG;}
{OP_ADD}                    {return OP_ADD;}
{OP_SUB}                    {return OP_SUB;}
{OP_MUL}                    {return OP_MUL;}
{OP_DIV}                    {return OP_DIV;}
{OP_EQ}                     {return OP_EQ;}
{OP_NEQ}                    {return OP_NEQ;}
{OP_GT}                     {return OP_GT;}
{OP_GEQ}                    {return OP_GEQ;}
{OP_LT}                     {return OP_LT;}
{OP_LEQ}                    {return OP_LEQ;}
{OP_AND}                    {return OP_AND;}
{OP_OR}                     {return OP_OR;}
{OP_NOT}                    {return OP_NOT;}
{PAR_OP}                    {return PAR_OP;}
{PAR_CL}                    {return PAR_CL;}
{CORCHETE_OP}               {return CORCHETE_OP;}
{CORCHETE_CL}               {return CORCHETE_CL;}
{LLAVE_OP}                  {return LLAVE_OP;}
{LLAVE_CL}                  {return LLAVE_CL;}
{COMA}                      {return COMA;}
{DOSPUNTOS}                 {return DOSPUNTOS;}
{INIT}                      {return INIT;}
{IF}                        {return IF;}
{ELSE}                      {return ELSE;}
{WHILE}                     {return WHILE;}
{T_INT}                     {return T_INT;}
{T_FLOAT}                   {return T_FLOAT;}
{T_STRING}                  {return T_STRING;}
{READ}                      {return READ;}
{WRITE}                     {return WRITE;}
{GETPENULTIMATEPOSITION}    {return GETPENULTIMATEPOSITION;}
{SUMALOSULTIMOS}            {return SUMALOSULTIMOS;}


{ID}                    {obtenerLexema(yytext); agregar_a_TS(yytext, id); return ID;}
{CONST_REAL}            {validar_rango_float(yytext); obtenerLexema(yytext); agregar_a_TS(yytext, constFlt); return CONST_REAL;}
{CONST_INT}             {validar_rango_int(yytext); obtenerLexema(yytext); agregar_a_TS(yytext, constInt); return CONST_INT;}
{CONST_STR}             {validar_longitud_str(yytext); obtenerLexema(yytext); agregar_a_TS(yytext, constStr); return CONST_STR;}

{COMENTARIO}            {printf("\nComentario: %s", yytext);}
{COMENTARIO_ANIDADO}    {printf("\nComentario anidado: %s", yytext);}

"\n"
"\t"
"\n\t"
" "
"\r\n"

.                       {handleErr(yytext);}

%%

/*
int main(int argc,char *argv[])
{
    if ((yyin = fopen(argv[1], "rt")) == NULL) {
        printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
    }

    yylex();
    fclose(yyin);

    printf("la lista vale: %p", lista_ts);
}
*/

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

void obtenerLexema(char* nombre){
    strcpy(yylval.str_val, nombre);
}

void agregar_a_TS(char* lex, enum tipoLex tipo){
    t_lexema lexema;

    char lexCopy[100];
    strcpy(lexCopy, lex);

    switch (tipo) {
        case constInt:
            lexema = convertirNumALexema(lexCopy, "int");
            /*
                strcpy(lexema.valor, lex);
                strcpy(lexema.tipodato, "int");
                strcpy(lexema.longitud, "0");
                strcpy(lexema.nombre, "_");
                strcat(lexema.nombre, lex);
            */
            break;
        case constFlt:
            lexema = convertirNumALexema(lexCopy, "float");
            /*
            strcpy(lexema.valor, lex);
            strcpy(lexema.tipodato, "float");
            strcpy(lexema.longitud, "0");
            strcpy(lexema.nombre, "_");
            strcat(lexema.nombre, lex);
            */
            break;
        case constStr:
            lexema = convertirStrALexema(lexCopy);
            break;
        case id:
            lexema = convertirIdALexema(lexCopy);
            /*
            strcpy(lexema.nombre, lex);
            strcpy(lexema.valor, "");
            strcpy(lexema.tipodato, "");
            strcpy(lexema.longitud, "");
            */
            break;
    }

    printf("\nSe va a insertar en la lista: (%s, %s, %s, %s)", lexema.nombre, lexema.tipodato, lexema.valor, lexema.longitud);
    insertarEnListaSinDuplicados(&lista_simbolos, lexema);
}

t_lexema convertirStrALexema(char* lex)
{
    t_lexema lexema;

    eliminar_caracteres(lex, '"');
    strcpy(lexema.valor, lex);
    strcpy(lexema.tipodato, "string");
    itoa(strlen(lex), lexema.longitud, 10);
    strcpy(lexema.nombre, "_");
    strcat(lexema.nombre, lex);

    return lexema;
}

t_lexema convertirNumALexema(char* lex, char* tipo)
{
    t_lexema lexema;

    strcpy(lexema.valor, lex);
    strcpy(lexema.tipodato, tipo);
    strcpy(lexema.longitud, "0");
    strcpy(lexema.nombre, "_");
    strcat(lexema.nombre, lex);

    return lexema;
}

t_lexema convertirIdALexema(char* lex)
{
    t_lexema lexema;

    strcpy(lexema.nombre, lex);
    strcpy(lexema.valor, "");
    strcpy(lexema.tipodato, "");
    strcpy(lexema.longitud, "");

    return lexema;
}

void eliminar_caracteres(char *s, char c)
{
    int writer = 0, reader = 0;

    while (s[reader])
    {
        if (s[reader]!=c) 
        {   
            s[writer++] = s[reader];
        }

        reader++;       
    }

    s[writer]=0;
}