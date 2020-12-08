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
    using aoc;
    input := string(#load("../inputs/08.txt"));

    accumulator := 0;

    run_commands: map[int]bool;

    lines := strings.split(input, "\r\n");
    
    pc := 0;
    for
    {
        command := lines[pc];
        parts := strings.split(command, " ");
        name := parts[0];
        amount,ok := strconv.parse_int(parts[1]);
        fmt.println(name, amount);
        
        if pc in run_commands
        {
            break;
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
    }


    // parse_info := parse.make_parse_info(input);
    // for parse.has_next(&parse_info)
    // {
    //     parse.next_number(&parse_info);
    //     parse.next_word(&parse_info);
    //     parse.next_rune(&parse_info);
    // }


    // for c in input
    // {
    //     switch c
    //     {
    //         case ' ':

    //     }
    // }

    fmt.println(accumulator);
}