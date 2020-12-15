package main

import "core:fmt"
import "core:strings"
import "core:strconv"

import "../../libs/Odin/aoc"

Claim :: struct {
    left: int,
    top: int,
    width: int,
    height: int
}

main :: proc() {
    input := string(#load("../inputs/03.txt"));
    lines := strings.split(input, "\r\n");

    claims: [dynamic]Claim;
    id := 1;
    for line in lines {
        parts := strings.split(line, " ");
        
        coords := strings.split(aoc.replace(parts[2], ":", ""), ",");
        left := aoc.parse_int(coords[0]);
        top := aoc.parse_int(coords[1]);

        dims := strings.split(parts[3], "x");
        w := aoc.parse_int(dims[0]);
        h := aoc.parse_int(dims[1]);

        append(&claims, Claim{left=left, top=top, width=w, height=h});
        id += 1;
    }


    // Part 1
    conflicts := 0;
    fabric: map[i64]int;
    for claim,i in claims {
        using claim;
        for y in top..<top+height {
            for x in left..<left+width {
                hash := aoc.h2D(x, y); 
                fabric[hash] += 1;
                if fabric[hash] == 2 {
                    conflicts += 1;
                }
            }
        }
    }
    fmt.println(conflicts);

    // Part 2
    outer: for claim, i in claims {
        using claim;
        for y in top..<top+height {
            for x in left..<left+width {
                hash := aoc.h2D(x, y); 
                if fabric[hash] > 1 do continue outer;
            }
        }
        fmt.println(i + 1);
        return;
    }
}