package main

import "core:fmt"
import "core:strings"
import "core:strconv"

import "../../libs/Odin/aoc"

main :: proc() {
    input := string(#load("../inputs/25.txt"));
    lines := strings.split(input, "\r\n");

    card_key := aoc.parse_int(lines[0]);
    door_key := aoc.parse_int(lines[1]);

    subject := 7;
    value := 1;
    card_loop: int;

 	for loop := 1;; loop += 1 {
 		value *= subject;
 		value %%= 20201227;
 		if value == card_key {
 			card_loop = loop;
 			break;
 		}
 	}

 	value = 1;
 	for loop in 1..card_loop {
 		value *= door_key;
 		value %%= 20201227;
 	}
 	fmt.println(value);
}