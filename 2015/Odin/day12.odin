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


Location :: enum
{
    object,
    array
}

is_digit :: proc(char: rune) -> bool
{
    return (char >= '0' && char <= '9') || char == '-';
}


is_num :: proc(char: rune) -> bool
{
    return is_digit(char) || char == '-' || char == '.';
}


day_twelve_pt2 :: proc(input: string)
{
    using container;

    start_cycle := time.read_cycle_counter();
    start_time := time.now();

    debug :: false;

    total := 0;
    total_stack : Array(int);
    array_init(&total_stack);

    array_push(&total_stack, 0);
    
    stack_index := 0;

    locations : Array(Location);
    array_init(&locations);
    current_location : Location;

    array_push(&locations, Location.array);

    lookback: [2]rune;
    lookback[0] = rune(input[0]);
    lookback[1] = rune(input[0]);

    ignore_index := 0;
    left := 0;
    right := 0;

    for c in input
    {
        right += 1;

        // Check for number end
        if !is_digit(c) && is_digit(lookback[0])
        {
            if debug do fmt.println("Number detected:", input[left:right-1]);
            if stack_index <= ignore_index
            {
                value,_ := strconv.parse_int(input[left:right-1]);
                new_value := array_get(total_stack, stack_index) + value;
                array_set(&total_stack, stack_index, new_value);
                if debug do fmt.println("Recording number on stack_index", stack_index, ":", new_value, array_slice(total_stack));
            }
            else if debug do fmt.println("Number ignored");
            left = right;
        }

        switch c
        {
            case 'd':
                if lookback[0] == 'e' && lookback[1] == 'r' 
                    && current_location == Location.object
                    && stack_index <= ignore_index
                {
                    array_set(&total_stack, stack_index, 0);
                    ignore_index = stack_index - 1;
                    if debug do fmt.println("Red inside object, ignore_index:", ignore_index);
                }
                left = right;
            case '{':
                if stack_index <= ignore_index
                {
                    ignore_index += 1;
                }

                array_push(&locations, Location.object);
                current_location = Location.object;

                array_push(&total_stack, 0);
                stack_index += 1;
                if debug do fmt.println("Entered into object:", stack_index, "ignore:", ignore_index);

                left = right;
            case '[':
                if stack_index <= ignore_index
                {
                    ignore_index += 1;
                }

                array_push(&locations, Location.array);
                current_location = Location.array;

                array_push(&total_stack, 0);
                stack_index += 1;
                if debug do fmt.println("Entered into array");

                left = right;
            case '}':
                array_pop_back(&locations);
                current_location = array_get(locations, locations.len-1);

                object_total := array_pop_back(&total_stack);

                stack_index -= 1;
                if stack_index+1 <= ignore_index
                {
                    new_total := array_get(total_stack, stack_index) + object_total;
                    array_set(&total_stack, stack_index, new_total);
                    
                    ignore_index = stack_index;
                }

                
                if debug do fmt.println("Exited object, now in", current_location, "stack_index:", stack_index, "ignore_index:", ignore_index);

                left = right;
            case ']':
                array_pop_back(&locations);
                current_location = array_get(locations, locations.len-1);

                array_total := array_pop_back(&total_stack);

                stack_index -= 1;
                if stack_index+1 <= ignore_index
                {
                    // Attribute array to below index
                    new_total := array_get(total_stack, stack_index) + array_total;
                    array_set(&total_stack, stack_index, new_total);

                    ignore_index = stack_index;
                }

                
                if debug do fmt.println("Exiting array, now in", current_location, "stack_index:", stack_index);

                left = right;
            case '0'..'9','-':
                //fmt.println("Digit");
            case:
                left = right;
        }

        lookback[1] = lookback[0];
        lookback[0] = c;
    }

    end_time := time.now();
    end_cycle := time.read_cycle_counter();

    fmt.println(time.duration_nanoseconds(time.diff(start_time, end_time)), "ns");
    fmt.println(end_cycle - start_cycle, "clock cycles");
    fmt.println(array_get(total_stack, 0));
}


main :: proc()
{
    input := string(#load("../inputs/12.txt"));

    pt2 :: true;
    if pt2 
    {
        day_twelve_pt2(input);
        return;
    }

    total := 0;

    left := 0;
    right := 0;
    
    last_was_digit := false;

    for c in input
    {
        switch c
        {
            case '0'..'9', '-':
                right = right + 1;
                last_was_digit = true;
            case:
                if last_was_digit
                {
                    value,_ := strconv.parse_int(input[left:right]);
                    total = total + value;
                    last_was_digit = false;
                }
                right = right + 1;
                left = right;
        }
    }

    fmt.println(total);
}