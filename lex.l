%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
FILE *yyin;
int yylval;

void guardar_en_TS(){
    printf("Guarda en TS");
}

%}

%option noyywrap
%option yylineno 

DIGITO [0-9]
LETRA [a-zA-Z]

CONST_REAL {DIGITO}+"."{DIGITO}+
CONST_INT {DIGITO}+
ID {LETRA}({LETRA}|{DIGITO}|_)*

%%
"define"        {printf("\nDefine: %s\n", yytext); return 0;}
"enddefine"     {printf("\nEndefine: %s\n", yytext); return 0;}
":="            {printf("\nAsignacion: %s\n", yytext); return 0;}
"+"             {printf("\nSuma: %s\n", yytext); return 0;}
{ID}            {printf("\nIdentificador: %s\n", yytext); guardar_en_TS (); return 0;}
{CONST_REAL}    {printf("\nConstante real: %s\n", yytext); return 0;}
{CONST_INT}     {printf("\nConstante entera: %s\n", yytext); return 0;}
%%



int main(int argc,char *argv[])
{
    if ((yyin = fopen(argv[1], "rt")) == NULL) {
        printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
        return 0;
    }

    yylex();
    fclose(yyin);
}