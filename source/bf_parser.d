module bf_parser;

enum BFTokenEnum
{
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

struct RepeatedToken
{
    uint _token;
    alias _token this;

    @property BFTokenEnum token() const pure
    {
        return cast(BFTokenEnum)(_token >> 24);
    }

    @property uint count() const pure
    {
        return _token & 0x00_FF_FF_FF;
    }
}

RepeatedToken Token(BFTokenEnum token) pure
{
    return cast(RepeatedToken)(token << 24 | 1);
}
/+
represent RepeatedToken as uint
[0 .. 24] count
[24 .. 32] token
+/

const(RepeatedToken[]) parseBf(const string input) pure
{
    uint pos;
    RepeatedToken[] result = [Token(BFTokenEnum.ProgrammBegin)];

    while (pos < input.length)
    {
        final switch (input[pos++]) with (BFTokenEnum)
        {
        case '>':
            if ((result[$ - 1] & 0xFF_00_00_00) >> 24 == IncPtr)
            {
                result[$ - 1]++;
            }
            else
            {
                result ~= [Token(IncPtr)];
            }
            break;
        case '<':
            if ((result[$ - 1] & 0xFF_00_00_00) >> 24 == DecPtr)
            {
                result[$ - 1]++;
            }
            else
            {
                result ~= [Token(DecPtr)];
            }
            break;
        case '+':
            if ((result[$ - 1] & 0xFF_00_00_00) >> 24 == IncVal)
            {
                result[$ - 1]++;
            }
            else
            {
                result ~= [Token(IncVal)];
            }
            break;
        case '-':
            if ((result[$ - 1] & 0xFF_00_00_00) >> 24 == DecVal)
            {
                result[$ - 1]++;
            }
            else
            {
                result ~= [Token(DecVal)];
            }
            break;
        case '.':
            if ((result[$ - 1] & 0xFF_00_00_00) >> 24 == OutputVal)
            {
                result[$ - 1]++;
            }
            else
            {
                result ~= [Token(OutputVal)];
            }
            break;
        case ',':
            if ((result[$ - 1] & 0xFF_00_00_00) >> 24 == InputVal)
            {
                result[$ - 1]++;
            }
            else
            {
                result ~= [Token(InputVal)];
            }
            break;
        case '[':
            if ((result[$ - 1] & 0xFF_00_00_00) >> 24 == LoopBegin)
            {
                result[$ - 1]++;
            }
            else
            {
                result ~= [Token(LoopBegin)];
            }
            break;
        case ']':
            if ((result[$ - 1] & 0xFF_00_00_00) >> 24 == LoopEnd)
            {
                result[$ - 1]++;
            }
            else
            {
                result ~= [Token(LoopEnd)];
            }
            break;
        case '\r':
            pos++;
            goto case '\n';
        case '\n':
            //TODO handle lines and proper position informmation;
            break;
        }
    }

    return result ~ [Token(BFTokenEnum.ProgrammEnd)];
}

pragma(msg, parseBf("[,....]")[3].token);
