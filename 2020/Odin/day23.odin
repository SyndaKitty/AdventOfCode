package main

import "core:fmt"
import "core:strings"
import "core:strconv"

import "../../libs/Odin/aoc"


Node :: struct {
    previous_value: ^Node,
    next: ^Node,
    label: int,
}

main :: proc() {
    input := string(#load("../inputs/23.txt"));
    
    part_one(input);
    part_two(input);
}

link :: proc(circle: [dynamic]Node) {
    L := len(circle);
    indices := make(map[int]int, L);
    
    for i := 0; i < L; i += 1 {
        circle[i].next = &circle[(i+1)%L];
        indices[circle[i].label] = i;
    }

    for v,i in circle {
        prev_value := circle[i].label - 1;
        if prev_value == 0 do prev_value = L;

        circle[i].previous_value = &circle[indices[prev_value]];
    }
}

part_one :: proc(input: string) {
    circle := make([dynamic]Node);

    one_index: int;
    for c,i in input {
        label := int(c-'0');
        n := Node{label=label};
        append(&circle, n);
        if label == 1 do one_index = i;
    }
    
    L := len(circle);

    link(circle);

    node := &circle[0];
    for i in 1..100 {
        node = move(node);
    }

    node_one := circle[one_index];
    node = node_one;
    for {
        node = node.next;
        if node == node_one do break;
        fmt.print(node.label);
    }
    fmt.println();
}

part_two :: proc(input: string) {
    circle := make([dynamic]Node);

    one_index: int;
    max_value := min(int);
    for c,i in input {
        label := int(c-'0');
        max_value = max(label, max_value);
        n := Node{label=label};
        append(&circle, n);
        if label == 1 do one_index = i;
    }

    for val := max_value + 1; val <= 1_000_000; val += 1 {
        append(&circle, Node{label=val});
    }
    L := len(circle);

    link(circle);

    node := &circle[0];
    for i in 1..10_000_000 {
        node = move(node);
    }

    node_one := circle[one_index];
    total := node_one.next.label * node_one.next.next.label;
    fmt.println(total);
}

move :: proc(current_node: ^Node) -> ^Node{
    current := current_node.label;

    cups: [3]^Node;
    n := current_node;
    for i in 0..<3 {
        n = n.next;
        cups[i] = n;
    }

    current_node.next = cups[2].next;

    dest_node := current_node.previous_value;
    for contains(cups, dest_node) {
        dest_node = dest_node.previous_value;
    }

    later := dest_node.next;
    dest_node.next = cups[0];
    cups[2].next = later;

    return current_node.next;
}

contains :: proc(picked: [3]^Node, value: ^Node) -> bool {
    for i in 0..<3 {
        if picked[i] == value do return true;
    }
    return false;
}