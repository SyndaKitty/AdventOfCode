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


check_for_sum :: proc(numbers: []int, sum: int) -> bool
{
    for i := 0; i < len(numbers); i += 1
    {
        for j := 0; j < len(numbers); j += 1
        {
            if i == j do continue;
            if numbers[i] + numbers[j] == sum do return true;
        }
    }
    return false;
}

sum :: proc(numbers: []int) -> int
{
    total := 0;
    for i := 0; i < len(numbers); i += 1
    {
        total += numbers[i];
    }
    return total;
}

min :: proc(numbers: []int) -> int
{
    smallest := numbers[0];
    for i := 1; i < len(numbers); i += 1
    {
        if numbers[i] < smallest
        {
            smallest = numbers[i];
        }
    }
    return smallest;
}

max :: proc(numbers: []int) -> int
{
    largest := numbers[0];
    for i := 1; i < len(numbers); i += 1
    {
        if numbers[i] > largest
        {
            largest = numbers[i];
        }
    }
    return largest;
}

main :: proc()
{
    input := string(#load("../inputs/09.txt"));
    lines := strings.split(input, "\r\n");

    preamble_size :: 25;

    numbers: [dynamic]int;

    begin := 0;
    end := 0;
    bad_number: int;

    // Part 1
    for line in lines 
    {
        number,ok := strconv.parse_int(line);
        end += 1;
        if end - begin > preamble_size
        {
            if !check_for_sum(numbers[begin:], number)
            {
                fmt.println("ERROR ON", number);
                bad_number = number;
                break;
            }
            begin += 1;
        }
        
        append(&numbers, number);
    }

    // Part 2
    // Find contiguous set of numbers that sum to bad_number
    for size := 2;;size += 1
    {
        if size >= len(numbers) do break;
        for i := 0; i + size - 1 < len(numbers); i += 1
        {
            // fmt.println("Checking if", numbers[i:i+size], "sums to", bad_number);
            if sum(numbers[i:i+size]) == bad_number
            {
                fmt.println(min(numbers[i:i+size]) + max(numbers[i:i+size]));
            }
        }
    }
}