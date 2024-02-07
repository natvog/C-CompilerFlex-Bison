/* Natalie Vogel
	12/5/2023
	CMSC 430 Project 4

   Merged code from project 2 and 3
   Added new attribute assignments

*/
/* Compiler Theory and Design
   Duane J. Jarc */

/* This file contains flex input file */

%{
#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws			   [ \t\r]+
comment		(\-\-.*\n)
comment2	   (\/\/.*\n)
line		   [\n]
id			   [A-Za-z][A-Za-z0-9]*([_]([A-Za-z0-9])+)*
digit		   [0-9]
int			{digit}+
real		   ({digit}+([.]{digit}*)+(["e"|"E"][+-]?{digit}+)?)
punc		   [\(\),:;]
%%

{ws}		   { ECHO; }
{comment}	{ ECHO; nextLine();}
{comment2}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"<"			{ ECHO; return(RELOP); }
">"			{ ECHO; return(RELOP); }
"="			{ ECHO; return(RELOP); }
"/="		   { ECHO; return(RELOP); }
"<="		   { ECHO; return(RELOP); }
">="		   { ECHO; return(RELOP); }
"-"			{ ECHO; return(ADDOP); }
"/"			{ ECHO; return(MULOP); }
"=>"		   { ECHO; return(ARROW); }
"+"			{ ECHO; return(ADDOP); }
"*"			{ ECHO; return(MULOP); }
rem			{ ECHO; return(REMOP); }
"**"		   { ECHO; return(EXPOP); }
or			   { ECHO; return(OROP); }
not			{ ECHO; return(NOTOP); }
begin		   { ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
end			{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function 	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is			   { ECHO; return(IS); }
reduce		{ ECHO; return REDUCE; }
returns		{ ECHO; return(RETURNS); }
and			{ ECHO; return(ANDOP); }
case		   { ECHO; return(CASE); }
else		   { ECHO; return(ELSE); }
endcase		{ ECHO; return(ENDCASE); }
endif		   { ECHO; return(ENDIF); }
if			   { ECHO; return(IF); }
others		{ ECHO; return(OTHERS); }
real		   { ECHO; return(REAL); }
then		   { ECHO; return(THEN); }
when		   { ECHO; return(WHEN); }
true        { ECHO; yylval.type = BOOL_TYPE; return(BOOL_LITERAL); }
false       { ECHO; yylval.type = BOOL_TYPE; return(BOOL_LITERAL); }
{id}		   { ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		   { ECHO; yylval.type = INT_TYPE; return(INT_LITERAL); }
{real}		{ ECHO; yylval.type = REAL_TYPE; return(REAL_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		      { ECHO; appendError(LEXICAL, yytext); }
%%
