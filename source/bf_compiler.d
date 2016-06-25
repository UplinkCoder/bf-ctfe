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

	return cast(string)(indent ~ line);
}



/**
 * It returns a slice from a mutable buffer.
 * Meaning if you keep thr return value around,
 * it will change after a second call to itos
 * This could also have funny effects when uses with fibers.
 */ 
import bf_fastMath;

string itos(const uint val) pure {
	const length = cast(uint)fastLog10(val) + 1;
	static const char[10] _result;
	char[] result;

	if (__ctfe) {
		result = new char[](length);
	} else {
		result = cast(char[10]) _result;
	}
	foreach(i;0 .. length) {
		immutable _val = val / fastPow10(i);
		result[length-i-1] = cast(char) ((_val % 10) + '0'); 
	}

	return cast(const(string)) result[0 .. length];
}

static assert(mixin(uint.max.itos) == uint.max);

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
