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

/**
represent RepeatedToken as uint
[0 .. 24] count
[24 .. 32] token
*/
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

const(RepeatedToken[]) parseBf(const string input) pure
{
    uint pos;
    RepeatedToken[] result;
    result.length = input.length + 2;
    // the maximal number of diffrent tokens is equal to the chars in the input
    // plus the begin and end token

    result[0] = Token(BFTokenEnum.ProgrammBegin);
    uint resultLen = 0;

    while (pos < input.length)
    {
        uint lastToken = (result[resultLen] >> 24);
        uint thisToken = BFTokenEnum.ProgrammEnd;
        switch (input[pos++]) with (BFTokenEnum)
        {
        case '>':
            thisToken = IncPtr;
            break;
        case '<':
            thisToken = DecPtr;
            break;
        case '+':
            thisToken = IncVal;
            break;
        case '-':
            thisToken = DecVal;
            break;
        case '.':
            thisToken = OutputVal;
            break;
        case ',':
            thisToken = InputVal;
            break;
        case '[':
            thisToken = LoopBegin;
            break;
        case ']':
            thisToken = LoopEnd;
            break;
        case '\r':
            pos++;
            goto case '\n';
        case '\n':
            //TODO handle lines and proper position informmation;
            break;
        default : break;
            // igonre non-bf input
        }


        if (lastToken == thisToken)
        {
            result[resultLen]++;
        }
        else if (thisToken != BFTokenEnum.ProgrammEnd)
        {
            result[++resultLen] = Token(cast(BFTokenEnum)thisToken);
        }

    }

    result[++resultLen] = Token(BFTokenEnum.ProgrammEnd);
    return result[0 .. resultLen + 1];
}
