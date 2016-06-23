module bf_parser;

enum BFTokenEnum {
	IncPtr = '>',
	DecPtr = '<',
	IncVal = '+',
	DecVal = '-',
	OutputVal = '.',
	InputVal = ',',
	LoopBegin = '[',
	LoopEnd = ']',

	ProgrammBegin,
	ProgrammEnd,
}

struct RepeatedToken {
	uint position;
	BFTokenEnum token;
	uint count = 1;
}

const(RepeatedToken[]) parseBf(const string input) pure {
	uint pos;
	RepeatedToken[] result = [RepeatedToken(pos, BFTokenEnum.ProgrammBegin, 0)];


	while(pos != input.length - 1) {	
		final switch(input[pos++]) with (BFTokenEnum) {
			case '>' :
				if (result[$-1].token == IncPtr) {
					result[$-1].count++;
				} else {
					result ~= RepeatedToken(pos, IncPtr);
				}
			break;
			case '<' :
				if (result[$-1].token == DecPtr) {
					result[$-1].count++;
				} else {
					result ~= RepeatedToken(pos, DecPtr);
				} 
			break;
			case '+' :
				if (result[$-1].token == IncVal) {
					result[$-1].count++;
				} else {
					result ~= RepeatedToken(pos, IncVal);
				}
			break;
			case '-' :
				if (result[$-1].token == DecVal) {
					result[$-1].count++;
				} else {
					result ~= RepeatedToken(pos, DecVal);
				} 
			break;
			case '.' :
				if (result[$-1].token == OutputVal) {
					result[$-1].count++;
				} else {
					result ~= RepeatedToken(pos, OutputVal);
				}
			break;
			case ',' :
				if (result[$-1].token == InputVal) {
					result[$-1].count++;
				} else {
					result ~= RepeatedToken(pos, InputVal);
				}
			break;
			case '[' :
				if (result[$-1].token == LoopBegin) {
					result[$-1].count++;
				} else {
					result ~= RepeatedToken(pos, LoopBegin);
				}
			break;
			case ']' :
				if (result[$-1].token == LoopEnd) {
					result[$-1].count++;
				} else {
					result ~= RepeatedToken(pos, LoopEnd);
				}
			break;
			case '\r' : pos++;
			goto case '\n';
			case '\n' :
				//TODO handle lines and proper position informmation;
			break;
		}
	}

	return result ~ RepeatedToken(pos, BFTokenEnum.ProgrammEnd, 0);
}
