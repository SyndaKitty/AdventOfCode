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
    input := string(#load("../inputs/08.txt"));
    
    pt2 :: true;

    if !pt2
    {
        code_characters := 0;
        string_characters := 0;
        escaping := false;

        for c in input
        {
            switch c
            {
                case '\r': fallthrough;
                case '\n': continue;
                case '\\':
                    if escaping
                    {
                        escaping = false;
                        string_characters = string_characters + 1;
                    }
                    else
                    {
                        escaping = true;
                    }
                case '"':
                    if escaping 
                    {
                        escaping = false;
                        string_characters = string_characters + 1;
                    }
                case 'x':
                    if escaping
                    {
                        escaping = false;
                        string_characters = string_characters - 1;
                    }
                    else
                    {
                        string_characters = string_characters + 1;
                    }
                case:
                    string_characters = string_characters + 1;

            }
            code_characters = code_characters + 1;
        }

        fmt.println("Code characters:", code_characters);
        fmt.println("String characters:", string_characters);
        fmt.println("Result:", code_characters - string_characters);
    }
    else
    {
        encoded_characters := 0;
        original_characters := 0;
        
        for c in input 
        {
            switch c
            {
                case '\r': 
                    continue;
                case '\n': 
                    // Two capturing quotes
                    encoded_characters = encoded_characters + 2;
                    continue;
                case '\\': fallthrough;
                case '\"':
                    encoded_characters = encoded_characters + 2;
                case:
                    encoded_characters = encoded_characters + 1;
            }
            original_characters = original_characters + 1;
        }

        fmt.println("Original characters:", original_characters);
        fmt.println("Encoded characters:", encoded_characters);
        fmt.println("Result:", encoded_characters - original_characters);
    }

}