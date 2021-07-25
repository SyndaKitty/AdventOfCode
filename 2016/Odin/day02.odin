package main

import "core:math"
import "core:fmt"
import "core:strings"
import "core:strconv"

import "../../libs/Odin/aoc"


main :: proc() {
    input := string(#load("../inputs/02.txt"));

    part_one(input);
    part_two(input);
}


part_one :: proc(input: string) {
    lines := strings.split(input, "\r\n");
    
    x := 1;
    y := 1;
    for line in lines {
        for c in line {
            switch c {
                case 'L': if x > 0 do x -= 1;
                case 'R': if x < 2 do x += 1;
                case 'U': if y > 0 do y -= 1;
                case 'D': if y < 2 do y += 1;
            }
        }
        fmt.print(y*3 + x + 1);
    }
    fmt.println();
}


part_two :: proc(input: string) {
    using aoc;

    x := -2;
    y := 0;

    positions := make(map[i64]rune);
    width := []int {0,1,2,1,0};
    keys := []rune {'1','2','3','4','5','6','7','8','9','A','B','C','D'};
    i := 0;
    for row in -2..2 {
        for col in -width[row]..width[row] {
            positions[hash_2D(col,row)] = keys[i];
            i += 1;
        }
    }
}