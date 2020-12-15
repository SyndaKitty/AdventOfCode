package main

import "core:fmt"
import "core:strings"
import "core:strconv"

import "../../libs/Odin/aoc"
 
// Times :: [2]int;

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
        
        if i == len(numbers) - 1 {
            last_said = get_next_to_say(turn + 1, val, time_said);
        }
        time_said[val] = turn;
        //fmt.println(turn, val);
    }

    for 
    {
        turn += 1;
        next_to_say := get_next_to_say(turn, last_said, time_said);
        time_said[last_said] = turn;
        fmt.println(turn, last_said);
        last_said = next_to_say;
        if turn == 2020 do return;
    }
}

get_next_to_say :: proc(turn: int, last_said: int, time_said: map[int]int) -> int {
    //fmt.println("Called", turn, last_said, time_said);
    if last_said in time_said {
        //fmt.println("Returning", turn - time_said[last_said]);
        return turn - time_said[last_said];
    }
    else {
        //fmt.println("Returning", 0);
        return 0;
    }
}