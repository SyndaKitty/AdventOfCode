package main

import "core:fmt"
import "core:strings"
import "core:strconv"

// Custom libraries
import "../../libs/Odin/aoc"


main :: proc()
{
    using aoc;
    input := string(#load("../inputs/03.txt"));
    max_block,_ := strconv.parse_int(input);

    pos := Vector2{0, 0};
    len := 1;
    dir := 1;
    block := 1;
    outer: for {
        for i in 1..len {
            pos += Vector2{1, 0} * dir;
            block += 1;
            if block == max_block do break outer;
        }
        for i in 1..len {
            pos += Vector2{0, 1} * dir;
            block += 1;
            if block == max_block do break outer;
        }
        len += 1;
        dir *= -1;
    }

    fmt.println(abs(pos[0]) + abs(pos[1]));
}