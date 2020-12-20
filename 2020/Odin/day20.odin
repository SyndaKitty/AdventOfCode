package main

import "core:fmt"
import "core:strings"
import "core:strconv"

import "../../libs/Odin/aoc"

Tile :: struct {
    id: int,
    sides: [dynamic]int
}

LENGTH :: 10;
LL :: LENGTH - 1;

side_to_int :: proc(side: [dynamic]rune) -> (int,int) {
    forward := 0;
    digit_val := 1;
    for i:= 0; i < len(side); i += 1 {
        forward += digit_val * (0 if side[i] == '.' else 1);
        digit_val *= 10;
    }

    backward := 0;
    digit_val = 1;
    for i := len(side) - 1; i >= 0; i -= 1 {
        backward += digit_val * (0 if side[i] == '.' else 1);
        digit_val *= 10;
    }

    return forward, backward;
}

main :: proc() {
    input := string(#load("../inputs/20.txt"));

    tiles := make([dynamic]Tile);
    unplaced_tiles: map[int]Tile;

    tile_blocks := strings.split(input, "\r\n\r\n");
    start_id: int;
    for tile_block in tile_blocks {
        tile_lines := strings.split(tile_block, "\r\n");
        id := aoc.parse_int(aoc.replace(aoc.replace(tile_lines[0], "Tile ", ""), ":", ""));
        mapping: map[i64]rune;
        x := 0;
        y := 0;
        for line in tile_lines[1:len(tile_lines)]
        {
            for c in line {
                mapping[aoc.h2D(x, y)] = c;
                x += 1;
            }
            y += 1;
            x = 0;
        }    
        
        top, bottom, left, right: [dynamic]rune;
        for x in 0..<LENGTH {
            append(&top, mapping[aoc.h2D(x, 0)]);
            append(&bottom, mapping[aoc.h2D(LL-x, LL)]);
            append(&left, mapping[aoc.h2D(0, LL-x)]);
            append(&right, mapping[aoc.h2D(LL, x)]);
        }
        
        topf,topb := side_to_int(top);
        bottomf,bottomb := side_to_int(bottom);
        leftf,leftb := side_to_int(left);
        rightf,rightb := side_to_int(right);

        sides: [dynamic]int;
        append(&sides, rightf, topf, leftf, bottomf, rightb, topb, leftb, bottomb);

        tile := Tile{id=id,sides=sides};
        append(&tiles, tile);
        unplaced_tiles[id] = tile;

        start_id = id;
    }

    placed_tiles: map[i64]Tile;
    check_locations: map[i64]Tile;

    place_tile(12, 12, unplaced_tiles[start_id], &placed_tiles, &check_locations, &unplaced_tiles);


    for {
        if len(check_locations) == 0 do break;
        loc: i64;
        adj: Tile;
        // Pick just one location
        for key,tile in check_locations {
            loc = key;
            adj = tile;
        }
        x,y := hash_to_xy(loc);
        find_tile(x, y, &unplaced_tiles, &placed_tiles, &check_locations, adj.id);
        delete_key(&check_locations, loc);
    }

    min_x := max(int);
    min_y := max(int);
    max_x := min(int);
    max_y := min(int);
    for hash,tile in placed_tiles {
        x,y := hash_to_xy(hash);
        min_x = min(min_x, x);
        min_y = min(min_y, y);
        max_x = max(max_x, x);
        max_y = max(max_y, y);
    }
    total := 1;
    total *= placed_tiles[aoc.h2D(min_x, min_y)].id;
    total *= placed_tiles[aoc.h2D(max_x, min_y)].id;
    total *= placed_tiles[aoc.h2D(max_x, max_y)].id;
    total *= placed_tiles[aoc.h2D(min_x, max_y)].id;

    fmt.println(total);
}

find_tile :: proc(x, y: int, unplaced_tiles: ^map[int]Tile, placed_tiles: ^map[i64]Tile, check_locations: ^map[i64]Tile, id: int) {
    for unplaced_id, tile in unplaced_tiles {
        current_tile := tile;
        // Find info about adjacent 
        theta: int;
        match_hash: i64;
        for offx in -1..1 {
            for offy in -1..1 {
                if offx == offy || offx == -offy do continue;
                hash := aoc.h2D(x + offx, y + offy);
                if placed_tiles[hash].id != 0 {
                    match_hash = hash;
                    theta = offset_to_theta(offx, offy);
                }
            }
        }
        side_index := ((theta + 2) %% 4) + 4;
        match_to := placed_tiles[match_hash].sides[side_index];

        for i in 0..<4 {
            //fmt.println(id, unplaced_id, "Comparing", tile.sides[theta], match_to);
            if tile.sides[theta] == match_to {
                place_tile(x, y, tile, placed_tiles, check_locations, unplaced_tiles);
                return;
            }
            flip_tile(current_tile.sides[:]);
            //fmt.println(id, unplaced_id, "Comparing", tile.sides[theta], match_to);
            if tile.sides[theta] == match_to {
                place_tile(x, y, tile, placed_tiles, check_locations, unplaced_tiles);
                return;
            }
            flip_tile(current_tile.sides[:]);
            rotate_tile(current_tile.sides[:]);
        }
    }
}

rotate_tile :: proc(sides: []int) {
    new_sides := make([dynamic]int, LENGTH);
    defer delete(new_sides);

    for i in 0..<4 {
        new_sides[i] = sides[(i+1) %% 4];
        new_sides[i+4] = sides[((i+1) %% 4) + 4];
    }

    for i in 0..<8 {
        sides[i] = new_sides[i];
    }
}

flip_tile :: proc(sides: []int) {
    new_sides := make([dynamic]int, LENGTH);
    defer delete(new_sides);

    new_sides[0] = sides[4];
    new_sides[1] = sides[7];
    new_sides[2] = sides[6];
    new_sides[3] = sides[5];
    new_sides[4] = sides[0];
    new_sides[5] = sides[3];
    new_sides[6] = sides[2];
    new_sides[7] = sides[1];

    for i in 0..<8 {
        sides[i] = new_sides[i];
    }
}

place_tile :: proc(x, y: int, tile: Tile,
                    placed_tiles: ^map[i64]Tile, check_locations: ^map[i64]Tile, unplaced_tiles: ^map[int]Tile) {
    hash := aoc.h2D(x, y);

    delete_key(check_locations, hash);

    for dx in -1..1 {
        for dy in -1..1 {
            if dx == dy || dx == -dy do continue;
            dhash := aoc.h2D(x + dx, y + dy);
            if dhash in placed_tiles^ do continue;
            check_locations[dhash] = tile;
        }
    } 
    
    placed_tiles[hash] = tile;
    delete_key(unplaced_tiles, tile.id);
}


hash_to_xy :: proc(hash: i64) -> (int, int) {
    mask_32 :: 1 << 32 - 1;

    x := hash & mask_32;
    y := (hash >> 32) & mask_32;

    return int(x),int(y);
}

offset_to_theta :: proc(x, y: int) -> int {
    if x == 1 do return 0;
    if y == 1 do return 1;
    if x == -1 do return 2;
    if y == -1 do return 3;
    assert(false);
    return -1;
}