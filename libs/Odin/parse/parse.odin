package parse;

import "core:fmt"
import "core:strconv"
import "core:strings"

TokenType :: enum
{
    Number,
    Word,
    Space,
    Colon,
    Comma,
    EndOfLine,
    EndOfFile
}


SearchData :: bit_set[TokenType];


ParseInfo :: struct
{
    index: int,
    input: string,
    search: SearchData,
    done: bool,
}


Token :: struct 
{
    data: string,
    type: TokenType,
    number: int
}


make_parse_info :: proc(input: string) -> ParseInfo
{
    info: ParseInfo;
    info.index = 0;
    info.input = input;
    info.search = {.Number,.Word};
    return info;
}


parse_next :: proc(info: ^ParseInfo) -> (Token, bool)
{
    using info;

    for
    {
        if index >= len(input)
        {
            if info.done do return Token{}, false;
            info.done = true;
            return Token{type=.EndOfFile}, .EndOfFile in info.search;
        }

        c := input[index];
        has_next := false;
        next_c: rune;
        if index + 1 < len(input)
        {
            has_next = true;
            next_c = rune(input[index + 1]);
        }

        switch c
        {
            case '0'..'9','-':
                token := consume_number(info);
                if .Number in info.search do return token, true;
            case ' ':
                token := make_token(input[index:index],.Space);
                index += 1;
                if .Space in info.search do return token, true;
            case ':':
                token := make_token(input[index:index],.Colon);
                index += 1;
                if .Colon in info.search do return token, true;
            case ',':
                token := make_token(input[index:index],.Comma);
                index += 1;
                if .Comma in info.search do return token, true;
            case '\r':
                index += 1;
            case '\n':
                token := make_token(input[index:index],.EndOfLine);
                index += 1;
                if .EndOfLine in info.search do return token, true;
            case:
                token := consume_word(info);
                if .Word in info.search do return token, true;
        }
    }

    return Token{}, false;
}


next_rune_specific :: proc(info: ^ParseInfo, r: rune) -> bool
{
    using info;
    for index < len(input)
    {
        index += 1;
        if rune(input[index-1]) == r
        {
            return true;
        }
    }
    return false;
}


next_rune_any :: proc(info: ^ParseInfo) -> rune
{
    using info;
    if index >= len(input)
    {
        fmt.println("Expecting rune but none remaining");
        assert(false);
    }
    
    r := rune(input[index]);
    index += 1;

    return r;
}


next_rune :: proc { next_rune_specific, next_rune_any };


next_word :: proc (info: ^ParseInfo) -> string
{
    tok,ok := parse_next(info);
    if !ok
    {
        fmt.println("Excepting word but no tokens remaining");
        assert(false);
    }
    if tok.type != .Word
    {
        fmt.println("Expecting word but got", tok.type, tok.data);
        assert(false);
    }
    return tok.data;
}


next_number :: proc(info: ^ParseInfo) -> int
{
    tok,ok := parse_next(info);
    if !ok 
    {
        fmt.println("Expecting number but no tokens remaining");
        assert(false);
    }
    if tok.type != .Number
    {
        fmt.println("Expecting number but got", tok.type, tok.data);
        assert(false);
    }
    return tok.number;
}


has_next :: proc(info: ^ParseInfo) -> bool
{
    // TODO: Kind of a hack to do it this way
    // change to push tokens onto a stack to be read later
    start_index := info.index;
    done := info.done;

    if done do return false;

    _,ok := parse_next(info);

    // Revert parse state changes
    info.index = start_index;
    info.done = done;

    return ok;
}


// Internal procs
make_token :: proc(data: string, type: TokenType) -> Token
{
    token := Token{data=data, type=type};
    if type == .Number
    {
        token.number,_ = strconv.parse_int(data);
    }
    return token;
}


consume_word :: proc(info: ^ParseInfo) -> Token
{
    using info;
    left := index;

    for
    {
        index += 1;
        if index >= len(input) do return make_token(input[left:index], .Word);
        switch input[index]
        {
            case ' ', '\r', '\n', ':', ',':
                return make_token(input[left:index], .Word);
            case:
                continue;
        }
    }
    return Token{};
}


consume_number :: proc(info: ^ParseInfo) -> Token
{
    using info;
    left := index;

    for
    {
        index += 1;

        if index >= len(input) do return make_token(input[left:index], .Number);
        switch input[index]
        {
            case '0'..'9':
                continue;
            case:
                return make_token(input[left:index], .Number);
        }
    }
    return Token{};
}