package permute;


Permutation :: struct
{
    indices: []int,
    i: int,
    first: bool
}


make_permutation :: proc(elements: int, allocator := context.allocator) -> Permutation
{
    permutation : Permutation;
    permutation.indices = make([]int, elements, allocator);
    permutation.first = true;
    for i := 0; i < elements; i += 1
    {
        permutation.indices[i] = 0;
    }
    return permutation;
}


swap :: inline proc(a, b: $T) -> (T, T)
{
    return b, a;
}


// Permutation via Heap's algorithm
permute_next :: proc(permutation: ^Permutation, array: ^$T/[$a]$E) -> bool
{
    using permutation;

    assert(len(indices) == a);
    
    if first
    {
        first = false;
        return true;
    }

    for i < a
    {
        if indices[i] < i
        {
            if i % 2 == 0
            {
                array[0], array[i] = swap(array[0], array[i]);
            }
            else
            {
                array[indices[i]], array[i] = swap(array[indices[i]], array[i]);
            }
            indices[i] += 1;
            i = 0;
            return true;
        }
        else
        {
            indices[i] = 0;
            i += 1;
        }
    }
    return false;
}