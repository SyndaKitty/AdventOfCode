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


front :: proc(in_min: int, in_max: int) -> (out_min: int, out_max: int)
{
    range := in_max - in_min;
    if range == 1
    {
        out_min = min(in_min, in_max);
        out_max = max(in_min, in_max);
    }
    out_min = in_min;
    out_max = in_max - range / 2 - 1;
    return;
}

back :: proc(in_min: int, in_max: int) -> (out_min: int, out_max: int)
{
    range := in_max - in_min;
    if range == 1
    {
        out_min = min(in_min, in_max);
        out_max = max(in_min, in_max);
    }
    out_min = in_min + range / 2 + 1;
    out_max = in_max;
    return;
}

seat_id :: proc(row: int, column: int) -> int
{
    return row * 8 + column;
}


main :: proc()
{
    input := string(#load("../inputs/05.txt"));

    using parse;
    parse_info := make_parse_info(input);
    parse_info.search = {TokenType.Word};

    max_seat := 0;
    min_seat := 999;
    seats := make(map[int]bool);

    for has_next(&parse_info)
    {
        line := next_word(&parse_info);
        min := 0;
        max := 127;
        for i in 0..6
        {
            if line[i] == u8('F')
            {
                min,max = front(min,max);
            }
            else
            {
                min,max = back(min,max);
            }
        }

        row := min;

        min = 0;
        max = 7;
        for i in 7..9
        {
            if line[i] == u8('L')
            {
                min,max = front(min,max);
            }
            else
            {
                min,max = back(min,max);
            }
        }

        col := min;
        id := seat_id(row, col);
        seats[id] = true;
        if id > max_seat
        {
            max_seat = id;
        }
        if id < min_seat
        {
            min_seat = id;
        }
    }

    for i in 32..913
    {
        if !(i in seats) do fmt.println(i);
    }


    fmt.println(min_seat, max_seat);
}