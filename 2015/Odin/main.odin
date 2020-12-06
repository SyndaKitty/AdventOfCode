package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:container"
import "core:time"
import "core:sys/windows"


// Custom libraries
import "permute"
//import "combine"
import "parse"


// Common functions -----------------------------------------------//
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


print_binary :: proc(num: int)
{
    bit_mask : int = 1 << 62;
    i : uint = 62;
    for
    {
        digit := (num & bit_mask) >> i;
        fmt.print(digit);
        bit_mask = bit_mask >> 1;
        if i == 0 
        {
            fmt.println();
            return;
        }
        i = i - 1;
    }
}


is_digit :: proc(char: rune) -> bool
{
    return (char >= '0' && char <= '9') || char == '-';
}


is_num :: proc(char: rune) -> bool
{
    return is_digit(char) || char == '-' || char == '.';
}


// Puzzles --------------------------------------------------------//
day_one :: proc(input: string) 
{
    pt2 :: true;
    position := 1;
    reached_basement := false;

    floor : int;
    for c in input 
    {
        if c == '(' do floor = floor + 1;
        else
        if c == ')' do floor = floor - 1;
        else
        do fmt.println("Invalid character:", c);

        if pt2 && !reached_basement
        {
            if floor < 0 
            {
                fmt.println("Reached basement at position:", position);
                reached_basement = true;
            }
            position = position + 1;
        }
    }

    fmt.println("Final floor: ", floor);
}


day_two :: proc(input: string) 
{
    pt2 :: true;
    
    // Array of l,w,h, l,w,h, ...
    box_sizes := make([dynamic]int);
    defer delete(box_sizes);

    // Parse individual numbers via slicing
    num_start_index := 0;
    char_index := 0;
    
    for c in input 
    {
        switch c 
        {
            case 'x':
                fallthrough;
            case '\n':
                size := strconv.atoi(input[num_start_index : char_index]);
                append(&box_sizes, size);
                num_start_index = char_index + 1;
        }
        char_index = char_index + 1;
    }

    // Calculate surface areas + slack
    wrapping_paper := 0;
    ribbon := 0;

    for box_index := 0; box_index < len(box_sizes); box_index = box_index + 3
    {
        l := box_sizes[box_index];
        w := box_sizes[box_index + 1];
        h := box_sizes[box_index + 2];

        l_w := l * w;
        w_h := w * h;
        l_h := l * h;

        surface := 2 * (l_w + w_h + l_h);
        slack := min(l_w, w_h, l_h);

        wrapping_paper += surface + slack;

        if pt2
        {
            perimeter_l_w := 2 * (l + w);
            perimeter_w_h := 2 * (w + h);
            perimeter_l_h := 2 * (l + h);

            ribbon = ribbon + min(perimeter_l_w, perimeter_w_h, perimeter_l_h) + l * w * h;
        }
    }

    fmt.println("Total wrapping paper required:", wrapping_paper, "sq ft.");
    if pt2 do fmt.println("Total ribbon needed:", ribbon, "ft.");
}


day_three :: proc(input: string)
{
    pt2 :: true;

    // Record coordinates as we go
    m := make(map[i64]int);

    if !pt2
    {
        x := 0;
        y := 0;
        houses := 1;

        // Record visiting 0
        m[hash_2D(x, y)] = 1;

        for c in input 
        {
            switch c 
            {
                case '^':
                    y = y + 1;
                case 'v':
                    y = y - 1;
                case '>':
                    x = x + 1;
                case '<':
                    x = x - 1;
            }

            hash := hash_2D(x, y);

            exists := hash in m;
            if !exists 
            {
                m[hash] = 1;
                houses = houses + 1;
            }
            else
            {
                m[hash] = m[hash] + 1;
            }
        }

        fmt.println("Unique houses visited:", houses);    
    }
    else
    {
        x_santa := 0;
        y_santa := 0;
        x_robo  := 0;
        y_robo  := 0;
        santa   := true;
        houses := 1;

        // Record visiting 0
        m[hash_2D(0, 0)] = 2;

        for c in input 
        {
            switch c 
            {
                case '^':
                    if santa do y_santa = y_santa + 1;
                    else do y_robo = y_robo + 1;
                case 'v':
                    if santa do y_santa = y_santa - 1;
                    else do y_robo = y_robo - 1;
                case '>':
                    if santa do x_santa = x_santa + 1;
                    else do x_robo = x_robo + 1;
                case '<':
                    if santa do x_santa = x_santa - 1;
                    else do x_robo = x_robo - 1;
            }
            

            hash : i64;
            if santa do hash = hash_2D(x_santa, y_santa);
            else do hash = hash_2D(x_robo, y_robo);

            exists := hash in m;
            if !exists 
            {
                m[hash] = 1;
                houses = houses + 1;
            }
            else
            {
                m[hash] = m[hash] + 1;
            }

            santa = !santa;
        }

        fmt.println("Unique houses visited:", houses); 
    }
}


is_vowel :: proc(c: rune) -> bool
{
    if c == 'a' do return true;
    if c == 'e' do return true;
    if c == 'i' do return true;
    if c == 'o' do return true;
    if c == 'u' do return true;
    return false;
}


