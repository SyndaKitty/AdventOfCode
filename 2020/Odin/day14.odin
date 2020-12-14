package main

import "core:fmt"
import "core:strings"
import "core:strconv"


main :: proc() 
{
    input := string(#load("../inputs/14.txt"));
    lines := strings.split(input, "\r\n");

    part_one(lines);
    part_two(lines);
}


part_one :: proc(lines: []string)
{
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
    result := 0;
    digit_value := 1;
    digit_place: uint = 0;
    for i := len(mask) - 1; i >= 0; i -= 1 
    {   
        switch mask[i]
        {
            case 'X':
                result += ((value >> digit_place) & 1) * digit_value;
            case '1':
                result += 1 * digit_value;
            case '0':
                // noop
        }
        digit_value *= 2;
        digit_place += 1;
    }

    return result;
}


part_two :: proc(lines: []string)
{
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
                addr_val,_ := strconv.parse_int(mem_addr);
                mem_value,_ := strconv.parse_int(value);
                for addr in decode(addr_val, mask)
                {
                    mem[addr] = mem_value;
                }
        }
    }

    sum := 0;
    for key,value in mem
    {
        sum += value;
    }
    fmt.println(sum);
}


decode :: proc(address: int, mask: string) -> [dynamic]int
{
    length := uint(len(mask));
    addresses: [dynamic]int;
    floating_indices: [dynamic]uint;
    
    base_address := 0;
    digit_value := 1;
    for i: uint = 0; i < uint(len(mask)); i += 1
    {
        mask_bit := mask[length - i - 1];
        address_bit := (address >> i) & 1;
        switch mask_bit
        {
            case '0','1':
                base_address += (address_bit | int(mask_bit - '0')) * digit_value;
            case 'X':
                append(&floating_indices, i);
        }
        digit_value *= 2;
    }

    floats := uint(len(floating_indices));
    combinations := 1 << floats;

    for nums := 0; nums < combinations; nums += 1
    {
        new_address := base_address;
        for i: uint = 0; i < floats; i += 1
        {
            float_bit := (nums >> i) & 1;
            new_address += (1<<floating_indices[i]) * float_bit;
        }
        append(&addresses, new_address);
    }

    return addresses;
}