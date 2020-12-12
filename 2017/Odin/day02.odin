package main

import "core:fmt"
import "core:strings"
import "core:strconv"

// Custom libraries
import "../../libs/Odin/aoc"
import "../../libs/Odin/parse"

main :: proc() {
    input := string(#load("../inputs/02.txt"));
    input,_ = strings.replace_all(input, "  ", " ");
    input,_ = strings.replace_all(input, "  ", " ");
    lines := strings.split(input, "\r\n");
    
    total := 0;
    for line in lines {
        words := strings.split(line, " ");
        highest := min(int);
        lowest := max(int);
        for word in words {
            num,_ := strconv.parse_int(word);
            highest = max(highest, num);
            lowest = min(lowest, num);
        }
        total += highest - lowest;
    }
    fmt.println(total);
}