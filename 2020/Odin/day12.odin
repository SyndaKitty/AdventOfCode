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

    heading := 0;
    x := 0;
    y := 0;
    
    dir := map[rune]int {'E'=0, 'N'=1, 'W'=2, 'S'=3};

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