package main

import "core:fmt"
import "../../libs/Odin/aoc"


main :: proc() {
    data: map[[dynamic]int]bool;

    asd: [dynamic]int;
    append(&asd, 1, 2, 3);

    data[asd[:]] = true;
}