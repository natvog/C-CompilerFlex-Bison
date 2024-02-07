/* 	Natalie Vogel
	12/5/2023
	CMSC 430 Project 4

	edited lastLine(), appendError(), and displayErrors()
		- lastLine() now displays total errors by type
		- appendError() pushes errors to errorQueue and increments total errors by type
		- displayErrors() first prints errors per line, then pops them from queue to clear for next line

*/
// Compiler Theory and Design
// Dr. Duane J. Jarc

// This file contains the bodies of the functions that produces the compilation
// listing

#include <cstdio>
#include <string>
#include <queue>
#include <iostream>

using namespace std;

#include "listing.h"

static int lineNumber;
static string error = "";
static int totalErrors = 0;
static int totalLexicalErrors = 0;
static int totalSyntaxErrors = 0;
static int totalSemanticErrors = 0;
static queue <string> errorQueue;

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\r");
	printf("     \n");
	if (totalLexicalErrors != 0 || totalSyntaxErrors != 0 || totalSemanticErrors != 0) {
		cout << "\nLexical Errors: " << totalLexicalErrors;
		cout << "\nSyntax Errors: " << totalSyntaxErrors;
		cout << "\nSemantic Errors: " << totalSemanticErrors;
	}
	else {
		cout << "\nCompiled Successfully";
	}	
	printf("     \n");
	return totalErrors;
}
    
void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared " };

	error = messages[errorCategory] + message;
    errorQueue.push(error);

	if (errorCategory == 0) {
		totalLexicalErrors++;
	}
	if (errorCategory == 1) {
		totalSyntaxErrors++;
	}
	if (errorCategory == 2 || errorCategory == 3 || errorCategory == 4) {
		totalSemanticErrors++;
	}


}

void displayErrors()
{
	while (!errorQueue.empty()) {
        cout << errorQueue.front();
        errorQueue.pop();
		cout << '\n';
	}
}
