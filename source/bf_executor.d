module bf_executor;


import bf_parser;
import bf_compiler;

const (ubyte[]) execute(string programm)(const ubyte[] input = []) pure {
	const parsed = parseBf(programm);
	auto fun = mixin(parsed.genCode(TargetEnum.AnonymousFunction));
	return fun(input);
}
