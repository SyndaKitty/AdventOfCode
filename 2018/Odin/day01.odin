package main

import "core:fmt"
import "core:strings"
import "core:strconv"

main :: proc() {
    input := string(#load("../inputs/01.txt"));
    lines := strings.split(input, "\r\n");

    part_one(lines);
    part_two(lines);
}

part_one :: proc(lines: []string) {
    frequency := 0;

    for line in lines {
        df,_ := strconv.parse_int(line);
        frequency += df;
    }

    fmt.println(frequency);
}

part_two :: proc(lines: []string) {
    frequency := 0;
    reached_frequencies: map[int]bool;

    for {
        for line in lines {
            df,_ := strconv.parse_int(line);
            frequency += df;
            if frequency in reached_frequencies {
                fmt.println(frequency);
                return;
            }

            reached_frequencies[frequency] = true;
        }
    }
}