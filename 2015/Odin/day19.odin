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


Replacement :: struct 
{
    from: string,
    to: string
}

fabricate :: proc(replacements: [dynamic]Replacement, 
                original: string, new: string, memoize: ^map[string]int) -> int
{
    using strings;

    steps := 9999;
    
    if new in memoize^ do return memoize[new];

    //fmt.println("Calling fabricate with", new);
    if new == original
    {
        fmt.println("One solution found");
        return 0;
    }
    //if len(new) > len(original) do return steps;

    // Find all possible replacements
    for c,i in new
    {
        for replacement in replacements 
        {
            w := len(replacement.to);
            if i > len(new)-w do continue;
            if replacement.to == new[i:i+w]
            {
                // fmt.println(new, "matches replacement", replacement);
                builder := make_builder();
                // fmt.print("Changed to ");
                // fmt.print(new[:i]); fmt.print(replacement.from); fmt.print(new[i+w:]);
                // fmt.println("");
                write_string(&builder, new[:i]);
                write_string(&builder, replacement.from);
                write_string(&builder, new[i+w:]);
                steps = min(steps, fabricate(replacements, original, to_string(builder), memoize) + 1);
            }
        }
    }
    memoize^[new] = steps;
    return steps;
}

main :: proc()
{
    input := string(#load("../inputs/19.txt"));

    pt2 :: true;
    using parse;

    parse_info := make_parse_info(input);
    parse_info.search = {TokenType.Word};

    original_molecule: string;
    replacements := make([dynamic]Replacement);
    
    for
    {
        token,_ := parse_next(&parse_info);
        if len(token.data) > 2 
        {
            original_molecule = token.data;
            break;
        }
        from := token.data;
        token,_ = parse_next(&parse_info);
        token,_ = parse_next(&parse_info);
        to := token.data;

        append(&replacements, Replacement{from=from, to=to});
    }

    if pt2
    {
        // lookup := make(map[string]Replacement);
        // for replacement in replacements
        // {
        //     lookup[replacement.from] = replacement;
        // }
        memoize := make(map[string]int);
        fmt.println(fabricate(replacements, "e", original_molecule, &memoize), "steps");
        return;
    }

    molecules := make(map[string]int);
    molecule_count := 0;
    for replacement in replacements
    {
        width := len(replacement.from);
        for i in 0..len(original_molecule)-width
        {
            section := original_molecule[i:i+width];
            if section == replacement.from
            {
                builder := strings.make_builder();
                strings.write_string(&builder, original_molecule[:i]);
                strings.write_string(&builder, replacement.to);
                strings.write_string(&builder, original_molecule[i+width:]);
                new_molecule := strings.to_string(builder);
                if !(new_molecule in molecules)
                {
                    molecule_count += 1;
                    molecules[new_molecule] = 1;
                }
            }
        }
    }

    fmt.println("Distinct molecules:", molecule_count);
}