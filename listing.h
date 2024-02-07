/* 	Natalie Vogel
	12/5/2023
	CMSC 430 Project 4

*/
// Compiler Theory and Design
// Duane J. Jarc

// This file contains the function prototypes for the functions that produce the 
// compilation listing

enum ErrorCategories {LEXICAL, SYNTAX, GENERAL_SEMANTIC, DUPLICATE_IDENTIFIER,
	UNDECLARED};

void firstLine();
void nextLine();
int lastLine();
void appendError(ErrorCategories errorCategory, string message);

