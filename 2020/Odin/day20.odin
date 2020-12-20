package main

import "core:fmt"
import "core:strings"
import "core:strconv"

import "../../libs/Odin/aoc"

Tile :: struct {
    id: int,
    sides: [dynamic]int,
    rotations: int,
    flipped: bool
}

side_to_int :: proc(side: [dynamic]rune) -> (int,int) {
    forward := 0;
    digit_val := 1;
    for i:= 0; i < len(side); i += 1 {
        forward += digit_val * (0 if side[i] == '.' else 1);
        digit_val *= 2;
    }

    backward := 0;
    digit_val = 1;
    for i := len(side) - 1; i >= 0; i -= 1 {
        backward += digit_val * (0 if side[i] == '.' else 1);
        digit_val *= 2;
    }

    return forward, backward;
}

main :: proc() {
    
    // test_data := make([dynamic][dynamic]int, 4);
    // for y in 0..3 { 
    //     test_data[y] = make([dynamic]int, 4);
    //     for x in 0..3 {
    //         test_data[y][x] = y * 4 + x;
    //     }
    // }

    // flip_horizontal(test_data);
    // rotate(test_data);
    // for y in 0..3 {
    //     for x in 0..3 {
    //         fmt.print(test_data[y][x]);
    //     }
    //     fmt.println();
    // }



    input := string(#load("../inputs/20.txt"));

    tiles := make(map[int][dynamic][dynamic]bool);
    unplaced_tiles: map[int]Tile;

    tile_blocks := strings.split(input, "\r\n\r\n");
    start_id: int;
    for tile_block in tile_blocks {
        tile_lines := strings.split(tile_block, "\r\n");
        id := aoc.parse_int(aoc.replace(aoc.replace(tile_lines[0], "Tile ", ""), ":", ""));
        mapping: map[i64]rune;
        x := 0;
        y := 0;
        lines := make([dynamic][dynamic]bool, 10);
        for line,line_i in tile_lines[1:len(tile_lines)]
        {
            line_bools := make([dynamic]bool, 10);
            for c,i in line {
                line_bools[i] = c == '#';
                mapping[aoc.h2D(x, y)] = c;
                x += 1;
            }
            lines[line_i] = line_bools;
            y += 1;
            x = 0;
        }    
        tiles[id] = lines;

        top, bottom, left, right: [dynamic]rune;
        for x in 0..<10 {
            append(&top, mapping[aoc.h2D(x, 0)]);
            append(&bottom, mapping[aoc.h2D(9-x, 9)]);
            append(&left, mapping[aoc.h2D(0, 9-x)]);
            append(&right, mapping[aoc.h2D(9, x)]);
        }
        
        topf,topb := side_to_int(top);
        bottomf,bottomb := side_to_int(bottom);
        leftf,leftb := side_to_int(left);
        rightf,rightb := side_to_int(right);

        sides: [dynamic]int;
        append(&sides, rightf, topf, leftf, bottomf, rightb, topb, leftb, bottomb);

        tile := Tile{id=id,sides=sides};
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

    image := make_image(tiles, placed_tiles, min_x, min_y, max_x, max_y);

    wave_count := 0;
    for y in 0..<len(image) {
        for x in 0..<len(image[y]) {
            if image[y][x] do wave_count += 1;
        }
    }

    monster_total := 0;
    for i in 0..3 {
        monster_total += look_for_monster(image);
        flip_horizontal(image);
        monster_total += look_for_monster(image);
        flip_horizontal(image);
        rotate(image);
    }

    fmt.println(wave_count - monster_total * 15);
}


look_for_monster :: proc(image: [dynamic][dynamic]bool) -> int {
    lines := [?]string{
        "                  # ",
        "#    ##    ##    ###",
        " #  #  #  #  #  #   "};
    monster_count := 0;

    for monster_y in 0..len(image)-len(lines) {
        pos: for monster_x in 0..len(image)-len(lines[0]) {
            for y in 0..<len(lines) {
                for x in 0..<len(lines[y]) {
                    if lines[y][x] == ' ' do continue;
                    if !image[monster_y + y][monster_x + x] do continue pos;
                }
            }
            monster_count += 1;
        }
    }
    return monster_count;
}


make_image :: proc(tile_data: map[int][dynamic][dynamic]bool, placed_tiles: map[i64]Tile, minx, miny, maxx, maxy: int) -> [dynamic][dynamic]bool {
    L := (maxx-minx+1) * 8;
    LL:= L - 1;
    image := make([dynamic][dynamic]bool, L);
    for y in 0..LL {
        image[y] = make([dynamic]bool, L);
    }
    
    for tile_y := maxy; tile_y >= miny; tile_y -= 1 {
        for tile_x in minx..maxx {
            tile := placed_tiles[aoc.h2D(tile_x, tile_y)];
            
            stripped_data := make([dynamic][dynamic]bool, 8);
            for i in 0..7 {
                stripped_data[i] = make([dynamic]bool, 8);
                for j in 0..7 {
                    stripped_data[i][j] = tile_data[tile.id][i + 1][j + 1];
                }
            }
            // fmt.println(tile);
            // for y in 0..7 {
            //     for x in 0..7 {
            //         fmt.print('#' if stripped_data[y][x] else '.');
            //     }
            //     fmt.println();
            // }
            // fmt.println();

            for rot in 0..<tile.rotations {
                rotate(stripped_data);
            }
            if tile.flipped {
                flip_horizontal(stripped_data);
            }
            
            // fmt.println();
            // for y in 0..7 {
            //     for x in 0..7 {
            //         fmt.print('#' if stripped_data[y][x] else '.');
            //     }
            //     fmt.println();
            // }
            // fmt.println();
            // fmt.println();

            tox := (tile_x-minx)*8;
            toy := (maxy-tile_y)*8;
            for y in 0..7 {
                for x in 0..7 {
                    // fmt.println(y+toy, x+tox, y, x, len(stripped_data), len(stripped_data[0]));
                    image[y+toy][x+tox] = stripped_data[y][x];
                }
            }
        }
    }
    return image;
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
            if tile.sides[theta] == match_to {
                tile.rotations = i;
                place_tile(x, y, tile, placed_tiles, check_locations, unplaced_tiles);
                return;
            }
            flip_tile(current_tile.sides[:]);
            if tile.sides[theta] == match_to {
                tile.rotations = i;
                tile.flipped = true;
                place_tile(x, y, tile, placed_tiles, check_locations, unplaced_tiles);
                return;
            }
            flip_tile(current_tile.sides[:]);
            rotate_tile(current_tile.sides[:]);
        }
    }
}