is_naughty_string :: proc(prev_c: rune, c: rune) -> bool
{
    // ab, cd, pq, or xy
    if prev_c == 'a' && c == 'b' do return true;
    if prev_c == 'c' && c == 'd' do return true;
    if prev_c == 'p' && c == 'q' do return true;
    if prev_c == 'x' && c == 'y' do return true;
    return false;
}


has_double_pair :: proc(data: []i64) -> bool
{
    for i:=0; i < len(data); i=i+1
    {
        if data[i] == 0 do continue;
        for j:=i+1; j < len(data); j=j+1
        {
            if data[j] == 0 do continue;

            // If the pair are the same hash
            same_hash := data[i] == data[j];
            overlapping := j - i == 1;

            if same_hash && !overlapping do return true;
        }
    }
    return false;
}


day_five :: proc(input: string)
{
    pt2 :: true;

    nice_word_count := 0;

    if !pt2
    {
        prev_c := ' ';
        duplicate := false;
        vowel_count := 0;
        invalid := false;

        for c in input 
        {
            switch c
            {
                case '\n':
                    // Check conditions
                    if !invalid && vowel_count >= 3 && duplicate 
                    {
                        nice_word_count = nice_word_count + 1;
                    }

                    prev_c = ' ';
                    duplicate = false;
                    vowel_count = 0;
                    invalid = false;
                case:
                    if is_vowel(c) do vowel_count = vowel_count + 1;
                    if prev_c == c do duplicate = true;
                    if is_naughty_string(prev_c, c) do invalid = true;
                    prev_c = c;
            }
        }    
    }
    else
    {
        pairs := make([]i64, 15);
        defer delete(pairs);

        prev_prev_c := ' ';
        prev_c := ' ';
        stagger := false;
        char_pos := 0;

        for c in input
        {
            switch c 
            {
                case '\r':
                    ;
                case '\n':
                    // Check conditions
                    dd := has_double_pair(pairs);
                    // fmt.println("Stagger:", stagger, "DD:", dd);
                    if stagger && dd 
                    {
                        nice_word_count = nice_word_count + 1;
                    }

                    prev_prev_c = ' ';
                    prev_c = ' ';
                    stagger = false;
                    char_pos = 0;
                case:
                    // fmt.print(prev_prev_c, prev_c, c);
                    if prev_prev_c == c do stagger = true;
                    // fmt.print(" Stagger:", stagger);
                    if char_pos >= 1 
                    {
                        pairs[char_pos - 1] = hash_2D(int(prev_c), int(c));
                    }
                    
                    // fmt.print(" pair: ");
                    // for i:=0; i<len(pairs);i=i+1
                    // {
                    //     fmt.print(pairs[i], "|");
                    // }

                    prev_prev_c = prev_c;
                    prev_c = c;
                    char_pos = char_pos + 1;
                    // fmt.println();
            }
        }
    }

    fmt.println("Number of nice words:", nice_word_count);
}


CommandType :: enum 
{
    turn_on,
    turn_off,
    toggle
}


Command :: struct
{
    type : CommandType,
    lower_x : int,
    lower_y : int,
    upper_x : int,
    upper_y : int
}


parse_commands :: proc(input: string) -> [dynamic]Command
{
    start_index := 0;
    current_index := 0;

    commands := make([dynamic]Command);

    comma_index := 0;

    // State 0 : command
    // State 1 : first coordinate pair
    // State 2 : through
    // State 3 : second coordinate pair
    state := 0;

    command : Command;

    debug :: false;

    for c in input
    {
        if debug do fmt.print("Character:", c, "State:", state);

        if debug 
        {
            fmt.print("\"");
            fmt.print(input[start_index:current_index]);
            fmt.print("\"");
        }

        if input[current_index] == '\n'
        {
            state = 0;
            start_index = current_index + 1;
        }
        else if state == 0
        {
            if input[start_index : current_index] == "turn on "
            {
                command.type = CommandType.turn_on;
                state = state + 1;
                start_index = current_index;
            }
            else if input[start_index : current_index] == "turn off "
            {
                command.type = CommandType.turn_off;
                state = state + 1;
                start_index = current_index;
            }
            else if input[start_index : current_index] == "toggle "
            {
                command.type = CommandType.toggle;
                state = state + 1;
                start_index = current_index;
            }
            if debug do fmt.print(" CommandType:", command.type);
        }
        else if state == 1 || state == 3
        {
            // Check for comma
            letter := input[current_index];
            if letter == ',' do comma_index = current_index;
            if letter == ' ' || letter == '\r'
            {
                // Parse x
                x,_ := strconv.parse_int(input[start_index:comma_index]);

                // Parse y
                y,_ := strconv.parse_int(input[comma_index+1: current_index]);

                if state == 1
                {
                    command.lower_x = x;
                    command.lower_y = y;
                    state = state + 1;
                }
                else if state == 3
                {
                    command.upper_x = x;
                    command.upper_y = y;

                    if debug do fmt.println();
                    if debug do fmt.println(command.lower_x, command.lower_y, command.upper_x, command.upper_y, command.type);

                    append(&commands, command);
                    state = 0;
                }

                start_index = current_index + 1;
            }
        }
        else if state == 2
        {
            if input[current_index] == ' '
            {
                state = state + 1;
                start_index = current_index + 1;
            }
        }
    
        current_index = current_index + 1;
        if debug do fmt.println();
    }

    return commands;
}


to_index :: proc(x: int, y: int) -> int
{
    return y * 1000 + x;
}


