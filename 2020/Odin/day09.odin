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
    using aoc;
    using parse;

    input := string(#load("../inputs/09.txt"));
    lines := strings.split(input, " ");

    for line in lines 
    {
        fmt.println(line);
    }



    // parse_info := make_parse_info(input);
    // for has_next(&parse_info)
    // {
    //     next_word(&parse_info);
    //     next_number(&parse_info);
    //     next_rune(&parse_info);
    // }



    // for c in input
    // {
    //     switch c
    //     {
    //         case ' ':

    //     }
    // }
}