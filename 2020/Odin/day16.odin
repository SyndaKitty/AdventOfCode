package main

import "core:fmt"
import "core:strings"
import "core:strconv"

import "../../libs/Odin/aoc"

Field :: struct {
    name: string
    range_a: [2]int,
    range_b: [2]int
}

main :: proc() {
    input := string(#load("../inputs/16.txt"));

    input_parts := strings.split(input, "\r\n\r\n");
    field_lines := strings.split(input_parts[0], "\r\n");

    fields: [dynamic]Field;
    for field_line in field_lines {
        parts := strings.split(field_line, ": ");
        name := parts[0];
        ranges := strings.split(parts[1], " or ");
        range_a_string := strings.split(ranges[0], "-");
        range_a: [2]int;
        range_a[0] = aoc.parse_int(range_a_string[0]);
        range_a[1] = aoc.parse_int(range_a_string[1]);

        range_b_string := strings.split(ranges[1], "-");
        range_b: [2]int;
        range_b[0] = aoc.parse_int(range_b_string[0]);
        range_b[1] = aoc.parse_int(range_b_string[1]);

        append(&fields, Field{name, range_a, range_b});
    }

    my_ticket_line := aoc.replace(input_parts[1], "your ticket:\r\n", "");
    my_ticket := parse_ticket(my_ticket_line);

    other_tickets: [dynamic][dynamic]int;
    other_ticket_lines := strings.split(aoc.replace(input_parts[2], "nearby tickets:\r\n", ""), "\r\n");
    for line in other_ticket_lines {
        append(&other_tickets, parse_ticket(line));
    }
    
    part_one(fields, other_tickets);
}


parse_ticket :: proc(line: string) -> [dynamic]int {
    values: [dynamic]int;
    toks := strings.split(line, ",");
    for tok in toks {
        append(&values, aoc.parse_int(tok));
    }
    return values;
}


in_range_field :: proc(val: int, field: Field) -> bool {
    using field;
    return in_range(val, range_a) || in_range(val, range_b);
}

in_range_slice :: proc(val: int, range: [2]int) -> bool {
    return val >= range[0] && val <= range[1];
}

in_range :: proc {in_range_field, in_range_slice};

part_one :: proc(fields: [dynamic]Field, other_tickets: [dynamic][dynamic]int) {
    error_rate := 0;

    for ticket in other_tickets {
        vals: for val in ticket {
            for field in fields {
                if in_range(val, field) {
                    continue vals;
                }
            }
            error_rate += val;
        }
    }

    // Not 612681
    fmt.println(error_rate);
}