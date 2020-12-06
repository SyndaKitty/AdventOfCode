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


valid_pass :: proc(word: ^strings.Builder) -> bool
{
    length := len(word.buf);
    
    three_letter_run := false;
    pairs := 0;

    for i := 0; i < length - 2; i = i + 1
    {
        if word.buf[i+0] + 1 == word.buf[i+1]
        && word.buf[i+1] + 1 == word.buf[i+2] 
        {
            three_letter_run = true;
        }

        if word.buf[i] == word.buf[i+1] 
        && word.buf[i] != word.buf[i+2]
        {
            pairs = pairs + 1;
        }
    }

    // Check for pair at end
    if word.buf[length-3] != word.buf[length-2] 
    && word.buf[length-2] == word.buf[length-1]
    {
        pairs = pairs + 1;
    }

    return three_letter_run && pairs >= 2;
}


increment_word :: proc(word: ^strings.Builder)
{
    end := len(word.buf) - 1;
    for i := 0; i < end; i = i + 1
    {
        next_val := word.buf[end - i] + 1;
        if next_val == byte('z' + 1)
        {
            word.buf[end - i] = 'a';
        }
        else if next_val == 'i' || next_val == 'o' || next_val == 'l'
        {
            // Skip blacklisted letters
            word.buf[end - i] = next_val + 1;
            break;
        }
        else
        {
            word.buf[end - i] = next_val;
            break;
        }
    }
}


main :: proc()
{
    input := string(#load("../inputs/11.txt"));

    pt2 :: true;

    password := strings.make_builder();
    strings.write_string(&password, input);

    for
    {
        increment_word(&password);
        if valid_pass(&password) do break;
    }
    if pt2 do for
    {
        increment_word(&password);
        if valid_pass(&password) do break;
    }

    fmt.println(strings.to_string(password));
}


