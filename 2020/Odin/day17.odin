package main

import "core:fmt"
import "core:strings"
import "core:strconv"

import "../../libs/Odin/aoc"

V4 :: aoc.V4;

main :: proc() {
    input := string(#load("../inputs/17.txt"));
    lines := strings.split(input, "\r\n");

    run(lines, false);
    run(lines, true);
}

run :: proc(lines: []string, pt2: bool) {
    cells: map[V4]bool;
    new_cells: map[V4]bool;
    active_cells: map[V4]bool;

    pos: V4;
    for line in lines {
        for c in line {
            activate_cell(&active_cells, pos, pt2);
            cells[pos] = c == '#';
            pos[0] += 1;
        }
        pos[0] = 0;
        pos[1] += 1;
    }

    for i := 0; i < 6; i += 1 {
        target := make(map[V4]bool);
        simulate(cells, &active_cells, &target, pt2);
        aoc.clear_map(&cells);
        for key, value in target {
            cells[key] = value;
        }
    }

    count := 0;
    for key, value in cells {
        if value do count += 1;
    }
    fmt.println(count);
}

simulate :: proc(cells: map[V4]bool, active_cells, target_cells: ^map[V4]bool, pt2: bool) {
    to_activate: [dynamic]V4;
    for cell in active_cells {
        count := count_neighbors(cells, cell, pt2);

        if cells[cell] {
            if (count == 2 || count == 3) {
                target_cells[cell] = true;
            }
            else {
                target_cells[cell] = false;
            }
        }
        else {
            if count == 3 {
                target_cells[cell] = true;
            }

        }

        append(&to_activate, cell);
    }

    for act in to_activate {
        activate_cell(active_cells, act, pt2);
    }
}

activate_cell :: proc(active_cells: ^map[V4]bool, pos: V4, pt2: bool) {
    for dw in -1..1 {
        if !pt2 && dw != 0 do continue;
        for dz in -1..1 {
            for dy in -1..1 {
                for dx in -1..1 {
                    active_cells[pos+V4{dx,dy,dz,dw}] = true;
                }
            }
        }
    }
}

count_neighbors :: proc(cells: map[V4]bool, pos: V4, pt2: bool) -> int {
    neighbors := 0;

    for dw in -1..1 {
        if !pt2 && dw != 0 do continue;
        for dz in -1..1 {
            for dy in -1..1 {
                for dx in -1..1 {
                    if dw == 0 && dz == 0 && dy == 0 && dx == 0 {
                        continue;
                    }
                    neighbors += 1 if cells[pos+V4{dx,dy,dz,dw}] else 0;
                }
            }
        }
    }

    return neighbors;
}