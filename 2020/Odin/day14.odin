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
    addresses: [dynamic]int;

    address_bits := to_binary(address);
    floating_indices: [dynamic]int;
    bits: [dynamic]int;
    for c,i in mask 
    {
        switch c
        {
            case '0','1':
                append(&bits, int(address_bits[i] - '0') | int(c - '0'));
            case 'X':
                append(&bits, 0);
                append(&floating_indices, i);
        }
    }

    append(&addresses, bits_to_int(bits));
    last_float_ind := floating_indices[len(floating_indices)-1];
    combinations := 1 << uint(len(floating_indices));
    
    for nums := 0; nums < combinations; nums += 1
    {
        for digit : uint = 0; digit < uint(len(floating_indices)); digit += 1
        {
            bits[floating_indices[digit]] = 1 if nums & (1<<digit) > 0 else 0;
        }
        append(&addresses, bits_to_int(bits));
    }

    return addresses;
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

bits_to_int :: proc(bits: [dynamic]int) -> int
{
    value := 0;
    digit := 1;
    for i := len(bits)-1; i >= 0; i -= 1
    {
        value += digit * bits[i];
        digit *= 2;
    }
    return value;
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