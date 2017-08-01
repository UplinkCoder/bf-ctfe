module bf_compiler;

import bf_parser;

enum TargetEnum
{
    AnonymousFunction,
}

string indentBy(const string line, const uint iLvl) pure
{
    char[] indent;
    indent.length = iLvl;

    foreach (i; 0 .. iLvl)
    {
        indent[i] = '\t';
    }

    return cast(string)(indent ~ line);
}

import bf_fastMath;

string itos(const uint val) pure
{
    immutable length = fastLog10(val) + 1;
    char[] result;
    result.length = length;

    foreach (i; 0 .. length)
    {
        immutable _val = val / fastPow10tbl[i];
        result[length - i - 1] = cast(char)((_val % 10) + '0');
    }

    return cast(string) result;
}

static assert(mixin(uint.max.itos) == uint.max);

string genCode(const RepeatedToken[] programm, const TargetEnum target, const uint cellSize = 4096) pure
{
    //	import std.conv : to;
    string result = `((const ubyte[] input){
	uint iPos, oPos;
	ubyte[] output; 
	ubyte[` ~ cellSize.itos ~ `] cells; 
	uint cellPtr = 0;
	output.length = 1024;` ~ "\n\n";

    uint iLvl = 1;

    if (target == TargetEnum.AnonymousFunction)
    {
        foreach (rt; programm)
        {
            final switch (rt.token) with (BFTokenEnum)
            {
            case LoopBegin:
                {
                    foreach (_; 0 .. rt.count)
                        result ~= "while(cells[cellPtr]) {\n".indentBy(iLvl++);
                }
                break;
            case LoopEnd:
                {
                    foreach (_; 0 .. rt.count)
                        result ~= "}\n".indentBy(--iLvl);
                }
                break;

            case IncVal:
                {
                    result ~= "cells[cellPtr] += ".indentBy(iLvl) ~ rt.count.itos ~ " ;\n";
                }
                break;
            case DecVal:
                {
                    result ~= "cells[cellPtr] -= ".indentBy(iLvl) ~ rt.count.itos ~ " ;\n";
                }
                break;

            case IncPtr:
                {
                    result ~= "cellPtr += ".indentBy(iLvl) ~ rt.count.itos ~ " ;\n";
                }
                break;
            case DecPtr:
                {
                    result ~= "cellPtr -= ".indentBy(iLvl) ~ rt.count.itos ~ " ;\n";
                }
                break;

            case InputVal:
                {
                    foreach (_; 0 .. rt.count)
                        result ~= "cells[cellPtr] = input[iPos++];\n".indentBy(iLvl);
                }
                break;
            case OutputVal:
                {
                    foreach (_; 0 .. rt.count)
                        result ~= "output[oPos++] = cells[cellPtr];\n".indentBy(iLvl);
                }
                break;

            case ProgrammBegin:
            case ProgrammEnd:
                break;
            }

        }

        return result ~ "\nreturn output[0 .. oPos];})";
    }

    assert(0, "Target Not supported: " ~ itos(target));
}
