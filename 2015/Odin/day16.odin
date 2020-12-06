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


main :: proc()
{
    input := string(#load("../inputs/16.txt"));
    
    pt2 :: true;

    using parse;

    aunt_info : [500]map[string]int;

    parse_info := make_parse_info(input);
    parse_info.search = {TokenType.Word, TokenType.Number};

    check: map[string]int;
    check["children"] = 3;
    check["cats"] = 7;
    check["samoyeds"] = 2;
    check["pomeranians"] = 3;
    check["akitas"] = 0;
    check["vizslas"] = 0;
    check["goldfish"] = 5;
    check["trees"] = 3;
    check["cars"] = 2;
    check["perfumes"] = 1;


    sue_check: for i in 0..<500 
    {
        // Read sue #
        parse_next(&parse_info);
        parse_next(&parse_info);

        for j in 0..<3
        {
            name_token,_ := parse_next(&parse_info);
            number_token,_ := parse_next(&parse_info);
            aunt_info[i][name_token.data] = number_token.number;
        }

        for k,v in check
        {
            if !(k in aunt_info[i]) do continue;
            if pt2
            {
                if k == "cats" || k == "trees"
                {
                    if aunt_info[i][k] <= v do continue sue_check;
                }
                else if k == "pomeranians" || k == "goldfish"
                {
                    if aunt_info[i][k] >= v do continue sue_check;
                }
                else if v != aunt_info[i][k]
                {
                    continue sue_check;
                }
            }
            else if v != aunt_info[i][k]
            {
                continue sue_check;
            }
        }

        fmt.println("Sue #", i+1, "is a match");
    }
}