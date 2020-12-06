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
    input := string(#load("../inputs/18.txt"));

    pt2 :: true;
    length :: 100;
    area :: length * length;
    steps :: 100;

    current_state: [area]bool;
    next_state: [area]bool;

    i := 0;
    for c in input
    {
        switch c 
        {
            case '\r': fallthrough;
            case '\n': continue;
            case '#':
                current_state[i] = true;
            case '.':
                current_state[i] = false;
        }
        i += 1;
    }

    get_state :: proc(array: [area]bool, x: int, y: int) -> int
    {
        i := x + y * length;
        if x < 0 || x >= length || y < 0 || y >= length do return 0;
        return 1 if array[i] else 0;
    }

    if pt2 
    {
        current_state[0] = true;
        current_state[length-1] = true;
        current_state[(length-1)*length] = true;
        current_state[length*length-1] = true;
    }

    for step in 0..<steps
    {
        for y in 0..<length
        {
            for x in 0..<length
            {
                neighbors := 0;
                neighbors += get_state(current_state, x-1, y-1);
                neighbors += get_state(current_state, x, y-1);
                neighbors += get_state(current_state, x+1, y-1);

                neighbors += get_state(current_state, x-1, y);
                neighbors += get_state(current_state, x+1, y);
                
                neighbors += get_state(current_state, x-1, y+1);
                neighbors += get_state(current_state, x, y+1);
                neighbors += get_state(current_state, x+1, y+1);


                self := get_state(current_state, x, y);
                index := x + y * length;
                
                next_state[index] = 
                    (self == 0 && neighbors == 3) || 
                    (self == 1 && (neighbors == 2 || neighbors == 3));
            }
        }
        
        for j in 0..<area
        {
            current_state[j] = next_state[j];
        }

        if pt2 
        {
            current_state[0] = true;
            current_state[length-1] = true;
            current_state[(length-1)*length] = true;
            current_state[length*length-1] = true;
        }
    }

    lights_on := 0;
    for i in 0..<area
    {
        if current_state[i] do lights_on += 1;
    }

    fmt.println(lights_on, "lights on");
}