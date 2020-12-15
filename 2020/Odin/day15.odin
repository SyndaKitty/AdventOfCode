package main

import "core:fmt"
import "core:strings"
import "core:strconv"

import "../../libs/Odin/aoc"
 
Day1Turn :: 2020;
Day2Turn :: 30_000_000;

main :: proc() {
    input := string(#load("../inputs/15.txt"));
    numbers := strings.split(input, ",");

    time_said: map[int]int;
    last_said: int;
    next_to_say: int;
    turn := 0;

    for num,i in numbers {
        turn += 1;
        val := aoc.parse_int(num);
        time_said[val] = turn;
    }

    for 
    {
        turn += 1;
        
        if last_said in time_said {
            next_to_say = turn - time_said[last_said];
        }
        else {
            next_to_say = 0;
        }

        time_said[last_said] = turn;        
        
        if turn == Day1Turn {
            fmt.println(last_said);
        }
        if turn == Day2Turn {
            fmt.println(last_said);
            return;
        }
        
        last_said = next_to_say;
    }
}