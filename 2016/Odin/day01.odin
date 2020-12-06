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


manhattan_distance :: proc(x, y: int) -> int
{
    return abs(x) + abs(y);
}


main :: proc()
{
    using aoc;

    input := string(#load("../inputs/01.txt"));

    facing := 1;
    x := 0;
    y := 0;

    visited_locations := make(map[i64]bool);
    directions := strings.split(input, ", ");

    for direction in directions
    {
        //fmt.print(direction, x, y, facing, "->");
        if direction[0] == 'R'
        {
            facing = (facing - 1) %% 4;
        }
        else
        {
            facing = (facing + 1) %% 4;
        }

        units,_ := strconv.parse_int(direction[1:]);
        for i in 0..<units
        {
            x += int_cos[facing];
            y += int_sin[facing];

            location_hash := hash_2D(x, y);
            if location_hash in visited_locations
            {
                fmt.println(manhattan_distance(x, y));
                return;
            }
            visited_locations[location_hash] = true;
        }

        //fmt.println(x, y, facing);
    }
}