rotate_tile :: proc(sides: []int) {
    new_sides := make([dynamic]int, 10);
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
    new_sides := make([dynamic]int, 10);
    defer delete(new_sides);

    ref := [?]int {4, 7, 6, 5, 0, 3, 2, 1};

    for i in 0..<8 {
        new_sides[i] = sides[ref[i]];
    }
    
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
    panic("Call only for adjacent tiles");
}

reverse :: proc(data: [dynamic]$T) {
    for i, j := 0, len(a)-1; i < j; i, j = i+1, j-1 {
        data[i], data[j] = data[j], data[i];
    }
}

flip_horizontal :: proc(data: [dynamic][dynamic]$T) {
    L := len(data);
    LL := L-1;
    for i in 0..LL {
        assert(L == len(data[i]));
    }

    new_data := make([dynamic][dynamic]T, L);
    for i in 0..LL {
        new_data[i] = make([dynamic]T, L);
        for j in 0..LL {
            new_data[i][j] = data[LL-i][j];
        }
    }
    
    for y in 0..LL {
        for x in 0..LL {
            data[y][x] = new_data[y][x];
        }
        delete(new_data[y]);
    }
    delete(new_data);
}

rotate :: proc(data: [dynamic][dynamic]$T) {
    L := len(data);
    LL := L-1;

    new_data := make([dynamic][dynamic]T, L);
    for i in 0..LL {
        new_data[i] = make([dynamic]T, L);
        for j in 0..LL {
            new_data[i][j] = data[LL-j][i];
        }
    }

    for i in 0..LL {
        for j in 0..LL {
            data[i][j] = new_data[i][j];
        }
    }

    for y in 0..LL {
        for x in 0..LL {
            data[y][x] = new_data[y][x];
        }
        delete(new_data[y]);
    }
    delete(new_data);
}