day_six :: proc(input: string)
{
    commands:= parse_commands(input);
    defer delete(commands);

    pt2 :: true;

    if !pt2
    {
        lights := make([]bool, 1_000_000);
        defer delete(lights);

        // Execute all commands
        for i := 0; i < len(commands); i=i+1
        {
            command := commands[i];
            for y := command.lower_y; y <= command.upper_y; y=y+1
            {
                for x := command.lower_x; x <= command.upper_x; x=x+1 
                {
                    index := to_index(x, y);
                    if command.type == CommandType.turn_on
                    {
                        lights[index] = true;
                    }
                    else if command.type == CommandType.turn_off
                    {
                        lights[index] = false;
                    }
                    else if command.type == CommandType.toggle
                    {
                        lights[index] = !lights[index];
                    }
                }    
            }
        }

        number_of_lights_on := 0;
        for i := 0; i < len(lights); i=i+1
        {
            if lights[i] do number_of_lights_on = number_of_lights_on + 1;
        }

        fmt.println("Total number of lights on:", number_of_lights_on);    
    }
    
    {
        lights := make([]int, 1_000_000);
        defer delete(lights);

        // Execute all commands
        for i := 0; i < len(commands); i=i+1
        {
            command := commands[i];
            for y := command.lower_y; y <= command.upper_y; y=y+1
            {
                for x := command.lower_x; x <= command.upper_x; x=x+1 
                {
                    index := to_index(x, y);
                    current := lights[index];
                    if command.type == CommandType.turn_on 
                    {
                        lights[index] = current + 1;
                    }
                    else if command.type == CommandType.turn_off
                    {
                        lights[index] = max(current - 1, 0);
                    }
                    else if command.type == CommandType.toggle
                    {
                        lights[index] = current + 2;
                    }
                }
            }
        }

        total_brightness := 0;
        for i := 0; i < len(lights); i=i+1
        {
            total_brightness = total_brightness + lights[i];
        }

        fmt.println("Total brightness:", total_brightness);
    }
}


TokenType :: enum
{
    VALUE,
    IDENTIFIER,
    AND,
    OR,
    RSHIFT,
    LSHIFT,
    NOT,
    ARROW,
    NEWLINE
}


Token :: struct
{
    type: TokenType,
    value: string
}


OperationType :: enum
{
    AND,
    OR,
    RSHIFT,
    LSHIFT,
    NOT,
    ASSIGN
}


Operation :: struct
{
    operand_1: ^Token,
    operand_2: ^Token,
    type: OperationType,
    result: ^Token
}


day_seven_parse :: proc(tokens: ^[dynamic]Token, operations: ^[dynamic]Operation)
{
    next_token :: proc(tokens: ^[dynamic]Token, i: ^int) -> (bool, ^Token)
    {
        i^ = i^ + 1;
        valid := len(tokens) > i^;
        token := &tokens^[i^ - 1] if valid else nil;
        return valid, token;
    }

    i := 0;
    token_set : [6]^Token;
    next := true;

    MAX_TOKENS :: 6;

    for next
    {
        // Form operation
        op: Operation;

        fmt.println();
        for j:=0; j < MAX_TOKENS && next; j = j + 1
        {
            next, token_set[j] = next_token(tokens, &i);
            fmt.println(token_set[j]);
            if !next || token_set[j].type == .NEWLINE
            {
                break;
            }
        }

        op.operand_1 = token_set[0];
        op.operand_2 = token_set[2];
        op.result = token_set[4];

        #partial switch token_set[1].type
        {
            case TokenType.AND:
                op.type = OperationType.AND;
            case TokenType.OR:
                op.type = OperationType.OR;
            case TokenType.LSHIFT:
                op.type = OperationType.LSHIFT;
            case TokenType.RSHIFT:
                op.type = OperationType.RSHIFT; 
            case TokenType.ARROW: 
                op.operand_1 = token_set[0];
                op.operand_2 = nil;
                op.result = token_set[2];
                op.type = OperationType.ASSIGN;
            case:
                if token_set[0].type == TokenType.NOT && token_set[1].type == TokenType.IDENTIFIER
                {
                    op.operand_1 = token_set[1];
                    op.operand_2 = nil;
                    op.result = token_set[3];
                    op.type = OperationType.NOT;
                }
                else 
                {
                    fmt.println("Aaaaaaah, unknown operation");
                }  
        }

        fmt.println(op);
        append(operations, op);
    }
}


create_token :: proc(value: string) -> Token
{
    using TokenType;

    token : Token;
    token.value = value;

    switch value 
    {
        case "NOT":
            token.type = NOT;
        case "AND":
            token.type = AND;
        case "OR":
            token.type = OR;
        case "RSHIFT":
            token.type = RSHIFT;
        case "LSHIFT":
            token.type = LSHIFT;
        case "->":
            token.type = ARROW;
        case "\n":
            token.type = NEWLINE;
        case: 
            switch value[0]
            {
                case 'a'..'z':
                    token.type = IDENTIFIER;
                case '0'..'9':
                    token.type = VALUE;
                case:
                    fmt.println("Uh oh");
            }
    }
    //fmt.println(token.value, token.type);
    return token;
}


