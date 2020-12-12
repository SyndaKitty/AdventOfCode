package main

import "core:fmt"
import "core:strings"
import "core:strconv"

// Custom libraries
import "../../libs/Odin/aoc"

main :: proc()
{
    input := string(#load("../inputs/12.txt"));
    lines := strings.split(input, "\r\n");

    part_one(lines);
    part_two(lines);
}

dir := map[rune]int {'E'=0, 'N'=1, 'W'=2, 'S'=3};
Vector2 :: [2]int;

part_one :: proc(lines: []string)
{
    using aoc;
    heading := 0;
    pos := Vector2{0, 0};

    for line in lines
    {
        instruction := rune(line[0]);
        amount,_ := strconv.parse_int(line[1:]);

        switch instruction
        {
            case 'N','E','S','W':
                h := dir[instruction];
                pos += Vector2{int_cos[h], int_sin[h]} * amount;
            case 'R':
                heading -= int(amount / 90);
            case 'L':
                heading += int(amount / 90);
            case 'F':
                heading %%= 4;
                pos += Vector2{int_cos[heading], int_sin[heading]} * amount;
        }
    }

    fmt.println(abs(pos[0]) + abs(pos[1]));
}

part_two :: proc(lines: []string)
{
    using aoc;
    // The waypoint's position can be thought of as 
    //  a velocity that we apply with the command F
    vel := Vector2{10, 1};
    pos := Vector2{0, 0};

    for line in lines
    {
        instruction := rune(line[0]);
        amount,_ := strconv.parse_int(line[1:]);

        switch instruction
        {
            case 'N','E','S','W':
                h := dir[instruction];
                vel += Vector2{int_cos[h], int_sin[h]} * amount;
            case 'L':
                for i in 1..int(amount/90)
                {
                    vel[0], vel[1] = -vel[1], vel[0];
                }
            case 'R':
                 for i in 1..int(amount/90)
                 {
                    vel[0], vel[1] = vel[1], -vel[0];
                 }
            case 'F':
                pos += vel * amount;
        }
    }

    fmt.println(abs(pos[0]) + abs(pos[1]));
}