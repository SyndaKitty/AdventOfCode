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
    input := string(#load("../inputs/11.txt"));
    
    lines := strings.split(input, "\r\n");
    width := len(lines[0]);
    height := len(lines);

    state := make(map[i64]rune);

    x := 0;
    y := 0;
    for line in lines
    {
        for c in line
        {
            state[aoc.hash_2D(x, y)] = c;
            x += 1;
        }
        x = 0;
        y += 1;
    }

    //print_state(state, width, height);
    part_one(state, width, height);
}


count_neighbors :: proc(state: map[i64]rune, x,y: int) -> int
{
    offset_x := []int { 1, 1, 0, -1, -1, -1, 0,   1 };
    offset_y := []int { 0, 1, 1,  1,  0, -1, -1, -1 };

    count := 0;
    for o in 0..<8
    {
        seat,ok := state[aoc.hash_2D(x+offset_x[o], y+offset_y[o])];
        if ok && seat == '#'
        {
            count += 1;
        }
    }
    return count;
}


print_state :: proc(state: map[i64]rune, w,h: int)
{
    for y in 0..<h 
    {
        for x in 0..<w 
        {
            fmt.print(state[aoc.hash_2D(x, y)]);
        }
        fmt.println();
    }
    fmt.println();
}

part_one :: proc(state: map[i64]rune, width: int, height: int)
{   
    old_state := state;
    new_state := make(map[i64]rune);

    for 
    {
        changed := false;
        for y in 0..<height
        {
            for x in 0..<width
            {
                c := count_neighbors(state, x, y);
                s := old_state[aoc.hash_2D(x, y)];
                if s == 'L' && c == 0
                {
                    new_state[aoc.hash_2D(x, y)] = '#';
                    changed = true;
                }
                else if s == '#' && c >= 4
                {
                    new_state[aoc.hash_2D(x, y)] = 'L';
                    changed = true;   
                }
            }
        }

        if !changed
        {
            c := 0;
            for key, value in new_state
            {
                if value == '#' do c += 1;
            }
            fmt.println(c);
            return;
        }

        //print_state(new_state, width, height);

        for key, value in new_state
        {
            old_state[key] = value;
        }
    }
}