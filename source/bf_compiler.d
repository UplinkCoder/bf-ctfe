﻿module bf_compiler;

import bf_parser;

enum TargetEnum {
	AnonymousFunction,

}

string indentBy(const string line, const uint iLvl) {
	char[] indent;
	indent.length = iLvl;

	foreach(i;0 .. iLvl) {
		indent[i] = '\t';
	}

	return cast(string)(indent) ~ line;
}

const(uint) fastLog10(const uint val) pure nothrow @nogc {
	return (val < 10) ? 0 : 
	(val < 100) ? 1 : 
	(val < 1000) ? 2 : 
	(val < 10000) ? 3 :
	(val < 100000) ? 4 :
	(val < 1000000) ? 5 :
	(val < 10000000) ? 6 :
	(val < 100000000) ? 7 :
	(val < 1000000000) ? 8 : 9;
}


const(string) itos(const uint val) pure {
	import std.math : log10;
	const length = cast(uint)fastLog10(val) + 1;
	char[] result = new char[](length);
	foreach(i;0 .. length) {
		const _val = val / (10 ^^ i);
		result[length-i-1] = cast(char) ((_val % 10) + '0'); 
	}

	return cast(const(string)) result;
}

string genCode(const RepeatedToken[] programm, const TargetEnum target, const uint cellSize = 4096) {
	string result = `((const ubyte[] input){uint iPos; ubyte[] output; ubyte[` ~ cellSize.itos ~ `] cells; ubyte* thisPtr = cells.ptr;` ~ "\n\n";
	uint iLvl = 1;


	if (target == TargetEnum.AnonymousFunction) {
		foreach(rt;programm) {
			final switch(rt.token) with (BFTokenEnum) {
				case LoopBegin : {
					foreach(_;0 .. rt.count) result ~= "while(*thisPtr) {\n".indentBy(iLvl++); 
				} break;
				case LoopEnd : {
					foreach(_;0 .. rt.count) result ~= "}\n".indentBy(--iLvl);
				} break;

				case IncVal : {
					result ~= "(*thisPtr) += ".indentBy(iLvl) ~ rt.count.itos ~" ;\n";
				} break;
				case DecVal : {
					result ~= "(*thisPtr) -= ".indentBy(iLvl) ~ rt.count.itos ~" ;\n";
				} break;

				case IncPtr : {
					result ~= "thisPtr += ".indentBy(iLvl) ~ rt.count.itos ~" ;\n";
				} break;
				case DecPtr : {
					result ~= "thisPtr -= ".indentBy(iLvl) ~ rt.count.itos ~" ;\n";
				} break;

				case InputVal : {
					foreach(_;0 .. rt.count) result ~= "*thisPtr = input[iPos++];\n".indentBy(iLvl);
				} break;
				case OutputVal : {
					foreach(_;0 .. rt.count) result ~= "output ~= *thisPtr;\n".indentBy(iLvl);
				} break;
				

				case ProgrammBegin :
				case ProgrammEnd :
					break;
			}

		}

		return result ~ "\nreturn output;})";
	}

	assert(0, "Target Not supported: " ~ itos(target));
}
