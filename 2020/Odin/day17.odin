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
    for line in lines {
        for c in line {
            activate_cell(&active_cells, x, y, z);
            switch c {
                case '.':
                    cells[h3d(x,y,z)] = false;
                case '#':
                    cells[h3d(x,y,z)] = true;
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
    to_activate: [dynamic][3]int;
    for cell in active_cells {
        x,y,z := hash_to_xyz(cell);
        count := count_neighbors(cells, x, y, z);

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

        append(&to_activate, [3]int{x, y, z});
    }

    for act in to_activate {
        activate_cell(active_cells, act[0], act[1], act[2]);
    }
}

activate_cell :: proc(active_cells: ^map[i64]bool, x,y,z: int) {
    for dz in -1..1 {
        for dy in -1..1 {
            for dx in -1..1 {
                active_cells[h3d(x+dx,y+dy,z+dz)] = true;
            }
        }
    }
}

count_neighbors :: proc(cells: map[i64]bool, x, y, z: int) -> int {
    neighbors := 0;

    for dz in -1..1 {
        for dy in -1..1 {
            for dx in -1..1 {
                if dz == 0 && dy == 0 && dx == 0 {
                    continue;
                }
                neighbors += 1 if cells[h3d(x+dx,y+dy,z+dz)] else 0;
            }
        }
    }

    return neighbors;
}

h3d :: proc(x, y, z: int) -> i64 {
    mask_20 :: 1 << 20 - 1;

    x_20 := i64(x & mask_20);
    y_20 := i64(y & mask_20);
    z_20 := i64(z & mask_20);

    hash : i64 = z_20 << 40 + y_20 << 20 + x_20;

    return hash;
}

hash_to_xyz :: proc(hash: i64) -> (int, int, int) {
    mask_20 :: 1 << 20 - 1;
    x := hash & mask_20;
    y := (hash >> 20) & mask_20;
    z := (hash >> 40) & mask_20;

    return int(x), int(y), int(z);
}