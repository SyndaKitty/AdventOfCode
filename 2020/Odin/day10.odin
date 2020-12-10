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
    append(&jolts, 0);
    append(&jolts, max_jolt + 3);

    // Sort the jolts! I was able to solve without this, but 
    //  doing this lets us make a lot of assumptions that make
    //  the solution much more elegant
    slice.sort(jolts[:]);

    part_one(jolts[:]);
    part_two(jolts[:]);
}


part_one :: proc(jolts: []int)
{
    differences: [4]int;

    jolt_count := len(jolts);
    for i := 0; i < jolt_count - 1; i += 1
    {
        differences[jolts[i+1] - jolts[i]] += 1;
    }
    fmt.println(differences[1] * differences[3]);
}


part_two :: proc(jolts: []int)
{
    jolt_count := len(jolts);
    
    path_counts := make([]int, jolt_count);
    path_counts[0] = 1;
    
    for in_jolt,i in jolts
    {
        in_count := path_counts[i];
        for j := i + 1; j < jolt_count && jolts[j] <= in_jolt + 3; j += 1
        {
            path_counts[j] += in_count;
        }
    }
    fmt.println(path_counts[jolt_count-1]);
}