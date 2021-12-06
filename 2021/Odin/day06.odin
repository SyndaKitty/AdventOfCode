package main

import "core:fmt"
import "core:strings"
import "core:strconv"

main :: proc() {
    file := string(#load("../inputs/06.txt"));
    nums := strings.split(file, ",");
    
    fish: [9]int;
    for num in nums {
        n,_ := strconv.parse_int(num);
        fish[n] += 1;
    }

    for i in 0..255 {
        if i == 80 {
            total := 0;
                for i in 0..<9 {
                total += fish[i];
            }
            fmt.println(total);
        }

        count := fish[0];

        for i in 0..<8 {
            fish[i] = fish[i+1];
        }

        fish[6] += count;
        fish[8] = count;
    }

    total := 0;
    for i in 0..<9 {
        total += fish[i];
    }
    fmt.println(total);
}