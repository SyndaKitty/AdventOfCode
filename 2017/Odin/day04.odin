package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"

// Custom libraries
import "../../libs/Odin/aoc"


main :: proc() {
    input := string(#load("../inputs/04.txt"));
    passphrases := strings.split(input, "\r\n");

    validate(passphrases, false);
    validate(passphrases, true);
}

validate :: proc(phrases: []string, part2: bool) {
    valid := 0;
    outer: for phrase in phrases {
        seen: map[string]bool;
        words := strings.split(phrase, " ");
        for word in words {
            w := word;
            if part2 do w = aoc.sort_string(word);
            if w in seen {
                continue outer;
            }
            seen[w] = true;
        }
        valid += 1;
    }

    fmt.println(valid);
}