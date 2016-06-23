module bf_compiler;

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

string genCode(const RepeatedToken[] programm, const TargetEnum target, const uint cellSize = 4096) {
	import std.conv : to;
	string result = `((const ubyte[] input){ ubyte[] output; ubyte[` ~ cellSize.to!string ~ `] cells; ubyte* thisPtr = cells.ptr;` ~ "\n\n";
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
					foreach(_;0 .. rt.count) result ~= "(*thisPtr)++;\n".indentBy(iLvl);
				} break;
				case DecVal : {
					foreach(_;0 .. rt.count) result ~= "(*thisPtr)--;\n".indentBy(iLvl);
				} break;

				case IncPtr : {
					foreach(_;0 .. rt.count) result ~= "thisPtr++;\n".indentBy(iLvl);
				} break;
				case DecPtr : {
					foreach(_;0 .. rt.count) result ~= "thisPtr--;\n".indentBy(iLvl);
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

		return result ~ "return output;})";
	}

	assert(0, "Target Not supported: " ~ to!string(target));
}