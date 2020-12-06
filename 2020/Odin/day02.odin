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

main :: proc()
{
    input := string(#load("../inputs/02.txt"));

    using parse;
    parse_info := make_parse_info(input);
    parse_info.search = {TokenType.Word, TokenType.Number};

    valid := 0;

    for has_next(&parse_info)
    {
        // 4-9 m: xvrwfmkmmmc
        low := next_number(&parse_info);
        next_rune(&parse_info);
        high := next_number(&parse_info);
        letter := rune(next_word(&parse_info)[0]);
        word := next_word(&parse_info);

        // count := 0;
        // for c in word
        // {
        //     if c == rune(letter)
        //     {
        //         count += 1;
        //     }
        // }
        // fmt.println(word, "has", count, letter, "against", low, "-", high, count >= low && count <= high);
        // if count >= low && count <= high
        // {
        //     valid += 1;
        // }

        left := word[low-1] == u8(letter);
        right := word[high-1] == u8(letter);
        if left ~ right do valid += 1;
    }
    

    fmt.println(valid);
}