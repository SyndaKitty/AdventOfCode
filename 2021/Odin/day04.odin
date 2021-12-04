package main;

import "core:strings"
import "core:strconv"
import "core:fmt"

Board :: struct {
    marked : map[[2]int]bool,
    value: map[[2]int]int,
    solved: bool,
};

sum :: proc(board: ^Board) -> int {
    amt := 0;
    for key,value in board.value {
        if !board.marked[key] {
            amt += value;
        }
    }
    return amt;
}

main :: proc() {
    
    file := string(#load("../inputs/04.txt"));
    groups := strings.split(file, "\n\n");
    input := strings.split(groups[0], ",");
    numbers := make([dynamic]int);
    for num in input {
        n,_ := strconv.parse_int(num);
        append(&numbers, n);
    }

    boards := make([dynamic]^Board);
    for group in groups[1:] {
        board := new(Board);
        append(&boards, board);
        for y in 0..4 {
            for x in 0..4 {
                index := y*15 + x*3;
                num,_ := strconv.parse_int(strings.trim_left_space(group[index:index+2]));
                board.value[{x,y}] = num;
            }
        }
    }

    first := true
    count := 0

    for num in numbers {
        for board in boards {
            for key,value in board.value {
                if value == num {
                    board.marked[key] = true
                }
            }
            for x in 0..4 {
                complete_row := true
                complete_col := true
                for y in 0..4 {
                    if !board.marked[{x,y}] {
                        complete_row = false
                    }
                    if !board.marked[{y,x}] {
                        complete_col = false
                    }
                }
                if complete_row || complete_col {
                    if !board.solved {
                        count += 1
                        
                        board.solved = true
                        if count == len(boards) {
                            fmt.println(sum(board) * num)
                        }
                    }
                    
                    if first {
                        first = false;
                        fmt.println(sum(board) * num)
                    }
                }
            }
        }
    }
}