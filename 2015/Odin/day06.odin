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


CommandType :: enum 
{
    turn_on,
    turn_off,
    toggle
}


Command :: struct
{
    type : CommandType,
    lower_x : int,
    lower_y : int,
    upper_x : int,
    upper_y : int
}


parse_commands :: proc(input: string) -> [dynamic]Command
{
    start_index := 0;
    current_index := 0;

    commands := make([dynamic]Command);

    comma_index := 0;

    // State 0 : command
    // State 1 : first coordinate pair
    // State 2 : through
    // State 3 : second coordinate pair
    state := 0;

    command : Command;

    debug :: false;

    for c in input
    {
        if debug do fmt.print("Character:", c, "State:", state);

        if debug 
        {
            fmt.print("\"");
            fmt.print(input[start_index:current_index]);
            fmt.print("\"");
        }

        if input[current_index] == '\n'
        {
            state = 0;
            start_index = current_index + 1;
        }
        else if state == 0
        {
            if input[start_index : current_index] == "turn on "
            {
                command.type = CommandType.turn_on;
                state = state + 1;
                start_index = current_index;
            }
            else if input[start_index : current_index] == "turn off "
            {
                command.type = CommandType.turn_off;
                state = state + 1;
                start_index = current_index;
            }
            else if input[start_index : current_index] == "toggle "
            {
                command.type = CommandType.toggle;
                state = state + 1;
                start_index = current_index;
            }
            if debug do fmt.print(" CommandType:", command.type);
        }
        else if state == 1 || state == 3
        {
            // Check for comma
            letter := input[current_index];
            if letter == ',' do comma_index = current_index;
            if letter == ' ' || letter == '\r'
            {
                // Parse x
                x,_ := strconv.parse_int(input[start_index:comma_index]);

                // Parse y
                y,_ := strconv.parse_int(input[comma_index+1: current_index]);

                if state == 1
                {
                    command.lower_x = x;
                    command.lower_y = y;
                    state = state + 1;
                }
                else if state == 3
                {
                    command.upper_x = x;
                    command.upper_y = y;

                    if debug do fmt.println();
                    if debug do fmt.println(command.lower_x, command.lower_y, command.upper_x, command.upper_y, command.type);

                    append(&commands, command);
                    state = 0;
                }

                start_index = current_index + 1;
            }
        }
        else if state == 2
        {
            if input[current_index] == ' '
            {
                state = state + 1;
                start_index = current_index + 1;
            }
        }
    
        current_index = current_index + 1;
        if debug do fmt.println();
    }

    return commands;
}


to_index :: proc(x: int, y: int) -> int
{
    return y * 1000 + x;
}


main :: proc()
{
    input := string(#load("../inputs/06.txt"));

    commands:= parse_commands(input);
    defer delete(commands);

    pt2 :: true;

    if !pt2
    {
        lights := make([]bool, 1_000_000);
        defer delete(lights);

        // Execute all commands
        for i := 0; i < len(commands); i=i+1
        {
            command := commands[i];
            for y := command.lower_y; y <= command.upper_y; y=y+1
            {
                for x := command.lower_x; x <= command.upper_x; x=x+1 
                {
                    index := to_index(x, y);
                    if command.type == CommandType.turn_on
                    {
                        lights[index] = true;
                    }
                    else if command.type == CommandType.turn_off
                    {
                        lights[index] = false;
                    }
                    else if command.type == CommandType.toggle
                    {
                        lights[index] = !lights[index];
                    }
                }    
            }
        }

        number_of_lights_on := 0;
        for i := 0; i < len(lights); i=i+1
        {
            if lights[i] do number_of_lights_on = number_of_lights_on + 1;
        }

        fmt.println("Total number of lights on:", number_of_lights_on);    
    }
    
    {
        lights := make([]int, 1_000_000);
        defer delete(lights);

        // Execute all commands
        for i := 0; i < len(commands); i=i+1
        {
            command := commands[i];
            for y := command.lower_y; y <= command.upper_y; y=y+1
            {
                for x := command.lower_x; x <= command.upper_x; x=x+1 
                {
                    index := to_index(x, y);
                    current := lights[index];
                    if command.type == CommandType.turn_on 
                    {
                        lights[index] = current + 1;
                    }
                    else if command.type == CommandType.turn_off
                    {
                        lights[index] = max(current - 1, 0);
                    }
                    else if command.type == CommandType.toggle
                    {
                        lights[index] = current + 2;
                    }
                }
            }
        }

        total_brightness := 0;
        for i := 0; i < len(lights); i=i+1
        {
            total_brightness = total_brightness + lights[i];
        }

        fmt.println("Total brightness:", total_brightness);
    }
}