day_seven :: proc(input: string)
{

    pt2 :: true;

    tokens := make([dynamic]Token);
    operations := make([dynamic]Operation);
    operation_lookup := make(map[string]Operation);

    fmt.println("Tokenizing");
    left := 0;
    right := 0;
    for c in input
    {
        switch c
        {
            case ' ': fallthrough;
            case '\r':
                append(&tokens, create_token(input[left:right]));
                left = right + 1;
            
            case '\n': 
                append(&tokens, create_token("\n"));
                left = right + 1;       
        }

        right = right + 1;
    }

    fmt.println("Parsing");
    day_seven_parse(&tokens, &operations);

    
    fmt.println("Simulating");
    using OperationType;
    values := make(map[string]int);

    for operation in operations 
    {
        operation_lookup[operation.result^.value] = operation;
    }

    if pt2
    {
        operation_lookup["b"].operand_1.value = "956";
    }

    fmt.println(get_value("a", &operations, &operation_lookup, &values));
}


get_value :: proc(key: string, operations: ^[dynamic]Operation, operation_lookup: ^map[string]Operation, values: ^map[string]int) -> int
{
    operation := operation_lookup[key];
    //fmt.println("Operation that results in", key, ":", operation);

    result := operation.result.value;

    operand_1 : int;
    operand_2 : int;

    if operation.operand_1 != nil
    {
        if operation.operand_1.type == TokenType.VALUE
        {
            operand_1,_ = strconv.parse_int(operation.operand_1.value);
        }
        else if operation.operand_1.value in values^
        {
            operand_1 = values[operation.operand_1.value];
        }
        else
        {
            operand_1 = get_value(operation.operand_1.value, operations, operation_lookup, values);
        }
        values[operation.operand_1.value] = operand_1;
    }
    if operation.operand_2 != nil
    {
        if operation.operand_2.type == TokenType.VALUE
        {
            operand_2,_ = strconv.parse_int(operation.operand_2.value);
        }
        else if operation.operand_2.value in values^
        {
            operand_2 = values[operation.operand_2.value];
        }
        else
        {
            operand_2 = get_value(operation.operand_2.value, operations, operation_lookup, values);
        }
        values[operation.operand_2.value] = operand_2;
    }

    if operation.type == OperationType.ASSIGN
    {
        fmt.println("Assigning", operand_1, "to", result);
        return operand_1;
    }
    else if operation.type == OperationType.AND
    {
        fmt.println("Assigning", operand_1, "AND", operand_2, operand_1 & operand_2, "to", result);
        return operand_1 & operand_2;
    }
    else if operation.type == OperationType.OR
    {
        fmt.println("Assigning", operand_1, "OR", operand_2, ":", operand_1 | operand_2, "to", result);
        return operand_1 | operand_2;
    }
    else if operation.type == OperationType.NOT
    {
        fmt.println("Assigning NOT", operand_1, ":", 65535 - operand_1, "to", result);
        return 65535 - operand_1;
    }
    else if operation.type == OperationType.LSHIFT 
    {
        fmt.println("Assigning", operand_1, "LSHIFT", operand_2, ":", operand_1 << u32(operand_2), "to", result);
        return operand_1 << u32(operand_2);
    }
    else
    {
        fmt.println("Assigning", operand_1, "RSHIFT", operand_2, ":", operand_1 >> u32(operand_2), "to", result);
        return operand_1 >> u32(operand_2);
    }
}


day_eight :: proc(input: string)
{
    
    pt2 :: true;

    if !pt2
    {
        code_characters := 0;
        string_characters := 0;
        escaping := false;

        for c in input
        {
            switch c
            {
                case '\r': fallthrough;
                case '\n': continue;
                case '\\':
                    if escaping
                    {
                        escaping = false;
                        string_characters = string_characters + 1;
                    }
                    else
                    {
                        escaping = true;
                    }
                case '"':
                    if escaping 
                    {
                        escaping = false;
                        string_characters = string_characters + 1;
                    }
                case 'x':
                    if escaping
                    {
                        escaping = false;
                        string_characters = string_characters - 1;
                    }
                    else
                    {
                        string_characters = string_characters + 1;
                    }
                case:
                    string_characters = string_characters + 1;

            }
            code_characters = code_characters + 1;
        }

        fmt.println("Code characters:", code_characters);
        fmt.println("String characters:", string_characters);
        fmt.println("Result:", code_characters - string_characters);
    }
    else
    {
        encoded_characters := 0;
        original_characters := 0;
        
        for c in input 
        {
            switch c
            {
                case '\r': 
                    continue;
                case '\n': 
                    // Two capturing quotes
                    encoded_characters = encoded_characters + 2;
                    continue;
                case '\\': fallthrough;
                case '\"':
                    encoded_characters = encoded_characters + 2;
                case:
                    encoded_characters = encoded_characters + 1;
            }
            original_characters = original_characters + 1;
        }

        fmt.println("Original characters:", original_characters);
        fmt.println("Encoded characters:", encoded_characters);
        fmt.println("Result:", encoded_characters - original_characters);
    }
}


LOCATIONS :: 8;


evaluate_distance :: proc(best: ^int, indices: ^[LOCATIONS]int, distances: ^map[i64]int, pt2: bool)
{
    location := indices[0];
    total_distance := 0;

    for i := 1; i < LOCATIONS; i = i + 1
    {
        next_location := indices[i];
        key := hash_2D(location, next_location);
        
        total_distance = total_distance + distances[key];
        location = next_location;
    }
    
    // eval := max if pt2 else min;
    // best^ = eval(best^, total_distance);
    best^ = max(best^, total_distance) if pt2 else min(best^, total_distance);
    
}


