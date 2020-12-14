package main

import "core:fmt"
import "core:strings"
import "core:strconv"

// Custom libraries
import "../../libs/Odin/aoc"



main :: proc() 
{
    input := string(#load("../inputs/14.txt"));
    lines := strings.split(input, "\r\n");

    // fmt.println(apply_mask(11, "00000000000000000000000000000000X1XX"));

    mask: string;
    mem: map[int]int;
    for line in lines
    {
        parts := strings.split(line, " = ");
        value := parts[1];
        switch parts[0][0:3]
        {
            case "mas":
                mask = value;
            case "mem":
                mem_addr,_ := strings.replace_all(parts[0], "mem[", "");
                mem_addr,_ = strings.replace_all(mem_addr, "]", "");
                addr,_ := strconv.parse_int(mem_addr);
                mem_value,_ := strconv.parse_int(value);
                mem[addr] = apply_mask(mem_value, mask);
        }
    }

    sum := 0;
    for key,value in mem
    {
        sum += value;
    }
    fmt.println(sum);
}


apply_mask :: proc(value: int, mask: string) -> int
{
    binary_value := to_binary(value);
    result := 0;
    digit := 1;
    for i := len(mask) - 1; i >= 0; i -= 1 
    {
        switch mask[i]
        {
            case 'X':
                result += int(binary_value[i] - '0') * digit;
            case '1':
                result += 1 * digit;
            case '0':
                // noop
        }
        digit *= 2;
    }

    return result;
}


to_binary :: proc(num: int) -> string
{
    bit_mask : int = 1 << 35;
    i : uint = 35;
    builder := strings.make_builder();

    for
    {
        digit := (num & bit_mask) >> i;
        strings.write_int(&builder, digit);
        bit_mask = bit_mask >> 1;
        if i == 0 
        {
            return strings.to_string(builder);
        }
        i = i - 1;
    }
}