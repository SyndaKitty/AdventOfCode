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


Reindeer :: struct 
{
    speed: int,
    run_time: int,
    rest_time: int,
    index: int,
    resting: bool,
    distance: int,
    points: int
}


main :: proc()
{
    input := string(#load("../inputs/14.txt"));

    pt2 :: true;

    using parse;

    Seconds :: 2503;

    parse_info := make_parse_info(input);
    parse_info.search = {TokenType.Number};

    reindeer := make([dynamic]Reindeer);

    for 
    {
        speed, ok := parse_next(&parse_info);
        run,_ := parse_next(&parse_info);
        rest,_ := parse_next(&parse_info);
        if !ok do break;

        append(&reindeer, Reindeer{speed=speed.number, run_time=run.number, rest_time=rest.number});
    }


    for s := 0; s < Seconds; s += 1
    {
        max_distance := 0;

        for _,i in reindeer
        {
            if !reindeer[i].resting
            {
                reindeer[i].distance += reindeer[i].speed;
                reindeer[i].index += 1;
                if reindeer[i].index == reindeer[i].run_time
                {
                    reindeer[i].index = 0;
                    reindeer[i].resting = true;
                }
            }
            else
            {
                reindeer[i].index += 1;
                if reindeer[i].index == reindeer[i].rest_time
                {
                    reindeer[i].index = 0;
                    reindeer[i].resting = false;
                }
            }
            max_distance = max(max_distance, reindeer[i].distance);
        }

        if pt2 do for _,i in reindeer
        {
            if reindeer[i].distance == max_distance
            {
                reindeer[i].points += 1;
            }
        }
    }


    if !pt2 
    {
        max_distance := 0;
        for r in reindeer
        {
            max_distance = max(max_distance, r.distance);
        }

        fmt.println(max_distance);    
    }
    else
    {
        max_points := 0;
        for r in reindeer
        {
            max_points = max(max_points, r.points);
        }

        fmt.println(max_points);
    }
}