package main
import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:slice"

main :: proc() {
    using strings;
    file := string(#load("../inputs/03.txt"));
    
    lines := strings.split(file, "\n");
    
    gamma := strings.make_builder();
    epsilon := strings.make_builder();

    // Part 1
    digits :: 12;
    for d := 0; d < digits; d += 1 {
        zero := 0;
        one := 0;

        for line in lines {
            if line[d] == '0' {
                zero += 1;
            }
            else {
                one += 1;
            }
        }

        if zero > one {
            write_rune_builder(&gamma, rune('0'));
            write_rune_builder(&epsilon, rune('1'));
        }
        else {
            write_rune_builder(&gamma, rune('1'));
            write_rune_builder(&epsilon, rune('0'));
        }
    }

    gamma_val, _ := strconv.parse_int(to_string(gamma), 2)
    epsilon_val, _ := strconv.parse_int(to_string(epsilon), 2)

    fmt.println(gamma_val * epsilon_val);

    // Part 2
    slice.sort(lines);

    valid_lines := lines[:];
    for d := 0; d < digits; d += 1 {
        zero := 0;
        one := 0;
        boundary := -1;
        for line,i in valid_lines {
            if line[d] == '0' {
                zero += 1;
            }
            else {
                if boundary == -1 {
                    boundary = i;
                }
                one += 1;
            }
        }
        if zero > one {
            valid_lines = valid_lines[:boundary];
        }
        else {
            valid_lines = valid_lines[boundary:];
        }
        if len(valid_lines) == 1 do break;
    }
    o2,_ := strconv.parse_int(valid_lines[0], 2);

    valid_lines = lines[:];
    for d := 0; d < digits; d += 1 {
        zero := 0;
        one := 0;
        boundary := -1;
        for line,i in valid_lines {
            if line[d] == '0' {
                zero += 1;
            }
            else {
                if boundary == -1 {
                    boundary = i;
                }
                one += 1;
            }
        }
        
        if zero > one {
            valid_lines = valid_lines[boundary:];
        }
        else {
            valid_lines = valid_lines[:boundary];
        }
        if len(valid_lines) == 1 do break;
    }
    co2,_ := strconv.parse_int(valid_lines[0], 2);

    fmt.println(o2 * co2);

}