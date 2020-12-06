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


main :: proc()
{
    input := string(#load("../inputs/01.txt"));

    pt2 :: true;
    position := 1;
    reached_basement := false;

    floor : int;
    for c in input 
    {
        if c == '(' do floor = floor + 1;
        else
        if c == ')' do floor = floor - 1;
        else
        do fmt.println("Invalid character:", c);

        if pt2 && !reached_basement
        {
            if floor < 0 
            {
                fmt.println("Reached basement at position:", position);
                reached_basement = true;
            }
            position = position + 1;
        }
    }

    fmt.println("Final floor:", floor);
}