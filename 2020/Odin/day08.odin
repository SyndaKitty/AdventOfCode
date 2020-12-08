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


simulate :: proc(lines: []string, swap_line: int) -> (int, bool)
{
    accumulator := 0;
    pc := 0;

    run_commands: map[int]bool;

    for
    {
        parts := strings.split(lines[pc], " ");
        name := parts[0];
        if swap_line == pc
        {
            if name == "nop" {
                name = "jmp";
            } else if name == "jmp"
            {
                name = "nop";
            }
        }

        amount,ok := strconv.parse_int(parts[1]);
        fmt.println(name, amount);
        
        if pc in run_commands
        {
            // This program loops infinitely
            return accumulator, false;
        }

        run_commands[pc] = true;

        switch name
        {
            case "nop":
                pc += 1;
            case "acc":
                accumulator += amount;
                pc += 1;
            case "jmp":
                pc += amount;
        }

        if pc >= len(lines) do break;
    }
    return accumulator, true;
}


main :: proc()
{
    using aoc;
    input := string(#load("../inputs/08.txt"));

    lines := strings.split(input, "\r\n");

    // Brute force replace commands to see which one doesn't result in infinite loop
    for line,i in lines
    {
        parts := strings.split(line, " ");
        switch parts[0]
        {
            case "jmp": fallthrough;
            case "nop":
                acc,ok := simulate(lines, i);
                if ok
                {
                    fmt.println(acc);
                    return;
                }
        }
    }
}