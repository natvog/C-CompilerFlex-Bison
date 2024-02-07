/* 	Natalie Vogel
	12/5/2023
	CMSC 430 Project 4

    Added UNDETERMINDED literal to enumeration for case checks

*/
// Compiler Theory and Design
// Duane J. Jarc

// This file contains type definitions and the function
// prototypes for the type checking functions

typedef char* CharPtr;

enum Types {MISMATCH, INT_TYPE, BOOL_TYPE, REAL_TYPE, UNDETERMINED};

void checkAssignment(Types lValue, Types rValue, string message);
Types checkArithmetic(Types left, Types right);
Types checkLogical(Types left, Types right);
Types checkRelational(Types left, Types right);
Types checkRemainder(Types left, Types right);
Types checkIf(Types expression);
Types checkIfMatch(Types first, Types second);
Types checkCaseInt(Types variable);
