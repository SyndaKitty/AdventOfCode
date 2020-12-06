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
    input := string(#load("../inputs/06.txt"));

    total := 0;
    groups := strings.split(input, "\r\n\r\n");
    
    for group in groups
    {
        group_answers := make(map[rune]bool);

        lines := strings.split(group, "\r\n");        
        first_line := true;

        for line in lines
        {
            person_answers := make(map[rune]bool);

            for c in line
            {
                person_answers[c] = true;
            }

            if first_line
            {
                for key,value in person_answers
                {
                    group_answers[key] = true;
                }
                first_line = false;
            }
            else
            {
                to_remove := make([dynamic]rune);
                for key,value in group_answers
                {
                    if !(key in person_answers)
                    {
                        append(&to_remove, key);
                    }
                }

                for remove in to_remove
                {
                    delete_key(&group_answers, remove);
                }
            }
        }
        group_total := 0;
        for key,value in group_answers
        {
            group_total += 1;
            total += 1;
        }
    }
    fmt.println(total);
}