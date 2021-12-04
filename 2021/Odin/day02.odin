package main
import "core:fmt"
import "core:strconv"
import "core:strings"

main :: proc() {
    file := string(#load("../inputs/02.txt"));
    
    lines := strings.split(file, "\n");
    
    // Part 1
    x := 0;
    y := 0;
    for line in lines {
        words := strings.split(line, " ");
        command := words[0];
        amount := strconv.atoi(words[1]);

        if command == "forward" {
            x += amount;
        }
        else if command == "down" {
            y += amount;
        }
        else {
            y -= amount;
        }
    }

    fmt.println(x * y);

    // Part 2
    x = 0;
    y = 0;
    a := 0;

    for line in lines {
        words := strings.split(line, " ");
        command := words[0];
        amount := strconv.atoi(words[1]);

        if command == "forward" {
            x += amount;
            y += a * amount;
        }
        else if command == "down" {
            a += amount;
        }
        else {
            a -= amount;
        }
    }

    fmt.println(x * y);
}