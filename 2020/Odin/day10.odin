package main

import "core:fmt"
import "core:strings"
import "core:strconv"


// Custom libraries
import "../../libs/Odin/aoc"

main :: proc()
{
    using aoc;
    
    input := string(#load("../inputs/10.txt"));
    lines := strings.split(input, "\r\n");

    // Parse
    jolts: [dynamic]int;
    for line in lines
    {
        jolt,_ := strconv.parse_int(line);
        append(&jolts, jolt);
    }

    // Part 1
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
        
        fmt.println("selected", next_jolt);
        if next_jolt == 999 do break outer;
        differences[next_jolt - in_jolt] += 1;
        in_jolt = next_jolt;
    }

    fmt.println(differences[1] * (differences[3]+1));
}