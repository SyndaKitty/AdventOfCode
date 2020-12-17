package main

import "core:fmt"
import "core:strings"
import "core:strconv"

import "../../libs/Odin/aoc"

main :: proc() {
    input := string(#load("../inputs/17.txt"));
    lines := strings.split(input, "\r\n");

    cells: map[i64]bool;
    new_cells: map[i64]bool;
    active_cells: map[i64]bool;

    x := 0;
    y := 0;
    z := 0;
    w := 0;
    for line in lines {
        for c in line {
            activate_cell(&active_cells, x, y, z, w);
            switch c {
                case '.':
                    cells[h4d(x,y,z,w)] = false;
                case '#':
                    cells[h4d(x,y,z,w)] = true;
            }
            x += 1;
        }
        x = 0;
        y += 1;
    }

    for i := 0; i < 6; i += 1 {
        target := make(map[i64]bool);
        simulate(cells, &active_cells, &target);
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

simulate :: proc(cells: map[i64]bool, active_cells, target_cells: ^map[i64]bool ) {
    to_activate: [dynamic][4]int;
    for cell in active_cells {
        x,y,z,w := hash_to_xyzw(cell);
        count := count_neighbors(cells, x, y, z, w);

        if cells[cell] {
            if (count == 2 || count == 3) {
                // Remain active
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

        append(&to_activate, [4]int{x, y, z,w});
    }

    for act in to_activate {
        activate_cell(active_cells, act[0], act[1], act[2], act[3]);
    }
}

activate_cell :: proc(active_cells: ^map[i64]bool, x,y,z,w: int) {
    for dw in -1..1 {
        for dz in -1..1 {
            for dy in -1..1 {
                for dx in -1..1 {
                    active_cells[h4d(x+dx,y+dy,z+dz,w+dw)] = true;
                }
            }
        }
    }
}

count_neighbors :: proc(cells: map[i64]bool, x, y, z, w: int) -> int {
    neighbors := 0;

    for dw in -1..1 {
        for dz in -1..1 {
            for dy in -1..1 {
                for dx in -1..1 {
                    if dw == 0 && dz == 0 && dy == 0 && dx == 0 {
                        continue;
                    }
                    neighbors += 1 if cells[h4d(x+dx,y+dy,z+dz,w+dw)] else 0;
                }
            }
        }
    }

    return neighbors;
}

h4d :: proc(x, y, z, w: int) -> i64 {
    mask_15 :: 1 << 15 - 1;

    x_15 := i64(x & mask_15);
    y_15 := i64(y & mask_15);
    z_15 := i64(z & mask_15);
    w_15 := i64(w & mask_15);

    hash : i64 = w_15 << 45 + z_15 << 30 + y_15 << 15 + x_15;

    return hash;
}

hash_to_xyzw :: proc(hash: i64) -> (int, int, int, int) {
    mask_15 :: 1 << 15 - 1;
    x := hash & mask_15;
    y := (hash >> 15) & mask_15;
    z := (hash >> 30) & mask_15;
    w := (hash >> 45) & mask_15;

    return int(x), int(y), int(z), int(w);
}