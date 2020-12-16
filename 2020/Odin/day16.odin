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
    
    valid_tickets := part_one(fields, other_tickets);
    part_two(fields, my_ticket, valid_tickets);
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

part_one :: proc(fields: [dynamic]Field, other_tickets: [dynamic][dynamic]int) -> [dynamic][dynamic]int {
    valid_tickets: [dynamic][dynamic]int;
    error_rate := 0;

    for ticket in other_tickets {
        valid := true;
        vals: for val in ticket {
            for field in fields {
                if in_range(val, field) {
                    continue vals;
                }
            }
            valid = false;
            error_rate += val;
        }
        if valid do append(&valid_tickets, ticket);
    }

    fmt.println(error_rate);
    return valid_tickets;
}

part_two :: proc(fields: [dynamic]Field, my_ticket: [dynamic]int, valid_tickets: [dynamic][dynamic]int) {
    remaining_fields: map[int] bool;
    field_lookup: map[int]int;
    for i in 0..<len(fields) {
        remaining_fields[i] = true;
        field_lookup[i] = -1;
    }

    assigned := 0;
    outer: for {
        for i in 0..<len(fields) {
            if field_lookup[i] >= 0 do continue;

            possible_fields: map[int]bool;
            for key,value in remaining_fields {
                if value do possible_fields[key] = true;
            }

            field_loop: for field_index,available in possible_fields { 
                for ticket in valid_tickets {
                    if !in_range(ticket[i], fields[field_index]) {
                        possible_fields[field_index] = false;
                        continue field_loop;
                    }
                }
            }

            possible_count := 0;
            for key, value in possible_fields {
                if value do possible_count += 1;
            }

            if possible_count == 1 {
                for key, value in possible_fields {
                    if !value do continue;
                    field_lookup[i] = key;
                    remaining_fields[key] = false;
                }
                assigned += 1;
                if assigned == len(fields) {
                    break outer;
                }
            }
        }
    }

    total := 1;
    for val,i in my_ticket {
        name := fields[field_lookup[i]].name;
        if len(name) >= 9 && name[0:9] == "departure" {
            total *= val;
        }
    }
    fmt.println(total);
}