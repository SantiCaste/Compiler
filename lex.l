%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
FILE *yyin;
int yylval;

void guardar_en_TS();

void mostrar_token_inutil();

%}

%option noyywrap
%option yylineno 

/* Conjuntos */
DIGITO [0-9]
DIGITONOCERO [1-9]
/*
MINUS [a-z]
MAYUS [A-Z]
*/
LETRA [a-zA-Z]
PUNTO ["."]

/* Regex */
OLD_CONST_REAL {DIGITO}+"."{DIGITO}+
OLD_CONST_INT {DIGITO}+


CONST_REAL -?({DIGITO}*{PUNTO}{DIGITO}* | {DIGITO}+{PUNTO}{DIGITO}*)
CONST_INT  (-?{DIGITONOCERO}{DIGITO}+)|0
CONST_STR \"[^"]*\"
ID {LETRA}({LETRA}|{DIGITO}|_)*

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
OP_AND  "&&"
OP_OR   "||"
OP_NOT  "!"

/* Caracteres */
PAR_OP      "("
PAR_CL      ")"
CORCHETE_OP  "["
CORCHETE_CL  "]"
LLAVE_OP    "{"
LLAVE_CL    "}"
COMA        ","
COLON       ":"

/* Palabras Reservadas */
IF          "else"
ELSE        "if"
WHILE       "for"
T_INT       "int"
T_FLOAT     "float"
T_STRING    "string"

/* Comentarios */
COMENTARIO "###"[^###]*"###"

%%
"define"        {printf("\nDefine: %s\n", yytext); }
"enddefine"     {printf("\nEndefine: %s\n", yytext); }
":="            {printf("\nAsignacion: %s\n", yytext); }
"+"             {printf("\nSuma: %s\n", yytext); }
{ID}            {printf("\nIdentificador: %s\n", yytext); guardar_en_TS ();}
{CONST_REAL}    {printf("\nConstante real: %s\n", yytext); }
{CONST_INT}     {printf("\nConstante entera: %s\n", yytext); }

"\n"      		{mostrar_token_inutil(); }
"\t"      		{mostrar_token_inutil(); }
"\n\t"          {mostrar_token_inutil(); }
" "             {mostrar_token_inutil(); }		
"\r\n"      	{mostrar_token_inutil(); }

%%

void mostrar_token_inutil(){
    printf("\nToken no procesable: %s\n", yytext);
}

void guardar_en_TS(){
    printf("Guarda en TS");
}


int main(int argc,char *argv[])
{
    if ((yyin = fopen(argv[1], "rt")) == NULL) {
        printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
        
    }

    yylex();
    fclose(yyin);
}