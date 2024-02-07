/* 	Natalie Vogel
	12/5/2023
	CMSC 430 Project 4

	Added methods for checks
	Modified checkArithmetic method for real literals
	Modified checkAssignment method for illegeal narrowing

*/
// Compiler Theory and Design
// Duane J. Jarc

// This file contains the bodies of the type checking functions

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

void checkAssignment(Types lValue, Types rValue, string message)
{
	if (lValue == INT_TYPE && rValue == REAL_TYPE) 
	{
	   appendError(GENERAL_SEMANTIC, "Illegal Narrowing on " + message);
	}
	if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue)
	{
	   appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
    }
}

Types checkArithmetic(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Numeric Type Required");
		return MISMATCH;
	}
	if (left == REAL_TYPE || right == REAL_TYPE)
		return REAL_TYPE;
	return INT_TYPE;
}


Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left != BOOL_TYPE || right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}	
		return BOOL_TYPE;
	return MISMATCH;
}

Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH)
		return MISMATCH;
	return BOOL_TYPE;
}

Types checkRemainder(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left != INT_TYPE || right != INT_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Remainder Operator Requires Integer Operands");
		return MISMATCH;
	}
	return INT_TYPE;
}

Types checkIf(Types expression) 
{
	if (expression != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "If Expression Must Be Boolean");
		return MISMATCH;
	}
	if (expression == REAL_TYPE)
		return REAL_TYPE;
	return INT_TYPE;
}

Types checkIfMatch(Types first, Types second) 
{
	if (first == MISMATCH || second == MISMATCH)
		return MISMATCH;
	if ((first == INT_TYPE && second != INT_TYPE) || (first == REAL_TYPE && second != REAL_TYPE) || (first == BOOL_TYPE && second != BOOL_TYPE)) 
	{
		appendError(GENERAL_SEMANTIC, "If-Then Type Mismatch");
		return MISMATCH;
	}
}

Types checkCaseInt(Types variable)
{
	if (variable != INT_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Case Expression Not Integer");
		return MISMATCH;
	}
	return INT_TYPE;
}
