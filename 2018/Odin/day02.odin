package main

import "core:fmt"
import "core:strings"
import "core:strconv"

main :: proc() {
    input := string(#load("../inputs/02.txt"));
    lines := strings.split(input, "\r\n");

    two_count := 0;
    three_count := 0;

    for line in lines {
        chars: map[rune]int;
        for c in line {
            chars[c] += 1;
        }

        two := false;
        three := false;
        for key,value in chars {
            if value == 2 do two = true;
            if value == 3 do three = true;
        }
        if two do two_count += 1;
        if three do three_count += 1;
    }

    fmt.println(two_count * three_count);
}