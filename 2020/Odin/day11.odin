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

    start_state: map[i64]rune;
    
    // Part 1
    copy_state(&state, &start_state);
    simulate(start_state, width, height, 4, count_neighbors_one);

    // Part 2
    copy_state(&state, &start_state);    
    simulate(state, width, height, 5, count_neighbors_two);
}


simulate :: proc(state: map[i64]rune, width,height,tolerance: int, count_seats: proc(state: map[i64]rune, x,y: int) -> int)
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
                c := count_seats(state, x, y);
                s := old_state[aoc.hash_2D(x, y)];
                if s == 'L' && c == 0
                {
                    new_state[aoc.hash_2D(x, y)] = '#';
                    changed = true;
                }
                else if s == '#' && c >= tolerance
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

        copy_state(&new_state, &old_state);
    }
}


count_neighbors_one :: proc(state: map[i64]rune, x,y: int) -> int
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


count_neighbors_two :: proc(state: map[i64]rune, x,y: int) -> int
{
    offset_x := []int { 1, 1, 0, -1, -1, -1, 0,   1 };
    offset_y := []int { 0, 1, 1,  1,  0, -1, -1, -1 };

    count := 0;
    offset: for o in 0..<8
    {
        for l := 1;; l += 1
        {
            x_o := x+offset_x[o]*l;
            y_o := y+offset_y[o]*l;
            seat,ok := state[aoc.hash_2D(x_o, y_o)];
            if !ok do continue offset;
            if seat == '#'
            {
                count += 1;
                continue offset;
            }
            if seat == 'L'
            {
                continue offset;
            }
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


copy_state :: proc(from, to: ^map[i64]rune)
{
    for key, value in from
    {
        to[key] = value;
    }
}