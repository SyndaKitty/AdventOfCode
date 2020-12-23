package main

import "core:fmt"
import "core:strings"
import "core:strconv"

import "../../libs/Odin/aoc"

Rule :: struct {
    rules_a: [dynamic]int,
    rules_b: [dynamic]int,
    match: string
}

main :: proc() {
    input := string(#load("../inputs/19.txt"));

    parts := strings.split(input, "\r\n\r\n");
    rules_lines := strings.split(parts[0], "\r\n");

    rule_lookup := make(map[int]Rule);

    for rule_line in rules_lines {
        rule := Rule{};
        rule_parts := strings.split(rule_line, ": ");
        rule_index := aoc.parse_int(rule_parts[0]);
        if rule_parts[1][0:1] == "\"" {
            rule.match = rule_parts[1][1:2];
        }
        else {
            lists := strings.split(rule_parts[1], " | ");
            for list, i in lists {
                list_parts := strings.split(list, " ");
                indices := make([dynamic]int);
                for list_part in list_parts {
                    append(&indices, aoc.parse_int(list_part));
                }
                if i == 0 do rule.rules_a = indices;
                if i == 1 do rule.rules_b = indices;
            }
        }
        rule_lookup[rule_index] = rule;
    }

    message_lines := strings.split(parts[1], "\r\n");
    total := 0;
    // for message_line in message_lines {
    //     fmt.println(message_line);
    //     msg := Message{0, message_line};
    //     eval := evaluate_rule(&msg, 0, rule_lookup, 0);
    //     if eval && msg.index == len(msg.str) do total += 1;
    // }
    for message_line in message_lines {
        msg := Message{0, message_line};
        for i := 0;; i += 1 {
            for j := 0;; j += 1 {
                for ii in 0..<i {
                    
                }
                for jj in 0..<j {

                }
            }
        }
    }
    fmt.println(total);
}

Message :: struct {
    index: int,
    str: string
}

evaluate_rule :: proc(msg: ^Message, rule_index: int, rules: map[int]Rule, depth: int) -> bool {


    // for i in 0..depth do fmt.print("  ");
    // fmt.println("Entering", msg.index, rule_index, rules[rule_index]);
    rule := rules[rule_index];
    if len(rule.match) > 0 {
        // for i in 0..depth do fmt.print("  ");
        // fmt.println("Comparing", rune(msg.str[msg.index]), rune(rule.match[0]));
        if msg.index > len(msg.str) - 1 do return false;
        if msg.str[msg.index] == rule.match[0] {
            msg.index += 1;
            // for i in 0..depth do fmt.print("  ");
            // fmt.println("returning true (match)");
            return true;
        }
        // for i in 0..depth do fmt.print("  ");
        // fmt.println("returning false (match)");
        return false;
    }
    
    start_index := msg.index;
    evaluation := true;
    for r in rule.rules_a {
        if !evaluate_rule(msg, r, rules, depth + 1) {
            evaluation = false;
            break;
        }
    }
    
    if evaluation {
        // for i in 0..depth do fmt.print("  ");
        // fmt.println("returning true (match a)");
        return true; // Can we early exit here?
    }
    msg.index = start_index;

    // for i in 0..depth do fmt.print("  ");
    // fmt.println("Checking list B");

    start_index = msg.index;
    evaluation = true;
    if len(rule.rules_b) > 0 {
        for r in rule.rules_b {
            if !evaluate_rule(msg, r, rules, depth + 1) {
                evaluation = false;
                break;
            }
        }
    }
    else do return false;
    
    if evaluation {
        // for i in 0..depth do fmt.print("  ");
        // fmt.println("returning true (match b)");
        return true;  
    } 
    msg.index = start_index;

    // for i in 0..depth do fmt.print("  ");
    // fmt.println("returning false");
    return false;
}