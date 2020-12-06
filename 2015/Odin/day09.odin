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


LOCATIONS :: 8;


evaluate_distance :: proc(best: ^int, indices: ^[LOCATIONS]int, distances: ^map[i64]int, pt2: bool)
{
    using aoc;
    location := indices[0];
    total_distance := 0;

    for i := 1; i < LOCATIONS; i = i + 1
    {
        next_location := indices[i];
        key := hash_2D(location, next_location);
        
        total_distance = total_distance + distances[key];
        location = next_location;
    }
    
    // eval := max if pt2 else min;
    // best^ = eval(best^, total_distance);
    best^ = max(best^, total_distance) if pt2 else min(best^, total_distance);
    
}


swap :: proc(x, y: int) -> (int, int)
{
    return y,x;
}


main :: proc()
{
    using aoc;
    input := string(#load("../inputs/09.txt"));

    pt2 :: true;

    distances := make(map[i64]int);
    
    left := 0;
    right := 0;
    from := 0;
    to := 1;
    for c in input
    {
        switch c
        {
            case ' ':
                right = right + 1;
                left = right;
            case '\r':
                distance,_ := strconv.parse_int(input[left:right]);
                
                // Bidirectional distance
                distances[hash_2D(from,to)] = distance;
                distances[hash_2D(to,from)] = distance;
                
                to = to + 1;
                if to >= LOCATIONS
                {
                    from = from + 1;
                    to = from + 1;
                }

                right = right + 1;
            case:
                right = right + 1;
        }
    }

    // Permutation via Heap's Algorithm
    n :: LOCATIONS;
    a : [n]int;
    for i := 0; i < n; i = i + 1 do a[i] = i;
    
    c : [n]int;
    for i := 0; i < n; i = i + 1 do c[i] = 0;

    i := 0;
    best := 0 if pt2 else 99999;

    evaluate_distance(&best, &a, &distances, pt2);

    for i < n
    {
        if c[i] < i
        {
            if i % 2 == 0
            {
                a[0], a[i] = swap(a[0], a[i]);
            }
            else
            {
                a[c[i]], a[i] = swap(a[c[i]], a[i]);
            }

            evaluate_distance(&best, &a, &distances, pt2);

            c[i] = c[i] + 1;
            i = 0;
        }
        else
        {
            c[i] = 0;
            i = i + 1;
        }
    }
    
    fmt.println("Best distance:", best);
}