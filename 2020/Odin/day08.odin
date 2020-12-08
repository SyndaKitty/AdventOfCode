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

swap := map[string]string
{
    "jmp"="nop",
    "nop"="jmp"
};

simulate :: proc(lines: []string, swap_line: int) -> (int, bool)
{
    accumulator := 0;
    pc := 0;

    run_commands: map[int]bool;

    for
    {
        parts := strings.split(lines[pc], " ");
        name := parts[0];
        amount,_ := strconv.parse_int(parts[1]);

        if swap_line == pc do name = swap[name];

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

    // Part 1
    acc,_ := simulate(lines, -1);
    fmt.println(acc);

    // Part 2
    // Brute force replace commands to see which one doesn't result in infinite loop
    for line,i in lines
    {
        parts := strings.split(line, " ");
        if parts[0] != "jmp" && parts[0] != "nop" do continue;
        
        acc,ok := simulate(lines, i);
        if ok
        {
            fmt.println(acc);
            return;
        }
    }
}