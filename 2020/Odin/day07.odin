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


Mapping :: struct
{
    container: []string,
    contents: []string,
    id: int
};


main :: proc()
{
    using aoc;

    input := string(#load("../inputs/07.txt"));
    input,_ = strings.replace_all(input, " contain", "");
    input,_ = strings.replace_all(input, " bags", "");
    input,_ = strings.replace_all(input, " bag", "");
    input,_ = strings.replace_all(input, ",", "");
    input,_ = strings.replace_all(input, ".", "");
    lines := strings.split(input, "\r\n");

    mappings := make([dynamic]Mapping);
    id := 0;

    for line in lines
    {
        fmt.println(line);

        words := strings.split(line, " ");
        container := words[0:2];
        fmt.println(container);
        for i := 2; i < len(words) - 2; i += 3
        {
            // ignore number
            contents := words[i+1:i+3];
            fmt.println(contents);

            append(&mappings, Mapping{container, contents, id});
        }
        id += 1;
    }

    valid_colors := make([dynamic][]string);
    append(&valid_colors, strings.split("shiny gold", " "));
    added_colors := make(map[int]bool);

    for i := 0; i < len(valid_colors); i += 1
    {
        for mapping in mappings
        {
            if mapping.id in added_colors
            {
                fmt.println("Already added id", mapping.id);
                continue;
            }

            equal := true;
            for str,j in mapping.contents
            {
                if str != valid_colors[i][j]
                {
                    equal = false;
                    break;
                }
            }

            if equal
            {
                fmt.println("Adding", mapping, "as valid color because it contains", valid_colors[i]);
                append(&valid_colors, mapping.container);
                added_colors[mapping.id] = true;
            }
        }
    }

    fmt.println(len(valid_colors) - 1);


    // parse_info := parse.make_parse_info(input);
    // for parse.has_next(&parse_info)
    // {
    //     parse.next_rune(&parse_info);
    //     parse.next_number(&parse_info);
    //     parse.next_word(&parse_info);
    // }

    // for c in input
    // {
    //     switch c
    //     {
    //         case ' ':

    //     }
    // }

    fmt.println();
}