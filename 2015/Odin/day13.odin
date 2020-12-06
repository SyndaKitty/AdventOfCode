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
    input := string(#load("../inputs/13.txt"));

    using parse;
    using permute;
    using aoc;

    word_info := make_parse_info(input);
    word_info.search = {TokenType.Word};

    number_info := make_parse_info(input);
    number_info.search = {TokenType.Number};

    adjacency_bonus := make(map[i64]int);

    i := 0;
    j := 1;
    
    pt2 :: true;
    when pt2 
    {
        Seats :: 9;    
    }
    else
    {
        Seats :: 8;
    }

    FileSeats :: 8;

    for i in 0..<FileSeats
    {
        for j in 0..<FileSeats
        {
            if i == j do continue;

            gain: bool;
            for 
            {
                word,_ := parse_next(&word_info);
                if word.data == "gain" || word.data == "lose"
                {
                    gain = word.data == "gain";
                    break;
                }
            }

            token,_ := parse_next(&number_info);
            adjacency_bonus[hash_2D(i,j)] = token.number if gain else -token.number;
        }
    }

    if pt2 
    {
        for i in 0..<Seats-1
        {
            adjacency_bonus[hash_2D(i,Seats-1)] = 0;
            adjacency_bonus[hash_2D(Seats-1,i)] = 0;
        }
    }

    lookup: [Seats]int;
    for i in 0..<Seats do lookup[i] = i;

    permutation := make_permutation(Seats);
    max_happiness := -999;

    for permute_next(&permutation, &lookup)
    {
        total_happiness := 0;
        last_seat := Seats-1;
        for i in 0..<Seats
        {
            total_happiness += adjacency_bonus[hash_2D(lookup[last_seat], lookup[i])];
            total_happiness += adjacency_bonus[hash_2D(lookup[i], lookup[last_seat])];
            last_seat = i;
        }
        
        max_happiness = max(max_happiness, total_happiness);
    }

    fmt.println(max_happiness);
}