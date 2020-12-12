package main

import "core:fmt"
import "core:strings"
import "core:strconv"

// Custom libraries
import "../../libs/Odin/aoc"


main :: proc() {
    using aoc;
    input := string(#load("../inputs/03.txt"));
    max_block,_ := strconv.parse_int(input);

    part_one(max_block);
    part_two(max_block);
}

part_one :: proc(max_block: int) {
    using aoc;
    pos := Vector2{0, 0};
    len := 1;
    dir := 1;
    block := 1;
    outer: for {
        for i in 1..len {
            pos += Vector2{1, 0} * dir;
            block += 1;
            if block == max_block do break outer;
        }
        for i in 1..len {
            pos += Vector2{0, 1} * dir;
            block += 1;
            if block == max_block do break outer;
        }
        len += 1;
        dir *= -1;
    }

    fmt.println(abs(pos[0]) + abs(pos[1]));
}

part_two :: proc(max_block: int) {
    using aoc;
    pos := Vector2{0, 0};
    len := 1;
    dir := 1;
    blocks: map[i64]int;
    blocks[h2D(pos)] = 1;
    for {
        for i in 1..len {
            pos += Vector2{1, 0} * dir;
            sum := sum_neighbors(blocks, pos);
            blocks[h2D(pos)] = sum;
            if sum > max_block {
                fmt.println(sum);
                return;
            }
        }
        for i in 1..len {
            pos += Vector2{0, 1} * dir;
            sum := sum_neighbors(blocks, pos);
            blocks[h2D(pos)] = sum;
            if sum > max_block {
                fmt.println(sum);
                return;
            }
        }
        len += 1;
        dir *= -1;
    }

    fmt.println(abs(pos[0]) + abs(pos[1]));
}

sum_neighbors :: proc(blocks: map[i64]int, pos: aoc.Vector2) -> int {
    sum := 0;
    for neighbor in aoc.neighbors {
        sum += blocks[aoc.h2D(pos + neighbor)];
    }
    return sum;
}