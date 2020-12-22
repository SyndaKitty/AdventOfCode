package aoc

import "core:strconv"
import "core:slice"
import "core:strings"
import "core:fmt"


sort_two :: proc(a: int, b: int) -> (int, int)
{
    return min(a,b), max(a,b);
}


sort_string :: proc(word: string) -> string {
    runes: [dynamic]rune;
    defer delete(runes);
    for c in word {
        append(&runes, c);
    }
    slice.sort(runes[:]);
    builder := strings.make_builder();
    for r in runes {
        strings.write_rune_builder(&builder, r);
    }
    return strings.to_string(builder);
}


sort :: proc
{
    sort_two,
    sort_string
};


hash_2D_ints :: proc(x: int, y: int) -> i64
{
    mask_32 :: 1 << 32 - 1;

    x_32 := i64(x & mask_32);
    y_32 := i64(y & mask_32);

    hash : i64 = y_32 << 32 + x_32;

    return hash;
}


hash_2D_vector :: proc(val: Vector2) -> i64
{
    return inline hash_2D_ints(val[0], val[1]);
}


hash_2D :: proc {hash_2D_ints, hash_2D_vector};
h2D :: hash_2D;


xor :: inline proc(a: bool, b: bool) -> bool
{
    return (a && !b) || (b && !a);
}


reverse :: proc(data: [dynamic]$T) {
    for i, j := 0, len(data)-1; i < j; i, j = i+1, j-1 {
        data[i], data[j] = data[j], data[i];
    }
}


flip_rows :: proc(data: [dynamic][dynamic]$T) {
    reverse(data);
}


flip_columns :: proc(data: [dynamic][dynamic]$T) {
    for i in 0..<len(data) {
        reverse(data[i]);
    }
}

flip_cols :: proc {flip_columns};


flip_diagonal :: proc(data: [dynamic][dynamic]$T) {
    LL := len(data) - 1;
    for y in 1..LL {
        for x in 0..<y {
            data[y][x],data[x][y] = data[x][y],data[y][x];
        }
    }
}

rotate_cw :: proc(data: [dynamic][dynamic]$T) {
    flip_diagonal(data);
    flip_cols(data);
}

rotate_ccw :: proc(data: [dynamic][dynamic]$T) {
    flip_diagonal(data);
    flip_rows(data);
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


min_V2 :: proc(a,b: V2) -> V2 {
    res: V2;
    res[0] = min(a[0], b[0]);
    res[1] = min(a[1], b[1]);
    return res;
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


max_V2 :: proc(a,b: V2) -> V2 {
    res: V2;
    res[0] = max(a[0], b[0]);
    res[1] = max(a[1], b[1]);
    return res;
}

min :: proc { min_2, max_3, min_list, min_V2 };
max :: proc { max_2, max_3, min_list, max_V2 };


Vector2 :: [2]int;
V2 :: Vector2;
Vector3 :: [3]int;
V3 :: Vector3;

int_cos := [?]int{1,0,-1,0};
int_sin := [?]int{0,1,0,-1};
cos_sin :: [?]Vector2 {{1,0}, {0,1}, {-1,0}, {0, -1}};

neighbors_x :: [?]int {1, 1, 0, -1, -1, -1, 0, 1 };
neighbors_y :: [?]int {0, 1, 1, 1, 0, -1, -1, -1 };
neighbors :: [?]Vector2 {{1,0}, {1,1}, {0,1}, {-1,1}, {-1,0}, {-1,-1}, {0,-1}, {1,-1}};

// Functions to remove the ",ok" idiom to make things quicker to work with 
replace :: proc(input: string, old: string, new: string) -> string
{
    out,_ := strings.replace_all(input, old, new);
    return out;
}

parse_int :: proc(input: string) -> int
{
    out,_ := strconv.parse_int(input);
    return out;
}

print_2D :: proc(data: [dynamic][dynamic]$T) {
    print_2D_separator(data, "");
}

print_2D_separator :: proc(data: [dynamic][dynamic]$T, sep: string) {
    for i in 0..<len(data) {
        for j in 0..<len(data[i]) {
            fmt.print(data[i][j]);
            if i < len(data) - 1 {
                fmt.print(sep);
            }
        }
        fmt.println();
    }   
}

print_list :: proc(data: [dynamic]$T) {
    print_separator(data, "");
}

print_separator :: proc(data: [dynamic]$T, sep:string) {
    for i in 0..<len(data) {
        fmt.print(data[i]);
        if i < len(data) - 1 {
            fmt.print(sep);
        }
    }
    fmt.println();
}

print :: proc {print_2D, print_2D_separator, print_list, print_separator};

x :: proc(a: V2) -> int {
    return a[0];
}

y :: proc(a: V2) -> int {
    return a[1];
}

int_angle :: proc(a: V2) -> int {
    x := a[0];
    if x != 0 do x /= abs(x);
    y := a[1];
    if y != 0 do y /= abs(y);

    assert(x != y && x != -y, "Invalid call to theta");
    if x == 1 do return 0;
    if y == 1 do return 1;
    if x == -1 do return 2;
    if y == -1 do return 3;
    panic("Invalid call to theta");

}


search :: proc(data: []$T, element: T) -> bool {
    for d in data {
        if d == element do return true;
    }
    return false;
}