package aoc

import "core:strconv"


sort_two :: proc(a: int, b: int) -> (int, int)
{
    return min(a,b), max(a,b);
}


sort :: proc
{
    sort_two
};


hash_2D :: proc(x: int, y: int) -> i64
{
    mask_32 :: 1 << 32 - 1;

    x_32 := i64(x & mask_32);
    y_32 := i64(y & mask_32);

    hash : i64 = y_32 << 32 + x_32;

    return hash;
}


xor :: inline proc(a: bool, b: bool) -> bool
{
    return (a && !b) || (b && !a);
}


iter_keys :: proc(data: map[$K]$V) -> []K
{
    length := len(data);
    result := make([dynamic]K, length);
    i := 0;
    for key in data
    {
        result[i] = key;
        i += 1;
    }
    return result[:];
}


clear_map :: proc(data: ^map[$K]$V)
{
    for key in iter_keys(data^)
    {
        delete_key(data, key);
    }
}


sum :: proc(numbers: []int) -> int
{
    total := 0;
    for i := 0; i < len(numbers); i += 1
    {
        total += numbers[i];
    }
    return total;
}


min_list :: proc(numbers: []int) -> int
{
    smallest := numbers[0];
    for i := 1; i < len(numbers); i += 1
    {
        if numbers[i] < smallest
        {
            smallest = numbers[i];
        }
    }
    return smallest;
}


min_2 :: proc(a: int, b: int) -> int
{
    if a < b do return a;
    return b;
}


min_3 :: proc(a: int, b: int, c: int) -> int
{
    min := a;
    if b < min do min = b;
    if c < min do min = c;
    return min;
}

max_list :: proc(numbers: []int) -> int
{
    largest := numbers[0];
    for i := 1; i < len(numbers); i += 1
    {
        if numbers[i] > largest
        {
            largest = numbers[i];
        }
    }
    return largest;
}


max_2 :: proc(a: int, b: int) -> int
{
    if a > b do return a;
    return b;
}


max_3 :: proc(a: int, b: int, c: int) -> int
{
    min := a;
    if b > min do min = b;
    if c > min do min = c;
    return min;
}


min :: proc { min_2, max_3, min_list };
max :: proc { max_2, max_3, min_list };


int_cos := [4]int{1,0,-1,0};
int_sin := [4]int{0,1,0,-1};