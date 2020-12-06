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


is_vowel :: proc(c: rune) -> bool
{
    if c == 'a' do return true;
    if c == 'e' do return true;
    if c == 'i' do return true;
    if c == 'o' do return true;
    if c == 'u' do return true;
    return false;
}


is_naughty_string :: proc(prev_c: rune, c: rune) -> bool
{
    // ab, cd, pq, or xy
    if prev_c == 'a' && c == 'b' do return true;
    if prev_c == 'c' && c == 'd' do return true;
    if prev_c == 'p' && c == 'q' do return true;
    if prev_c == 'x' && c == 'y' do return true;
    return false;
}


has_double_pair :: proc(data: []i64) -> bool
{
    for i:=0; i < len(data); i=i+1
    {
        if data[i] == 0 do continue;
        for j:=i+1; j < len(data); j=j+1
        {
            if data[j] == 0 do continue;

            // If the pair are the same hash
            same_hash := data[i] == data[j];
            overlapping := j - i == 1;

            if same_hash && !overlapping do return true;
        }
    }
    return false;
}


main :: proc()
{
    input := string(#load("../inputs/05.txt"));

    pt2 :: true;

    nice_word_count := 0;

    if !pt2
    {
        prev_c := ' ';
        duplicate := false;
        vowel_count := 0;
        invalid := false;

        for c in input 
        {
            switch c
            {
                case '\n':
                    // Check conditions
                    if !invalid && vowel_count >= 3 && duplicate 
                    {
                        nice_word_count = nice_word_count + 1;
                    }

                    prev_c = ' ';
                    duplicate = false;
                    vowel_count = 0;
                    invalid = false;
                case:
                    if is_vowel(c) do vowel_count = vowel_count + 1;
                    if prev_c == c do duplicate = true;
                    if is_naughty_string(prev_c, c) do invalid = true;
                    prev_c = c;
            }
        }    
    }
    else
    {
        pairs := make([]i64, 15);
        defer delete(pairs);

        prev_prev_c := ' ';
        prev_c := ' ';
        stagger := false;
        char_pos := 0;

        for c in input
        {
            switch c 
            {
                case '\r':
                    ;
                case '\n':
                    // Check conditions
                    dd := has_double_pair(pairs);
                    // fmt.println("Stagger:", stagger, "DD:", dd);
                    if stagger && dd 
                    {
                        nice_word_count = nice_word_count + 1;
                    }

                    prev_prev_c = ' ';
                    prev_c = ' ';
                    stagger = false;
                    char_pos = 0;
                case:
                    // fmt.print(prev_prev_c, prev_c, c);
                    if prev_prev_c == c do stagger = true;
                    // fmt.print(" Stagger:", stagger);
                    if char_pos >= 1 
                    {
                        pairs[char_pos - 1] = aoc.hash_2D(int(prev_c), int(c));
                    }
                    
                    // fmt.print(" pair: ");
                    // for i:=0; i<len(pairs);i=i+1
                    // {
                    //     fmt.print(pairs[i], "|");
                    // }

                    prev_prev_c = prev_c;
                    prev_c = c;
                    char_pos = char_pos + 1;
                    // fmt.println();
            }
        }
    }

    fmt.println("Number of nice words:", nice_word_count);
}