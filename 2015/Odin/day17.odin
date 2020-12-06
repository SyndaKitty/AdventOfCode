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
    input := string(#load("../inputs/17.txt"));
    
    pt2 :: true;

    using parse;

    info := make_parse_info(input);
    info.search = {TokenType.Number};

    containers := make([dynamic]int);
    defer delete(containers);

    for 
    {
        token,ok := parse_next(&info);
        if !ok do break;
        append(&containers, token.number);
    }

    // Get all combinations of containers
    num_containers := uint(len(containers));
    num_combos := 1 << num_containers;
    valid_combos := 0;
    min_containers := 100;

    for i in 0..<num_combos
    {
        container_count := 0;
        mask := 1;
        total := 0;
        for j in 0..<num_containers
        {
            if i & mask > 0
            {
                container_count += 1;
                total += containers[j];
            }
            mask *= 2;
        }

        if !pt2
        {
            if total == 150 do valid_combos += 1;
        }
        else if total == 150
        {
            if container_count < min_containers
            {
                min_containers = container_count;
                valid_combos = 1;
            }
            else if container_count == min_containers
            {
                valid_combos += 1;
            }
        }
    }

    fmt.println(valid_combos, "valid combinations");
}