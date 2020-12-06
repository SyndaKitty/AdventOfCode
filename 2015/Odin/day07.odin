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


main :: proc()
{
    input := string(#load("../inputs/07.txt"));

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