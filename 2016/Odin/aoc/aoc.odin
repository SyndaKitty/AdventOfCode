package aoc


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


int_cos := [4]int{1,0,-1,0};
int_sin := [4]int{0,1,0,-1};