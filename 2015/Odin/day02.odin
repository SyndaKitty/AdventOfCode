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
    input := string(#load("../inputs/02.txt"));

    pt2 :: true;
    
    // Array of l,w,h, l,w,h, ...
    box_sizes := make([dynamic]int);
    defer delete(box_sizes);

    // Parse individual numbers via slicing
    num_start_index := 0;
    char_index := 0;
    
    for c in input 
    {
        switch c 
        {
            case 'x':
                fallthrough;
            case '\n':
                size := strconv.atoi(input[num_start_index : char_index]);
                append(&box_sizes, size);
                num_start_index = char_index + 1;
        }
        char_index = char_index + 1;
    }

    // Calculate surface areas + slack
    wrapping_paper := 0;
    ribbon := 0;

    for box_index := 0; box_index < len(box_sizes); box_index = box_index + 3
    {
        l := box_sizes[box_index];
        w := box_sizes[box_index + 1];
        h := box_sizes[box_index + 2];

        l_w := l * w;
        w_h := w * h;
        l_h := l * h;

        surface := 2 * (l_w + w_h + l_h);
        slack := min(l_w, w_h, l_h);

        wrapping_paper += surface + slack;

        if pt2
        {
            perimeter_l_w := 2 * (l + w);
            perimeter_w_h := 2 * (w + h);
            perimeter_l_h := 2 * (l + h);

            ribbon = ribbon + min(perimeter_l_w, perimeter_w_h, perimeter_l_h) + l * w * h;
        }
    }

    fmt.println("Total wrapping paper required:", wrapping_paper, "sq ft.");
    if pt2 do fmt.println("Total ribbon needed:", ribbon, "ft.");
}