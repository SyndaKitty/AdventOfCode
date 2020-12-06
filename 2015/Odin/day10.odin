package main

import "core:math"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:container"
import "core:time"


// Custom libraries
import "../../libs/Odin/aoc"
import "../../libs/Odin/permute"
import "../../libs/Odin/parse"


look_and_say:: proc(input: string) -> string
{
    output := strings.make_builder();
    last: rune;
    count := 1;
    length := len(input);
    
    for i := 0; i < length; i = i + 1
    {
        c := input[i];
        next := input[i+1] if i+1 < length else ' ';

        if c == next
        {
            count = count + 1;
        }
        else
        {
            strings.write_int(&output, count);
            strings.write_rune(&output, rune(c));
            count = 1;
        }
    }

    return strings.to_string(output);
}


main :: proc()
{
    input := string(#load("../inputs/10.txt"));

    pt2 :: true;

    result := input;
    iterations := 50 if pt2 else 40;

    for i := 0; i < iterations; i = i + 1 
    {
        result = look_and_say(result);
    }

    fmt.println(len(result));
}