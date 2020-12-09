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


check_for_sum :: proc(numbers: []int, sum: int) -> bool
{
    for i := 0; i < len(numbers); i += 1
    {
        for j := 0; j < len(numbers); j += 1
        {
            if i == j do continue;
            if numbers[i] + numbers[j] == sum do return true;
        }
    }
    return false;
}

main :: proc()
{
    using aoc;
    using parse;

    input := string(#load("../inputs/09.txt"));
    lines := strings.split(input, "\r\n");

    preamble_size :: 25;

    numbers: [dynamic]int;

    begin := 0;
    end := 0;

    for line in lines 
    {
        //fmt.println(line, begin, end);
        
        number,ok := strconv.parse_int(line);
        end += 1;
        if end - begin > preamble_size
        {
            //fmt.println("Checking", numbers[begin:], "for", number);
            if !check_for_sum(numbers[begin:], number)
            {
                fmt.println("ERROR ON", number);
            }
            begin += 1;
        }
        
        append(&numbers, number);
    }

    fmt.println();

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