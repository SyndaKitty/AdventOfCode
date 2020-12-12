package main

import "core:fmt"
import "core:strings"
import "../../libs/Odin/aoc"

main :: proc()
{
    input := string(#load("../inputs/01.txt"));
    input,_ = strings.replace_all(input, "\r\n", "");

    total := 0;
    l := len(input);
    for c,i in input {
        if c == rune(input[(i+1)%l]) {
            total += int(c - '0');
        }
    }
    fmt.println(total);

    total = 0;
    for c,i in input {
        if c == rune(input[(i+l/2)%l]) {
            total += int(c - '0');
        }
    }
    fmt.println(total);
}