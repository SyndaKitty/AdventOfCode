package main

import "core:fmt"
import "core:strings"
import "core:strconv"

// Custom libraries
import "../../libs/Odin/aoc"


main :: proc() {
    input := string(#load("../inputs/04.txt"));
    passphrases := strings.split(input, "\r\n");

    valid := 0;
    outer: for passphrase in passphrases {
        seen: map[string]bool;
        words := strings.split(passphrase, " ");
        for word in words {
            if word in seen {
                continue outer;
            }
            seen[word] = true;
        }
        valid += 1;
    }

    fmt.println(valid);
}