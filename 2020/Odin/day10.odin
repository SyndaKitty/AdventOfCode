package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"
import "core:time"

// Custom libraries
import "../../libs/Odin/aoc"


main :: proc()
{
    input := string(#load("../inputs/10.txt"));
    lines := strings.split(input, "\r\n");

    // Parse
    jolts: [dynamic]int;
    max_jolt := 0;
    for line in lines
    {
        jolt,_ := strconv.parse_int(line);
        max_jolt = max(max_jolt, jolt);
        append(&jolts, jolt);
    }

    // Add beginning and end jolt
    end_jolt := max_jolt + 3;
    append(&jolts, 0);
    append(&jolts, end_jolt);

    slice.sort(jolts[:]);

    part_one(jolts[:]);
    part_two(jolts[:], end_jolt);
}


part_one :: proc(jolts: []int)
{
    in_jolt := 0;
    differences: [4]int;

    jolt_count := len(jolts);
    outer: for i := 0; i < jolt_count; i += 1
    {
        next_jolt := 999;
        for jolt in jolts
        {
            if jolt > in_jolt && jolt < next_jolt
            {
                next_jolt = jolt;
            }
        }
        if next_jolt == 999 do break outer;
        differences[next_jolt - in_jolt] += 1;
        in_jolt = next_jolt;
    }

    fmt.println(differences[1] * differences[3]);
}


part_two :: proc(jolts: []int, end_jolt: int)
{
    jolt_count := len(jolts);
    
    // Put together a lookup table to determine the next valid jolts
    combinations: map[int][dynamic]int;
    for in_jolt,i in jolts
    {
        next := make([dynamic]int);
        for j := i + 1; j <= i + 3 && j < jolt_count; j += 1
        {
            out_jolt := jolts[j];
            if out_jolt <= in_jolt + 3
            {
                append(&next, out_jolt);
            }
        }
        combinations[in_jolt] = next;
    }


    // Track how many paths we have, key=jolt, value=number of paths
    path_count: map[int]int;
    // We start with one path that ends with jolt value 0
    path_count[0] = 1;

    // Convert each jolt value into the next
    for jolt in jolts
    {
        paths := path_count[jolt];
        if paths == 0 || len(combinations[jolt]) == 0 do continue;

        for next_jolt in combinations[jolt]
        {
            path_count[next_jolt] += paths;
        }
        path_count[jolt] = 0;
    }

    fmt.println(path_count[end_jolt]);
}