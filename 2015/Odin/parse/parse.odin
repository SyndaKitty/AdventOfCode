package parse;

import "core:strconv"
import "core:strings"

TokenType :: enum
{
    Number,
    Word,
    Space,
    EndOfLine,
    EndOfFile,
    Colon,
    Comma
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
    info.search = {.Number,.Word,.EndOfLine,.EndOfFile};
    return info;
}


set_search_data :: proc(info: ^ParseInfo, search_data: SearchData)
{
    info.search = search_data;
}


@(private)
make_token :: proc(data: string, type: TokenType) -> Token
{
    token := Token{data=data, type=type};
    if type == .Number
    {
        token.number,_ = strconv.parse_int(data);
    }
    return token;
}


parse_next_config :: proc(info: ^ParseInfo) -> (Token, bool)
{
    return inline parse_next_parameter(info, info.search);
}


parse_next_parameter :: proc(info: ^ParseInfo, search_data: SearchData) -> (Token, bool)
{
    using info;

    for
    {
        if index >= len(input)
        {
            if info.done do return Token{}, false;
            info.done = true;
            return Token{type=.EndOfFile}, .EndOfFile in search_data;
        }

        c := input[index];

        switch c
        {
            case '0'..'9','-':
                token := read_number(info);
                if .Number in search_data do return token, true;
            case ' ':
                token := make_token(input[index:index],.Space);
                index += 1;
                if .Space in search_data do return token, true;
            case ':':
                token := make_token(input[index:index],.Colon);
                index += 1;
                if .Colon in search_data do return token, true;
            case ',':
                token := make_token(input[index:index],.Comma);
                index += 1;
                if .Comma in search_data do return token, true;
            case '\r':
                index += 1;
            case '\n':
                token := make_token(input[index:index],.EndOfLine);
                index += 1;
                if .EndOfLine in search_data do return token, true;
            case:
                token := read_word(info);
                if .Word in search_data do return token, true;
        }
    }

    return Token{}, false;
}


parse_next :: proc {parse_next_config, parse_next_parameter};


read_word :: proc(info: ^ParseInfo) -> Token
{
    using info;
    left := index;

    for
    {
        index += 1;
        if index >= len(input) do return make_token(input[left:index], .Word);
        switch input[index]
        {
            case ' ','\r','\n', ':', ',':
                return make_token(input[left:index], .Word);
            case:
                continue;
        }
    }
    return Token{};
}


read_number :: proc(info: ^ParseInfo) -> Token
{
    using info;
    left := index;

    for
    {
        index += 1;

        if index >= len(input) do return make_token(input[left:index], .Number);
        switch input[index]
        {
            case '0'..'9','-':
                continue;
            case:
                return make_token(input[left:index], .Number);
        }
    }
    return Token{};
}