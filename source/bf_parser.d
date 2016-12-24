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
	BFTokenEnum token;
	uint count = 1;
}

const(RepeatedToken[]) parseBf(const string input) pure {
	uint pos;
	RepeatedToken[] result = [RepeatedToken(BFTokenEnum.ProgrammBegin, 0)];


	while(pos != input.length) {	
		final switch(input[pos++]) with (BFTokenEnum) {
			case '>' :
				if (result[$-1].token == IncPtr) {
					result[$-1].count++;
				} else {
					result ~= RepeatedToken(IncPtr);
				}
			break;
			case '<' :
				if (result[$-1].token == DecPtr) {
					result[$-1].count++;
				} else {
					result ~= RepeatedToken(DecPtr);
				} 
			break;
			case '+' :
				if (result[$-1].token == IncVal) {
					result[$-1].count++;
				} else {
					result ~= RepeatedToken(IncVal);
				}
			break;
			case '-' :
				if (result[$-1].token == DecVal) {
					result[$-1].count++;
				} else {
					result ~= RepeatedToken(DecVal);
				} 
			break;
			case '.' :
				if (result[$-1].token == OutputVal) {
					result[$-1].count++;
				} else {
					result ~= RepeatedToken(OutputVal);
				}
			break;
			case ',' :
				if (result[$-1].token == InputVal) {
					result[$-1].count++;
				} else {
					result ~= RepeatedToken(InputVal);
				}
			break;
			case '[' :
				if (result[$-1].token == LoopBegin) {
					result[$-1].count++;
				} else {
					result ~= RepeatedToken(LoopBegin);
				}
			break;
			case ']' :
				if (result[$-1].token == LoopEnd) {
					result[$-1].count++;
				} else {
					result ~= RepeatedToken(LoopEnd);
				}
			break;
			case '\r' : pos++;
			goto case '\n';
			case '\n' :
				//TODO handle lines and proper position informmation;
			break;
		}
	}

	return result ~ RepeatedToken(BFTokenEnum.ProgrammEnd, 0);
}
