package main;

import "core:strings"
import "core:strconv"
import "core:fmt"

sign :: proc(i: int) -> int {
    if i < 0 do return -1;
    if i > 0 do return  1;
    return 0;
}

main :: proc() {
    file := string(#load("../inputs/05.txt"));
    lines := strings.split(file, "\n");
    
    for pt := 1; pt <= 2; pt += 1 {
        grid := make(map[[2]int]int);
        
        for line in lines {
            words := strings.split(line, " ");
            x1,_ := strconv.parse_int(strings.split(words[0], ",")[0]);
            y1,_ := strconv.parse_int(strings.split(words[0], ",")[1]);
            x2,_ := strconv.parse_int(strings.split(words[2], ",")[0]);
            y2,_ := strconv.parse_int(strings.split(words[2], ",")[1]);
            
            if pt == 2 || (x1 == x2 || y1 == y2) {
                x := x1;
                y := y1;
                for i := 0; i <= max(abs(x2-x1),abs(y2-y1)); i += 1 {
                    grid[{x,y}] += 1;
                    x += sign(x2-x1);
                    y += sign(y2-y1);
                }
            }
        }

        res := 0;
        for pos,count in grid {
            if count > 1 {
                res += 1;
            }
        }
        fmt.println(res);
    }

}