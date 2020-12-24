package main

import "core:fmt"
import "core:strings"
import "core:strconv"

import "../../libs/Odin/aoc"

neighbors := [?][2]int{{0, 1}, {-1, 1}, {1,-1}, {0, -1}, {-1, 0}, {1, 0}};
dirs := map[string]int {"ne"=0, "nw"=1, "se"=2, "sw"=3, "w"=4, "e"=5};

main :: proc() {
    input := string(#load("../inputs/24.txt"));
    lines := strings.split(input, "\r\n");

    tiles: map[[2]int]bool;
    activated: map[[2]int]bool;

    for line in lines {
        L := len(line);
        pos: [2]int;
        for i:=0; i < L; {
            segment1 := line[i:min(i+1,L)];
            segment2 := line[i:min(i+2,L)];
            command: int;
            if segment2 in dirs {
                command = dirs[segment2];
                i += 2;
            } 
            else {
                command = dirs[segment1];
                i += 1;
            }
            pos += neighbors[command];
        }
        set_tile(pos, !tiles[pos], &tiles, &activated);

    }
    fmt.println(count_tiles(tiles));

    out_tiles := make(map[[2]int]bool);
    for i in 1..100 {
        simulate(&tiles,&out_tiles,&activated);
        aoc.clear_map(&tiles);
        for pos,val in out_tiles {
            tiles[pos] = val;
        }
    }
    fmt.println(count_tiles(tiles));
}

count_tiles :: proc(tiles: map[[2]int]bool) -> int {
    total := 0;
    for pos,val in tiles {
        if val {
            total += 1;
        }
    }
    return total;
}

set_tile :: proc(pos: [2]int, new_state: bool, tiles, activated: ^map[[2]int]bool) {
    tiles^[pos] = new_state;
    activated^[pos] = true;
    for d in neighbors {
        new_pos := pos + d;
        activated^[new_pos] = true;
    }
}

simulate :: proc(input, out, activated: ^map[[2]int]bool) {
    to_set: map[[2]int]bool;
    for pos in activated^ {
        value := input[pos];
        n := 0;
        for d in neighbors {
            if input[pos+d] {
                n += 1;
            }
        }
        
        if (value && (n == 0 || n > 2)) || (!value && n == 2) {
            to_set[pos] = !value;
        }
        else {
            to_set[pos] = value;
        }
    }

    for pos,v in to_set {
        set_tile(pos, v, out, activated);
    }
}