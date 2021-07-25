package main

import "core:fmt"
import "core:strings"
import "core:strconv"

import "../../libs/Odin/aoc"


main :: proc() {
    input := string(#load("../inputs/18.txt"));

    lines := strings.split(input, "\r\n");

    total := 0;

    for line in lines {
        e := eval(line);
        fmt.println(e);
        total += e;
    }

    fmt.println(total);
}

Tokenizer :: struct {
    i: int,
    expression: string
};

eval :: proc(exp: string) -> int {
    t := Tokenizer{0, aoc.replace(exp, " ", "")};
    
    operation: [dynamic]rune;
    operand: [dynamic]int;
    for t.i = 0; t.i < len(t.expression);  {
        c := t.expression[t.i];
        switch c {
            case '0'..'9':
                append(&operand,int(c - '0'));
                t.i += 1;
            case '+','*':
                append(&operation, rune(c));
                t.i += 1;
            case '(':
                sub,new_i := get_sub_expr(&t);
                append(&operand, eval(sub));
                t.i = new_i;
            case ')':
                t.i += 1;
        }
    }

    // result := operand[0];

    // for i := 1; i < len(operand); i+=1 {
    //     if operation[i-1] == '*' {
    //         result *= operand[i];
    //     } else {
    //         result += operand[i];
    //     }
    // }

    result := 1;


    fmt.println(operand, operation);
    if len(operand) == 2 {
        if operation[0] == '*' {
            return operand[0] * operand[1];
        }
        return operand[0] + operand[1];
    }
    for {
        new_operation, new_operand, cont := eval_add(operation, operand);
        operation = new_operation;
        operand = new_operand;

        if len(operand) == 2 {
            if operation[0] == '*' {
                return operand[0] * operand[1];
            }
            return operand[0] + operand[1];
        }

        if !cont do break;
    }

    for operands in operand {
        result *= operands;
    }
    fmt.println(result);

    return result;
}

eval_add :: proc(operation: [dynamic]rune, operand: [dynamic]int) -> ([dynamic]rune, [dynamic]int, bool) {
    // out_ops := make([dynamic]rune, len(operation));
    // out_opands := make([dynamic]int, len(operand));
    out_ops: [dynamic]rune;
    out_opands: [dynamic]int;

    //fmt.println("Starting", operation, operand);

    append(&out_opands, 0);

    evaled := false;
    op_i := 0;
    for i := 0; i < len(operand)-1; i+=1 {
        if !evaled && operation[i] == '+' {
            //fmt.println("    adding sum",int(operand[i] + operand[i + 1]));
            out_opands[i] = int(operand[i] + operand[i + 1]);
            evaled = true;
            continue;
        }
        else if i == 0 {
            out_opands[0] = operand[i];
            //fmt.println("    first index, adding",operand[i]);
        }
        //fmt.println("    adding", operand[i+1]);
        append(&out_opands, 0);
        append(&out_ops, operation[i]);
        out_opands[op_i + 1] = operand[i+1];
        op_i += 1;
    }
    //fmt.println(out_ops, out_opands, evaled);

    // 9446955601736 too low
    return out_ops, out_opands, evaled;
}

get_sub_expr :: proc(t: ^Tokenizer) -> (string,int) {
    level := 0;
    using t;
    i += 1;
    start := i;
    for ;i < len(expression); i+=1 {
        if expression[i] == '(' do level += 1;
        if expression[i] == ')' do level -= 1;
        if level < 0 {
            return expression[start:i], i;
        }
    }

    return "", 0;
}

