/* 	Natalie Vogel
	12/5/2023
	CMSC 430 Project 4

	Merged code from project 2 and 3
	Added new semantic rules
	Added method calls from types.cc for checks

*/
/* Compiler Theory and Design
   Duane J. Jarc */

%{

#include <string>
#include <vector>
#include <map>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<Types> symbols;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER
%token <type> INT_LITERAL
%token <type> REAL_LITERAL
%token <type> BOOL_LITERAL

%token ADDOP MULOP RELOP REMOP ARROW EXPOP NOTOP ANDOP OROP
%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS CASE ELSE ENDCASE ENDIF IF OTHERS REAL THEN WHEN

%type <type> type statement statement_ reductions expression and_expression relation term
	factor exponent not primary if case one_case variable function_header_ body function 
	function_header error

%type <type> when_clauses

%%

function:	
	function_header_ optional_variable body { 
		// check for function narrowing
        checkAssignment($1, $3, "Function Return");
   	};

function_header_:
	function_header |
	error ';' ;
	
function_header:	
	FUNCTION IDENTIFIER optional_parameter RETURNS type ';' {
        // capture the return type and pass it up the parse tree
        $$ = $5;
    };

optional_variable:
	optional_variable variable_ |
	;

variable_:
	variable |
	error ';' ;

variable:	
	IDENTIFIER ':' type IS statement_ 
		{ // check for duplicate variable before inserting into the symbol table
        	if (symbols.find($1, $$)) {
            	appendError(DUPLICATE_IDENTIFIER, "Duplicate variable: " + string($1));
           		$$ = MISMATCH;
       	 	} else {
				checkAssignment($3, $5, "Variable Initialization");
				symbols.insert($1, $3);} 
		};

optional_parameter:
	optional_parameter multiple_parameters |
	;

multiple_parameters:
	parameter |
	multiple_parameters ',' parameter ;

parameter:
	IDENTIFIER ':' type ;

type:
	INTEGER {$$ = INT_TYPE;} |
	BOOLEAN {$$ = BOOL_TYPE;} |
	REAL {$$ = REAL_TYPE;} ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' |
	if  |
	case |
	error ';' {$$ = MISMATCH;} ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} ;

if:
	IF expression THEN statement_ ELSE statement_ ENDIF ';' {checkIf($2); checkIfMatch($4, $6);} {$$ = ($2) ? $4 : $6;} ;

case:
	CASE expression IS when_clauses OTHERS ARROW statement_ ENDCASE ';' {
		checkCaseInt($2);
        if ($4 != UNDETERMINED) {
            $$ = $4;
        } else {
            $$ = $7;
        }
    };

when_clauses:
    when_clauses one_case {
        if ($1 != UNDETERMINED && $2 != UNDETERMINED && $1 != $2) {
            appendError(GENERAL_SEMANTIC, "Case Types Mismatch");
            $$ = MISMATCH;
        } else {
            $$ = ($1 != UNDETERMINED) ? $1 : $2;
        }
    } |
    {
        $$ = UNDETERMINED;
    }
    | error ';' {
        $$ = MISMATCH;
    };

one_case:
    WHEN INT_LITERAL ARROW statement ';' {
        $$ = ($<type>-2 == INT_TYPE) ? $4 : MISMATCH;
    } |
    WHEN INT_LITERAL ARROW case {
        $$ = ($<type>-2 == INT_TYPE) ? $4 : MISMATCH;
    };

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ {$$ = checkArithmetic($1, $2);} |
	{$$ = INT_TYPE;} ;

expression:
	expression OROP and_expression {$$ = checkLogical($1, $3);} | 
	and_expression ;
		    
and_expression:
	and_expression ANDOP relation {$$ = checkLogical($1, $3);} |
	relation ;

relation:
	relation RELOP term {$$ = checkRelational($1, $3);}|
	term ;

term:
	term ADDOP factor {$$ = checkArithmetic($1, $3);} |
	factor ;
      
factor:
	factor MULOP exponent {$$ = checkArithmetic($1, $3);} |
	factor REMOP exponent {$$ = checkRemainder($1, $3);} |
	exponent ;

exponent:
	not | 
	not EXPOP exponent {$$ = checkArithmetic($1, $3);} ;

not:
	primary |
	NOTOP not {$$ = checkLogical($2, $2);} ;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL |
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
