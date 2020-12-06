package main

import "core:math"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:container"
import "core:time"
import "core:sys/windows"


// Custom libraries
import "../../libs/Odin/aoc"
import "../../libs/Odin/permute"
import "../../libs/Odin/parse"


count_trees :: proc(trees: map[i64]bool, slope_x, slope_y, max_x, max_y: int) -> int
{
    using aoc;
    x := slope_x;
    y := slope_y;
    tree_count := 0;

    for 
    {
        //fmt.println("Checking", x, y, trees[hash_2D(x, y)]);
        if trees[hash_2D(x, y)] do tree_count += 1;
        x += slope_x;
        x %= max_x;
        y += slope_y;
        if y >= max_y do break;
    }

    return tree_count;
}


main :: proc()
{
    input := string(#load("../inputs/03.txt"));

    using parse;
    using aoc;

    parse_info := make_parse_info(input);
    parse_info.search = {TokenType.Word, TokenType.Number};

    trees := make(map[i64]bool);

    x := 0;
    y := 0;
    max_y := 0;
    max_x := 0;
    for c in input
    {
        switch c
        {
            case '.':
                trees[hash_2D(x,y)] = false;
                x += 1;
                max_x = x;
            case '#':
                trees[hash_2D(x,y)] = true;
                x += 1;
                max_x = x;
            case '\n':
                x = 0;
                y += 1;
                max_y = y+1;
        }
    }

    fmt.println(count_trees(trees, 1, 1, max_x, max_y));
    fmt.println(count_trees(trees, 3, 1, max_x, max_y));
    fmt.println(count_trees(trees, 5, 1, max_x, max_y));
    fmt.println(count_trees(trees, 7, 1, max_x, max_y));
    fmt.println(count_trees(trees, 1, 2, max_x, max_y));

    fmt.println(count_trees(trees, 1, 1, max_x, max_y)
    * count_trees(trees, 3, 1, max_x, max_y)
    * count_trees(trees, 5, 1, max_x, max_y)
    * count_trees(trees, 7, 1, max_x, max_y)
    * count_trees(trees, 1, 2, max_x, max_y));
}