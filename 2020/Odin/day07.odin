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
    count: int,
    id: int
};

// BagNode :: struct
// {
//     num: int,
//     color: []string,
//     children: [dynamic]BagNode
// }


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
        words := strings.split(line, " ");
        container := words[0:2];
        for i := 2; i < len(words) - 2; i += 3
        {
            count,_ := strconv.parse_int(words[i]);
            contents := words[i+1:i+3];

            append(&mappings, Mapping{container, contents, count, id});
        }
        id += 1;
    }

    part_one(mappings);
    part_two(mappings);

}


part_one :: proc(mappings: [dynamic]Mapping)
{
    valid_colors := make([dynamic][]string);
    append(&valid_colors, strings.split("shiny gold", " "));
    added_colors := make(map[int]bool);

    for i := 0; i < len(valid_colors); i += 1
    {
        for mapping in mappings
        {
            if mapping.id in added_colors
            {
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
                append(&valid_colors, mapping.container);
                added_colors[mapping.id] = true;
            }
        }
    }

    fmt.println(len(valid_colors) - 1);
}


part_two :: proc(mappings: [dynamic]Mapping)
{
    Entry :: struct
    {
        color: []string
        count: int
    };

    bag_count := 0;
    bags := make([dynamic]Entry);
    
    append(&bags, Entry{strings.split("shiny gold", " "), 1});

    for i := 0; i < len(bags); i += 1
    {
        for mapping in mappings
        {
            equal := true;
            for str,j in mapping.container
            {
                if str != bags[i].color[j]
                {
                    equal = false;
                    break;
                }
            }
            if equal
            {
                bag_count += mapping.count * bags[i].count;
                append(&bags, Entry{mapping.contents, mapping.count * bags[i].count});
            }
        }
    }
    fmt.println(bag_count);
}