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

Offset :: struct {
    dx: int,
    dy: int,
    theta: int
}


side_to_int :: proc(side: [dynamic]bool) -> (int,int) {
    forward := 0;
    digit_val := 1;
    for i:= 0; i < len(side); i += 1 {
        forward += digit_val * (1 if side[i] else 0);
        digit_val *= 10;
    }

    backward := 0;
    digit_val = 1;
    for i := len(side) - 1; i >= 0; i -= 1 {
        backward += digit_val * (1 if side[i] else 0);
        digit_val *= 10;
    }

    return forward, backward;
}

main :: proc() {
    input := string(#load("../inputs/20.txt"));

    tiles := make(map[int][dynamic][dynamic]bool);
    unplaced_tiles: map[int]Tile;

    tile_blocks := strings.split(input, "\r\n\r\n");
    start_id: int;
    for tile_block in tile_blocks {
        tile_lines := strings.split(tile_block, "\r\n");
        id := aoc.parse_int(aoc.replace(aoc.replace(tile_lines[0], "Tile ", ""), ":", ""));

        x := 0;
        y := 0;
        lines := make([dynamic][dynamic]bool, 10);
        for line,line_i in tile_lines[1:len(tile_lines)]
        {
            line_bools := make([dynamic]bool, 10);
            for c,i in line {
                line_bools[i] = c == '#';
                x += 1;
            }
            lines[line_i] = line_bools;
            y += 1;
            x = 0;
        }    
        tiles[id] = lines;

        top, bottom, left, right: [dynamic]bool;
        for x in 0..<10 {
            append(&top, lines[0][x]);
            append(&bottom, lines[9][9-x]);
            append(&left, lines[9-x][0]);
            append(&right, lines[x][9]);
        }

        sides := make([dynamic]int, 8);
        sides[0],sides[4] = side_to_int(right);
        sides[1],sides[5] = side_to_int(top);
        sides[2],sides[6] = side_to_int(left);
        sides[3],sides[7] = side_to_int(bottom);

        tile := Tile{id=id,sides=sides};
        unplaced_tiles[id] = tile;

        start_id = id;
    }

    placed_tiles: map[aoc.V2]Tile;
    check_positions: map[aoc.V2]aoc.V2;

    place_tile(aoc.V2{0,0}, unplaced_tiles[start_id], &placed_tiles, &check_positions, &unplaced_tiles);

    for {
        if len(check_positions) == 0 do break;
        for pos,from in check_positions {
            find_tile(pos, from, &unplaced_tiles, &placed_tiles, &check_positions);
            delete_key(&check_positions, pos);
            break;
        }
    }

    min_pos:= aoc.V2{max(int), max(int)};
    max_pos := aoc.V2{min(int), min(int)};
    for pos,tile in placed_tiles {
        min_pos = aoc.min(min_pos, pos);
        max_pos = aoc.max(max_pos, pos);
    }
    total := 1;
    total *= placed_tiles[min_pos].id;
    total *= placed_tiles[max_pos].id;
    total *= placed_tiles[aoc.V2{min_pos[0], max_pos[1]}].id;
    total *= placed_tiles[aoc.V2{max_pos[0], min_pos[1]}].id;

    fmt.println(total);

    image := make_image(tiles, placed_tiles, min_pos, max_pos);

    wave_count := 0;
    for y in 0..<len(image) {
        for x in 0..<len(image[y]) {
            if image[y][x] do wave_count += 1;
        }
    }

    monster_total := 0;
    for i in 0..3 {
        monster_total += look_for_monster(image);
        aoc.flip_rows(image);
        monster_total += look_for_monster(image);
        aoc.flip_rows(image);
        aoc.rotate_cw(image);
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


make_image :: proc(tile_data: map[int][dynamic][dynamic]bool, placed_tiles: map[aoc.V2]Tile, min, max: aoc.V2) -> [dynamic][dynamic]bool {
    L := ((max-min)[0]+1) * 8;
    LL:= L - 1;
    image := make([dynamic][dynamic]bool, L);
    for y in 0..LL {
        image[y] = make([dynamic]bool, L);
    }
    
    for tile_y := max[1]; tile_y >= min[1]; tile_y -= 1 {
        for tile_x in min[0]..max[0] {
            tile := placed_tiles[aoc.V2{tile_x, tile_y}];
            
            stripped_data := make([dynamic][dynamic]bool, 8);
            for i in 0..7 {
                stripped_data[i] = make([dynamic]bool, 8);
                for j in 0..7 {
                    stripped_data[i][j] = tile_data[tile.id][i + 1][j + 1];
                }
            }

            for rot in 0..<tile.rotations {
                aoc.rotate_cw(stripped_data);
            }
            if tile.flipped {
                aoc.flip_rows(stripped_data);
            }
            
            tox := (tile_x-min[0])*8;
            toy := (max[1]-tile_y)*8;
            for y in 0..7 {
                for x in 0..7 {
                    image[y+toy][x+tox] = stripped_data[y][x];
                }
            }
        }
    }
    return image;
}

find_tile :: proc(pos, from: aoc.V2, unplaced_tiles: ^map[int]Tile, placed_tiles: ^map[aoc.V2]Tile, check_positions: ^map[aoc.V2]aoc.V2) {
    using aoc;
    delta := from-pos;
    θ := int_angle(delta);
    side_index := ((θ + 2) %% 4) + 4;
    
    for unplaced_id, tile in unplaced_tiles {
        current_tile := tile;

        match_to := placed_tiles[from].sides[side_index];

        for i in 0..<4 {
            if tile.sides[θ] == match_to {
                tile.rotations = i;
                place_tile(pos, tile, placed_tiles, check_positions, unplaced_tiles);
                return;
            }
            flip_tile(current_tile.sides[:]);
            if tile.sides[θ] == match_to {
                tile.rotations = i;
                tile.flipped = true;
                place_tile(pos, tile, placed_tiles, check_positions, unplaced_tiles);
                return;
            }
            flip_tile(current_tile.sides[:]);
            rotate_tile_cw(current_tile.sides[:]);
        }
    }
}

rotate_tile_cw :: proc(sides: []int) {
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

place_tile :: proc(pos: aoc.V2, tile: Tile, placed: ^map[aoc.V2]Tile, check: ^map[aoc.V2]aoc.V2, unplaced: ^map[int]Tile) {
    for d in aoc.cos_sin {
        dpos := d + pos;
        if dpos in placed^ do continue;
        check[dpos] = pos;
    }
    
    placed[pos] = tile;
    delete_key(unplaced, tile.id);
}