package main

import "core:math"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:container"
import "core:time"


// Custom libraries
import "../../libs/Odin/aoc"
import "../../libs/Odin/permute"
import "../../libs/Odin/parse"


Props :: [4]int;

Ingredient :: struct
{
    props: Props,
    cal: int
}


main :: proc()
{
    input := string(#load("../inputs/15.txt"));

    pt2 :: true;

    using parse;

    parse_info := make_parse_info(input);
    parse_info.search = {TokenType.Number};

    NumIngredients :: 4;
    ingredients: [NumIngredients]Ingredient;

    for i in 0..<NumIngredients
    {
        ingredients[i] = Ingredient{};
        for j in 0..<4
        {
            token,_ := parse_next(&parse_info);
            ingredients[i].props[j] = token.number;
        }
        token,_ := parse_next(&parse_info);
        ingredients[i].cal = token.number;
    }

    //for i in 0..<4 do fmt.println(ingredients[i]);

    p: Props;
    max_score := 0;

    // Max ingredients for each type determined with algebra
    for a in 0..<40
    {
        for b in 0..<50
        {
            for c in 0..<75
            {
                for d in 0..<66
                {
                    if a + b + c +d != 100 do continue;
                    if pt2 && a * ingredients[0].cal + b * ingredients[1].cal 
                        + c * ingredients[2].cal + d * ingredients[3].cal != 500
                    {
                        continue;
                    }

                    p = a * ingredients[0].props + b * ingredients[1].props
                      + c * ingredients[2].props + d * ingredients[3].props;
                    
                    s := max(p[0],0) * max(p[1],0) * max(p[2],0) * max(p[3],0);
                    max_score = max(s, max_score);
                }
            }
        }
    }

    fmt.println(max_score);
}