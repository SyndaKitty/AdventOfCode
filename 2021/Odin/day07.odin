package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:math"
import "core:slice"

main :: proc() {
    file := string(#load("../inputs/07.txt"));
    strs := strings.split(file, ",");
    
    crabs := make([dynamic]int);
    for str in strs {
        num,_ := strconv.parse_int(str);
        append(&crabs, num);
    }

    costs1 := make([dynamic]int);
    costs2 := make([dynamic]int);
    for pos in 0..slice.max(crabs[:]) {
        cost1 := 0;
        cost2 := 0;
        for c in crabs {
            diff := abs(c - pos);
            cost1 += diff;
            cost2 += (diff * diff + diff) / 2; // Triangle numbers
        }
        append(&costs1, cost1);
        append(&costs2, cost2);
    }

    fmt.println(slice.min(costs1[:]));
    fmt.println(slice.min(costs2[:]));
}