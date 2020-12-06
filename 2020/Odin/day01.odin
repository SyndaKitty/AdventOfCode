package main

import "core:math"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:container"
import "core:time"
import "core:sys/windows"


// Custom libraries
import "../../libs/Odin/aoc"
import "../../libs/Odin/permute"
import "../../libs/Odin/parse"


main :: proc()
{
    input := string(#load("../inputs/01.txt"));

    using parse;
    parse_info := make_parse_info(input);
    parse_info.search = {TokenType.Word, TokenType.Number};

    ints := make([dynamic]int);

    for 
    {
        token,ok := parse_next(&parse_info);
        if !ok do break;
        
        // token.data;
        append(&ints, token.number);
    }

    for a,i in ints
    {
        for b,j in ints
        {
            for c,k in ints
            {
                if i != j && j != k && i != k && a + b + c == 2020
                {
                    fmt.println(a * b * c);
                    return;
                }
            }
        }
    }
}