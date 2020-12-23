package main

import "core:fmt"
import "core:strings"
import "core:strconv"

import "../../libs/Odin/aoc"


Node :: struct {
    previous_index: ^Node,
    next: ^Node,
    label: int,
}

main :: proc() {
    input := string(#load("../inputs/23.txt"));
    circle: [dynamic]int;

    for c in input {
        append(&circle, int(c-'0'));
    }
    
    max_value := min(int);
    for i in 0..<len(circle) {
        max_value = max(circle[i], max_value);
    }

    // for val := max_value + 1; val <= 1000000; val += 1 {
    //     append(&circle, val);
    // }

    indices := make(map[int]int);

    for v,i in circle {
        indices[v] = i;
    }

    fmt.println("Starting");

    index := 0;
    for i in 1..100 {
        move(index, &circle, max_value, &indices);
        index = (index + 1) % len(circle);
    }  

    start_index := get_index(1, &circle);
    for i := start_index + 1; i != start_index; i = (i + 1) % len(circle) {
        fmt.print(circle[i]);

    }

    // total := circle[(start_index + 1) % len(circle)] * circle[(start_index + 2) % len(circle)];
    // fmt.println(total);
}

move :: proc(current_index: int, circle: ^[dynamic]int, max_value: int, indices: ^map[int]int) {
    L := len(circle);

    current := circle[current_index];

    cups: [3]int;
    for i in 0..<3 {
        cups[i] = circle[(current_index + i + 1) % L];
    }

    dest_value := current - 1;

    for {
        if dest_value == 0 do dest_value = max_value;    
        if !contains(cups, dest_value) do break;
        dest_value -= 1;
    }
    
    dest_index := indices[dest_value];
    
    from := (current_index + 4) % L;
    to := (current_index + 1) % L;

    for from != (dest_index + 1) % L {
        indices[circle[from]] = to;
        circle[to] = circle[from];
        from = (from + 1) % L;
        to = (to + 1) % L;
    }

    for i in 0..<3 {
        indices[cups[i]] = to;
        circle[to] = cups[i];
        to = (to + 1) % L;
    }

    // fmt.println("move", move_num);
    // fmt.println("cups:", circle^);
    // fmt.println("pick up:", cups);
    // fmt.println("destination:", dest_value);
    // fmt.println();
}

contains :: proc(picked: [3]int, value: int) -> bool {
    for i in 0..<3 {
        if picked[i] == value do return true;
    }
    return false;
}

get_index :: proc(value: int, circle: ^[dynamic]int) -> int {
    for i in 0..<len(circle) {
        if circle[i] == value {
            return i;
        }
    }
    return -1;
}