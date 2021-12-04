package main
import "core:fmt"
import "core:strconv"
import "core:strings"

main :: proc() {
    file := string(#load("../inputs/01.txt"));
    
    lines := strings.split(file, "\n");
    
    ints := make([dynamic]int);
    for line,i in lines {
        append(&ints, strconv.atoi(line));
    }

    // Part 1
    count := 0;
    for i := 1; i < len(ints); i += 1 {
        if ints[i] > ints[i-1] {
            count += 1;
        }
    }
    fmt.println(count);

    // Part 2
    count = 0;
    for i := 3; i < len(ints); i += 1 {
        if ints[i] > ints[i-3] {
            count += 1;
        }
    }
    fmt.println(count);
}