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
    
    input := string(#load("../inputs/03.txt"));

    pt2 :: true;

    // Record coordinates as we go
    m := make(map[i64]int);

    if !pt2
    {
        x := 0;
        y := 0;
        houses := 1;

        // Record visiting 0
        m[hash_2D(x, y)] = 1;

        for c in input 
        {
            switch c 
            {
                case '^':
                    y = y + 1;
                case 'v':
                    y = y - 1;
                case '>':
                    x = x + 1;
                case '<':
                    x = x - 1;
            }

            hash := hash_2D(x, y);

            exists := hash in m;
            if !exists 
            {
                m[hash] = 1;
                houses = houses + 1;
            }
            else
            {
                m[hash] = m[hash] + 1;
            }
        }

        fmt.println("Unique houses visited:", houses);    
    }
    else
    {
        x_santa := 0;
        y_santa := 0;
        x_robo  := 0;
        y_robo  := 0;
        santa   := true;
        houses := 1;

        // Record visiting 0
        m[hash_2D(0, 0)] = 2;

        for c in input 
        {
            switch c 
            {
                case '^':
                    if santa do y_santa = y_santa + 1;
                    else do y_robo = y_robo + 1;
                case 'v':
                    if santa do y_santa = y_santa - 1;
                    else do y_robo = y_robo - 1;
                case '>':
                    if santa do x_santa = x_santa + 1;
                    else do x_robo = x_robo + 1;
                case '<':
                    if santa do x_santa = x_santa - 1;
                    else do x_robo = x_robo - 1;
            }
            

            hash : i64;
            if santa do hash = hash_2D(x_santa, y_santa);
            else do hash = hash_2D(x_robo, y_robo);

            exists := hash in m;
            if !exists 
            {
                m[hash] = 1;
                houses = houses + 1;
            }
            else
            {
                m[hash] = m[hash] + 1;
            }

            santa = !santa;
        }

        fmt.println("Unique houses visited:", houses); 
    }
}