swap :: proc(x, y: int) -> (int, int)
{
    return y,x;
}


day_nine :: proc(input: string)
{
    pt2 :: true;

    distances := make(map[i64]int);
    
    left := 0;
    right := 0;
    from := 0;
    to := 1;
    for c in input
    {
        switch c
        {
            case ' ':
                right = right + 1;
                left = right;
            case '\r':
                distance,_ := strconv.parse_int(input[left:right]);
                
                // Bidirectional distance
                distances[hash_2D(from,to)] = distance;
                distances[hash_2D(to,from)] = distance;
                
                to = to + 1;
                if to >= LOCATIONS
                {
                    from = from + 1;
                    to = from + 1;
                }

                right = right + 1;
            case:
                right = right + 1;
        }
    }

    // Permutation via Heap's Algorithm
    n :: LOCATIONS;
    a : [n]int;
    for i := 0; i < n; i = i + 1 do a[i] = i;
    
    c : [n]int;
    for i := 0; i < n; i = i + 1 do c[i] = 0;

    i := 0;
    best := 0 if pt2 else 99999;

    evaluate_distance(&best, &a, &distances, pt2);

    for i < n
    {
        if c[i] < i
        {
            if i % 2 == 0
            {
                a[0], a[i] = swap(a[0], a[i]);
            }
            else
            {
                a[c[i]], a[i] = swap(a[c[i]], a[i]);
            }

            evaluate_distance(&best, &a, &distances, pt2);

            c[i] = c[i] + 1;
            i = 0;
        }
        else
        {
            c[i] = 0;
            i = i + 1;
        }
    }
    
    fmt.println("Best distance:", best);
}


look_and_say:: proc(input: string) -> string
{
    output := strings.make_builder();
    last: rune;
    count := 1;
    length := len(input);
    
    for i := 0; i < length; i = i + 1
    {
        c := input[i];
        next := input[i+1] if i+1 < length else ' ';

        if c == next
        {
            count = count + 1;
        }
        else
        {
            strings.write_int(&output, count);
            strings.write_rune(&output, rune(c));
            count = 1;
        }
    }

    return strings.to_string(output);
}

day_ten :: proc(input: string)
{
    pt2 :: true;

    result := input;
    iterations := 50 if pt2 else 40;

    for i := 0; i < iterations; i = i + 1 
    {
        result = look_and_say(result);
    }

    fmt.println(len(result));
}


valid_pass :: proc(word: ^strings.Builder) -> bool
{
    length := len(word.buf);
    
    three_letter_run := false;
    pairs := 0;

    for i := 0; i < length - 2; i = i + 1
    {
        if word.buf[i+0] + 1 == word.buf[i+1]
        && word.buf[i+1] + 1 == word.buf[i+2] 
        {
            three_letter_run = true;
        }

        if word.buf[i] == word.buf[i+1] 
        && word.buf[i] != word.buf[i+2]
        {
            pairs = pairs + 1;
        }
    }

    // Check for pair at end
    if word.buf[length-3] != word.buf[length-2] 
    && word.buf[length-2] == word.buf[length-1]
    {
        pairs = pairs + 1;
    }

    return three_letter_run && pairs >= 2;
}


increment_word :: proc(word: ^strings.Builder)
{
    end := len(word.buf) - 1;
    for i := 0; i < end; i = i + 1
    {
        next_val := word.buf[end - i] + 1;
        if next_val == byte('z' + 1)
        {
            word.buf[end - i] = 'a';
        }
        else if next_val == 'i' || next_val == 'o' || next_val == 'l'
        {
            // Skip blacklisted letters
            word.buf[end - i] = next_val + 1;
            break;
        }
        else
        {
            word.buf[end - i] = next_val;
            break;
        }
    }
}


day_eleven :: proc(input: string)
{
    pt2 :: true;

    password := strings.make_builder();
    strings.write_string(&password, input);

    for
    {
        increment_word(&password);
        if valid_pass(&password) do break;
    }
    if pt2 do for
    {
        increment_word(&password);
        if valid_pass(&password) do break;
    }

    fmt.println(strings.to_string(password));
}


Location :: enum
{
    object,
    array
}

