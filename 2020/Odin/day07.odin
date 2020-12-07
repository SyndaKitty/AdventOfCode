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

    input := string(#load("../inputs/07.txt"));
    //input,_ = strings.replace_all(input, "asd", "def");
    lines := strings.split(input, "\r\n");

    for line in lines
    {
        fmt.println(line);
    }


    // parse_info := parse.make_parse_info(input);
    // for parse.has_next(&parse_info)
    // {
    //     parse.next_rune(&parse_info);
    //     parse.next_number(&parse_info);
    //     parse.next_word(&parse_info);
    // }

    // for c in input
    // {
    //     switch c
    //     {
    //         case ' ':

    //     }
    // }

    fmt.println();
}