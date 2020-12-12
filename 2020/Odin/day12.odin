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
    input := string(#load("../inputs/12.txt"));
    lines := strings.split(input, "\r\n");

    part_two(lines);
}

dir := map[rune]int {'E'=0, 'N'=1, 'W'=2, 'S'=3};

part_one :: proc(lines: []string)
{
    heading := 0;
    x := 0;
    y := 0;

    for line in lines
    {
        instruction := rune(line[0]);
        amount,_ := strconv.parse_int(line[1:]);

        switch instruction
        {
            case 'N','E','S','W':
                h := dir[instruction];
                x += aoc.int_cos[h] * amount;
                y += aoc.int_sin[h] * amount;
            case 'R':
                heading -= int(amount / 90);
            case 'L':
                heading += int(amount / 90);
            case 'F':
                x += aoc.int_cos[heading %% 4] * amount;
                y += aoc.int_sin[heading %% 4] * amount;
        }
    }

    fmt.println(abs(x) + abs(y));
}

Vector2 :: [2]int;
part_two :: proc(lines: []string)
{
    // The waypoint's position can be thought of as 
    //  a velocity that we apply with the command F
    vx := 10;
    vy := 1;
    x := 0;
    y := 0;

    for line in lines
    {
        instruction := rune(line[0]);
        amount,_ := strconv.parse_int(line[1:]);

        switch instruction
        {
            case 'N','E','S','W':
                h := dir[instruction];
                vx += aoc.int_cos[h] * amount;
                vy += aoc.int_sin[h] * amount;
            case 'L':
                for i in 1..int(amount/90)
                {
                    vx, vy = -vy, vx;
                }
            case 'R':
                for i in 1..int(amount/90)
                {
                    vx, vy = vy, -vx;
                }
            case 'F':
                x += vx * amount;
                y += vy * amount;
        }
    }

    fmt.println(abs(x) + abs(y));
}