day_twelve_pt2 :: proc(input: string)
{
    using container;

    start_cycle := time.read_cycle_counter();
    start_time := time.now();

    debug :: false;

    total := 0;
    total_stack : Array(int);
    array_init(&total_stack);

    array_push(&total_stack, 0);
    
    stack_index := 0;

    locations : Array(Location);
    array_init(&locations);
    current_location : Location;

    array_push(&locations, Location.array);

    lookback: [2]rune;
    lookback[0] = rune(input[0]);
    lookback[1] = rune(input[0]);

    ignore_index := 0;
    left := 0;
    right := 0;

    for c in input
    {
        right += 1;

        // Check for number end
        if !is_digit(c) && is_digit(lookback[0])
        {
            if debug do fmt.println("Number detected:", input[left:right-1]);
            if stack_index <= ignore_index
            {
                value,_ := strconv.parse_int(input[left:right-1]);
                new_value := array_get(total_stack, stack_index) + value;
                array_set(&total_stack, stack_index, new_value);
                if debug do fmt.println("Recording number on stack_index", stack_index, ":", new_value, array_slice(total_stack));
            }
            else if debug do fmt.println("Number ignored");
            left = right;
        }

        switch c
        {
            case 'd':
                if lookback[0] == 'e' && lookback[1] == 'r' 
                    && current_location == Location.object
                    && stack_index <= ignore_index
                {
                    array_set(&total_stack, stack_index, 0);
                    ignore_index = stack_index - 1;
                    if debug do fmt.println("Red inside object, ignore_index:", ignore_index);
                }
                left = right;
            case '{':
                if stack_index <= ignore_index
                {
                    ignore_index += 1;
                }

                array_push(&locations, Location.object);
                current_location = Location.object;

                array_push(&total_stack, 0);
                stack_index += 1;
                if debug do fmt.println("Entered into object:", stack_index, "ignore:", ignore_index);

                left = right;
            case '[':
                if stack_index <= ignore_index
                {
                    ignore_index += 1;
                }

                array_push(&locations, Location.array);
                current_location = Location.array;

                array_push(&total_stack, 0);
                stack_index += 1;
                if debug do fmt.println("Entered into array");

                left = right;
            case '}':
                array_pop_back(&locations);
                current_location = array_get(locations, locations.len-1);

                object_total := array_pop_back(&total_stack);

                stack_index -= 1;
                if stack_index+1 <= ignore_index
                {
                    new_total := array_get(total_stack, stack_index) + object_total;
                    array_set(&total_stack, stack_index, new_total);
                    
                    ignore_index = stack_index;
                }

                
                if debug do fmt.println("Exited object, now in", current_location, "stack_index:", stack_index, "ignore_index:", ignore_index);

                left = right;
            case ']':
                array_pop_back(&locations);
                current_location = array_get(locations, locations.len-1);

                array_total := array_pop_back(&total_stack);

                stack_index -= 1;
                if stack_index+1 <= ignore_index
                {
                    // Attribute array to below index
                    new_total := array_get(total_stack, stack_index) + array_total;
                    array_set(&total_stack, stack_index, new_total);

                    ignore_index = stack_index;
                }

                
                if debug do fmt.println("Exiting array, now in", current_location, "stack_index:", stack_index);

                left = right;
            case '0'..'9','-':
                //fmt.println("Digit");
            case:
                left = right;
        }

        lookback[1] = lookback[0];
        lookback[0] = c;
    }

    end_time := time.now();
    end_cycle := time.read_cycle_counter();

    fmt.println(time.duration_nanoseconds(time.diff(start_time, end_time)), "ns");
    fmt.println(end_cycle - start_cycle, "clock cycles");
    fmt.println(array_get(total_stack, 0));
}

day_twelve :: proc(input: string)
{
    pt2 :: true;
    if pt2 
    {
        day_twelve_pt2(input);
        return;
    }

    total := 0;

    left := 0;
    right := 0;
    
    last_was_digit := false;

    for c in input
    {
        switch c
        {
            case '0'..'9', '-':
                right = right + 1;
                last_was_digit = true;
            case:
                if last_was_digit
                {
                    value,_ := strconv.parse_int(input[left:right]);
                    total = total + value;
                    last_was_digit = false;
                }
                right = right + 1;
                left = right;
        }
    }

    fmt.println(total);
}


day_thirteen :: proc(input: string)
{
    using parse;
    using permute;

    word_info := make_parse_info(input);
    word_info.search = {TokenType.Word};

    number_info := make_parse_info(input);
    number_info.search = {TokenType.Number};

    adjacency_bonus := make(map[i64]int);

    i := 0;
    j := 1;
    
    pt2 :: true;
    when pt2 
    {
        Seats :: 9;    
    }
    else
    {
        Seats :: 8;
    }

    FileSeats :: 8;

    for i in 0..<FileSeats
    {
        for j in 0..<FileSeats
        {
            if i == j do continue;

            gain: bool;
            for 
            {
                word,_ := parse_next(&word_info);
                if word.data == "gain" || word.data == "lose"
                {
                    gain = word.data == "gain";
                    break;
                }
            }

            token,_ := parse_next(&number_info);
            adjacency_bonus[hash_2D(i,j)] = token.number if gain else -token.number;
        }
    }

    if pt2 
    {
        for i in 0..<Seats-1
        {
            adjacency_bonus[hash_2D(i,Seats-1)] = 0;
            adjacency_bonus[hash_2D(Seats-1,i)] = 0;
        }
    }

    lookup: [Seats]int;
    for i in 0..<Seats do lookup[i] = i;

    permutation := make_permutation(Seats);
    max_happiness := -999;

    for permute_next(&permutation, &lookup)
    {
        total_happiness := 0;
        last_seat := Seats-1;
        for i in 0..<Seats
        {
            total_happiness += adjacency_bonus[hash_2D(lookup[last_seat], lookup[i])];
            total_happiness += adjacency_bonus[hash_2D(lookup[i], lookup[last_seat])];
            last_seat = i;
        }
        
        max_happiness = max(max_happiness, total_happiness);
    }

    fmt.println(max_happiness);
}


Reindeer :: struct 
{
    speed: int,
    run_time: int,
    rest_time: int,
    index: int,
    resting: bool,
    distance: int,
    points: int
}


