package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:math"
import "core:time"

// Custom libraries
import "../../libs/Odin/aoc"


main :: proc()
{
    input := string(#load("../inputs/13.txt"));
    lines := strings.split(input, "\r\n");
    
    earliest,_ := strconv.parse_int(lines[0]);
    
    bus_ids: [dynamic]int;
    offsets: [dynamic]int;
    str_ids := strings.split(lines[1], ",");
    line_pos := 0;
    for id in str_ids 
    {
        line_pos += 1;
        if id == "x" do continue;
        id_num,_ := strconv.parse_int(id);
        append(&bus_ids, id_num);
        append(&offsets, line_pos-1);
    }

    part_one(bus_ids, earliest);
    part_two(bus_ids, offsets);
}


part_one :: proc(bus_ids: [dynamic]int, earliest: int)
{
    earliest_id := 0;
    wait_time := max(int);
    for id in bus_ids
    {
        pickup_time := ((earliest / id) + 1) * id;
        wait := pickup_time - earliest;
        if wait < wait_time
        {
            wait_time = wait;
            earliest_id = id;
        }
    }
    //fmt.println(earliest_id * wait_time);
}

part_two :: proc(bus_ids: [dynamic]int, offsets: [dynamic]int)
{
    pieces: [dynamic]int;
    for num in bus_ids {
        append(&pieces, 1);
    }

    // Think of our target number as a sum of a bunch of pieces
    // Each of these pieces corresponds to an input id
    // Each piece should start as a multiple of all other input ids
    for num, i in bus_ids 
    {
        for j in 0..<len(pieces)
        {
            if i == j do continue;
            pieces[j] *= num;
        }
    }

    // Now we multiply each piece until it is the modulus that we want it to be
    for piece, i in pieces
    {
        target_modulus := (bus_ids[i] - offsets[i]) %% bus_ids[i];
        
        // Keep multiplying piece until its the right modulus
        // There is probably a constant time way to do this
        for m := 1;; m += 1
        {
            //fmt.println(piece*m);
            if (piece * m) % bus_ids[i] == target_modulus
            {
                pieces[i] = piece * m;
                break;
            }
        }
    }

    lcm := 1;
    for number in bus_ids
    {
        lcm *= number;
    }

    // Find one occurrence by adding up all the pieces
    occurrence := 0;
    for piece in pieces
    {
        occurrence += piece;
    }

    // The occurence is some multiple of the LCM away from the first occurrence (not sure why)
    for
    {
        occurrence -= lcm;
        if occurrence < 0 
        {
            occurrence += lcm;
            fmt.println("First occurrence", occurrence);
            return;
        }
    }
}