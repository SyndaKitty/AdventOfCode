package main

import "core:fmt"
import "../../libs/Odin/aoc"


main :: proc() {
    data: map[[2]int]bool;
    for i in 1..100 {
        data[{-27,16}] = true;
    }
    fmt.println(data);
}