day_fourteen :: proc(input: string)
{
    pt2 :: true;

    using parse;

    Seconds :: 2503;

    parse_info := make_parse_info(input);
    parse_info.search = {TokenType.Number};

    reindeer := make([dynamic]Reindeer);

    for 
    {
        speed, ok := parse_next(&parse_info);
        run,_ := parse_next(&parse_info);
        rest,_ := parse_next(&parse_info);
        if !ok do break;

        append(&reindeer, Reindeer{speed=speed.number, run_time=run.number, rest_time=rest.number});
    }


    for s := 0; s < Seconds; s += 1
    {
        max_distance := 0;

        for _,i in reindeer
        {
            if !reindeer[i].resting
            {
                reindeer[i].distance += reindeer[i].speed;
                reindeer[i].index += 1;
                if reindeer[i].index == reindeer[i].run_time
                {
                    reindeer[i].index = 0;
                    reindeer[i].resting = true;
                }
            }
            else
            {
                reindeer[i].index += 1;
                if reindeer[i].index == reindeer[i].rest_time
                {
                    reindeer[i].index = 0;
                    reindeer[i].resting = false;
                }
            }
            max_distance = max(max_distance, reindeer[i].distance);
        }

        if pt2 do for _,i in reindeer
        {
            if reindeer[i].distance == max_distance
            {
                reindeer[i].points += 1;
            }
        }
    }


    if !pt2 
    {
        max_distance := 0;
        for r in reindeer
        {
            max_distance = max(max_distance, r.distance);
        }

        fmt.println(max_distance);    
    }
    else
    {
        max_points := 0;
        for r in reindeer
        {
            max_points = max(max_points, r.points);
        }

        fmt.println(max_points);
    }
}


Props :: [4]int;

Ingredient :: struct
{
    props: Props,
    cal: int
}

day_fifteen :: proc(input: string)
{
    pt2 :: true;

    using parse;

    parse_info := make_parse_info(input);
    parse_info.search = {TokenType.Number};

    NumIngredients :: 4;
    ingredients: [NumIngredients]Ingredient;

    for i in 0..<NumIngredients
    {
        ingredients[i] = Ingredient{};
        for j in 0..<4
        {
            token,_ := parse_next(&parse_info);
            ingredients[i].props[j] = token.number;
        }
        token,_ := parse_next(&parse_info);
        ingredients[i].cal = token.number;
    }

    //for i in 0..<4 do fmt.println(ingredients[i]);

    p: Props;
    max_score := 0;

    // Max ingredients for each type determined with algebra
    for a in 0..<40
    {
        for b in 0..<50
        {
            for c in 0..<75
            {
                for d in 0..<66
                {
                    if a + b + c +d != 100 do continue;
                    if pt2 && a * ingredients[0].cal + b * ingredients[1].cal 
                        + c * ingredients[2].cal + d * ingredients[3].cal != 500
                    {
                        continue;
                    }

                    p = a * ingredients[0].props + b * ingredients[1].props
                      + c * ingredients[2].props + d * ingredients[3].props;
                    
                    s := max(p[0],0) * max(p[1],0) * max(p[2],0) * max(p[3],0);
                    max_score = max(s, max_score);
                }
            }
        }
    }

    fmt.println(max_score);
}


day_sixteen :: proc(input: string)
{
    pt2 :: true;

    using parse;

    aunt_info : [500]map[string]int;

    parse_info := make_parse_info(input);
    parse_info.search = {TokenType.Word, TokenType.Number};

    check: map[string]int;
    check["children"] = 3;
    check["cats"] = 7;
    check["samoyeds"] = 2;
    check["pomeranians"] = 3;
    check["akitas"] = 0;
    check["vizslas"] = 0;
    check["goldfish"] = 5;
    check["trees"] = 3;
    check["cars"] = 2;
    check["perfumes"] = 1;


    sue_check: for i in 0..<500 
    {
        // Read sue #
        parse_next(&parse_info);
        parse_next(&parse_info);

        for j in 0..<3
        {
            name_token,_ := parse_next(&parse_info);
            number_token,_ := parse_next(&parse_info);
            aunt_info[i][name_token.data] = number_token.number;
        }

        for k,v in check
        {
            if !(k in aunt_info[i]) do continue;
            if pt2
            {
                if k == "cats" || k == "trees"
                {
                    if aunt_info[i][k] <= v do continue sue_check;
                }
                else if k == "pomeranians" || k == "goldfish"
                {
                    if aunt_info[i][k] >= v do continue sue_check;
                }
                else if v != aunt_info[i][k]
                {
                    continue sue_check;
                }
            }
            else if v != aunt_info[i][k]
            {
                continue sue_check;
            }
        }

        fmt.println("Sue #", i+1, "is a match");
    }
}


day_seventeen :: proc(input: string)
{
    pt2 :: true;

    using parse;

    info := make_parse_info(input);
    info.search = {TokenType.Number};

    containers := make([dynamic]int);
    defer delete(containers);

    for 
    {
        token,ok := parse_next(&info);
        if !ok do break;
        append(&containers, token.number);
    }

    // Get all combinations of containers
    num_containers := uint(len(containers));
    num_combos := 1 << num_containers;
    valid_combos := 0;
    min_containers := 100;

    for i in 0..<num_combos
    {
        container_count := 0;
        mask := 1;
        total := 0;
        for j in 0..<num_containers
        {
            if i & mask > 0
            {
                container_count += 1;
                total += containers[j];
            }
            mask *= 2;
        }

        if !pt2
        {
            if total == 150 do valid_combos += 1;
        }
        else if total == 150
        {
            if container_count < min_containers
            {
                min_containers = container_count;
                valid_combos = 1;
            }
            else if container_count == min_containers
            {
                valid_combos += 1;
            }
        }
    }

    fmt.println(valid_combos, "valid combinations");
}


