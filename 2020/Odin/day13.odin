package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:math"

// Custom libraries
import "../../libs/Odin/aoc"


main :: proc()
{
    input := string(#load("../inputs/13.txt"));
    lines := strings.split(input, "\r\n");
    
    earliest,_ := strconv.parse_int(lines[0]);
    
    bus_ids: [dynamic]int;
    str_ids := strings.split(lines[1], ",");
    for id in str_ids 
    {
        if id == "x" do continue;
        id_num,_ := strconv.parse_int(id);
        append(&bus_ids, id_num);
    }

    // Part 1
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

    fmt.println(earliest_id * wait_time);
}