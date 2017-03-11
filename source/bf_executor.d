module bf_executor;

import bf_parser;
import bf_analyzer;
import bf_compiler;

/**
 If the Bf-Programm does not use any input;
 This template aliases itself to the output of the program.
 Otherwise It aliases itself to a function representing the program. 
*/

template execute(string programm)
{
    enum parsed = parseBf(programm);
    static if (usesInput(parsed))
    {
        enum execute = mixin(parsed.genCode(TargetEnum.AnonymousFunction));
    }
    else
    {
        enum execute = mixin(parsed.genCode(TargetEnum.AnonymousFunction))([]);
    }

}