day_eighteen :: proc(input: string)
{
    pt2 :: true;
    length :: 100;
    area :: length * length;
    steps :: 100;

    current_state: [area]bool;
    next_state: [area]bool;

    i := 0;
    for c in input
    {
        switch c 
        {
            case '\r': fallthrough;
            case '\n': continue;
            case '#':
                current_state[i] = true;
            case '.':
                current_state[i] = false;
        }
        i += 1;
    }

    get_state :: proc(array: [area]bool, x: int, y: int) -> int
    {
        i := x + y * length;
        if x < 0 || x >= length || y < 0 || y >= length do return 0;
        return 1 if array[i] else 0;
    }

    if pt2 
    {
        current_state[0] = true;
        current_state[length-1] = true;
        current_state[(length-1)*length] = true;
        current_state[length*length-1] = true;
    }

    for step in 0..<steps
    {
        for y in 0..<length
        {
            for x in 0..<length
            {
                neighbors := 0;
                neighbors += get_state(current_state, x-1, y-1);
                neighbors += get_state(current_state, x, y-1);
                neighbors += get_state(current_state, x+1, y-1);

                neighbors += get_state(current_state, x-1, y);
                neighbors += get_state(current_state, x+1, y);
                
                neighbors += get_state(current_state, x-1, y+1);
                neighbors += get_state(current_state, x, y+1);
                neighbors += get_state(current_state, x+1, y+1);


                self := get_state(current_state, x, y);
                index := x + y * length;
                
                next_state[index] = 
                    (self == 0 && neighbors == 3) || 
                    (self == 1 && (neighbors == 2 || neighbors == 3));
            }
        }
        
        for j in 0..<area
        {
            current_state[j] = next_state[j];
        }

        if pt2 
        {
            current_state[0] = true;
            current_state[length-1] = true;
            current_state[(length-1)*length] = true;
            current_state[length*length-1] = true;
        }
    }

    lights_on := 0;
    for i in 0..<area
    {
        if current_state[i] do lights_on += 1;
    }

    fmt.println(lights_on, "lights on");
}


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


day_nineteen :: proc(input: string)
{
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


// Driver ---------------------------------------------------------//
read_input_file :: proc(index: int) -> (string, bool) 
{
    file_name: string;
    {
        inputs_prefix  :: "..\\inputs\\";
        inputs_postfix :: ".txt";
        
        builder := strings.make_builder();
        strings.write_string(&builder, inputs_prefix);
        
        // Prepend 0 for days 1-9
        if index < 10 do strings.write_int(&builder, 0);
        
        strings.write_int(&builder, index);
        strings.write_string(&builder, inputs_postfix);

        file_name = strings.to_string(builder);
    }
    
    data, success := os.read_entire_file(file_name);
    if !success do return "", success;
    return string(data), success;
}


read_user_input :: proc(data: []byte, length: int) -> bool 
{
    index := 0;
    for index < length
    {
        _, input_err := os.read(os.stdin, data[index:index+1]);
        if input_err != 0
        {
            return true;
        }

        // Line feed
        if data[index] == 10 
        {
            return false;
        }
        index = index + 1;
    }

    return false;
}


main :: proc() 
{
    user_input := make([]byte, 4);

    for 
    {
        // Get user input
        fmt.print("Enter day number of puzzle to solve: ");
        input_err := read_user_input(user_input, 4);

        if input_err
        {
            fmt.println("Error reading input");
        }

        // Check for attempted exit
        lower_user_input := strings.to_lower(string(user_input));
        if lower_user_input == "stop" || lower_user_input == "exit"
        {
            return;
        }
        delete(lower_user_input);

        day_number, ok := strconv.parse_int(string(user_input));
        if !ok 
        {
            fmt.println("Please enter a valid number day");
            continue;
        }

        input, read_success := read_input_file(day_number);
        if !read_success
        {
            fmt.println("Error occurred while reading input file");
            continue;
        }

        switch (day_number)
        {
            case 1:
                day_one(input);
            case 2:
                day_two(input);
            case 3:
                day_three(input);
            // MD5 hash algorithm
            // case 4: 
            //     day_four(input)
            case 5:
                day_five(input);
            case 6:
                day_six(input);
            case 7:
                day_seven(input);
            case 8:
                day_eight(input);
            case 9:
                day_nine(input);
            case 10:
                day_ten(input);
            case 11:
                day_eleven(input);
            case 12:
                day_twelve(input);
            case 13:
                day_thirteen(input);
            case 14:
                day_fourteen(input);
            case 15:
                day_fifteen(input);
            case 16:
                day_sixteen(input);
            case 17:
                day_seventeen(input);
            case 18:
                day_eighteen(input);
            case 19:
                day_nineteen(input);
            case 20..25:
                fmt.println("Day not implemented");
            case:
                fmt.println("Please enter a valid number day");
        }

        delete(input);
    }
}