package main

import "core:slice"
import "core:fmt"
import "core:strings"
import "core:strconv"

import "../../libs/Odin/aoc"

Recipe :: struct {
    ingredients: []string,
    allergens: []string
}

main :: proc() {
    input := string(#load("../inputs/21.txt"));
    lines := strings.split(input, "\r\n");

    allergens := make(map[string]bool);
    ingredients := make(map[string]bool);
    recipes := make([dynamic]Recipe);


    for line in lines {
        line_parts := strings.split(line, " (contains ");
        ingreds := strings.split(line_parts[0], " ");
        allergs := strings.split(aoc.replace(line_parts[1], ")", ""), ", ");

        append(&recipes, Recipe{ingreds, allergs});

        for ingredient in ingreds {
            ingredients[ingredient] = true;
        }
        for allergen in allergs {
            allergens[allergen] = true;
        }
    }

    possible_allergens: map[[2]string]bool;
    for ingredient in ingredients {
        for allergen in allergens {
            possible_allergens[{ingredient, allergen}] = true;
        }
    }

    // Find ingredients that have no allergens
    for recipe in recipes {
        for ingredient in ingredients {
            if !aoc.search(recipe.ingredients, ingredient) {
                for allergen in recipe.allergens {
                    possible_allergens[{ingredient, allergen}] = false;
                }
            }
        }
    }

    no_allergens := make(map[string]bool);
    for ingredient in ingredients {
        has_allergen := false;
        for allergen in allergens {
            has := possible_allergens[{ingredient, allergen}];
            if has {
                has_allergen = true;
                break;
            }
        }
        if !has_allergen {
            no_allergens[ingredient] = true;
        }
    }

    // Count allergens in list
    total := 0;
    for recipe in recipes {
        for ingredient in recipe.ingredients {
            if ingredient in no_allergens {
                total += 1;
            }
        }
    }
    fmt.println(total);

    // Part 2 - solve for each allergent
    solved_allergens := make(map[string]bool, len(allergens));
    dangerous_ingredients := make([dynamic][2]string);
    for {
        if len(solved_allergens) == len(allergens) do break;

        for allergen in allergens {
            if allergen in solved_allergens do continue;

            // See if there is only one ingredient that can be this allergen
            count := 0;
            matched: string;
            for ingredient in ingredients {
                if possible_allergens[{ingredient, allergen}] {
                    matched = ingredient;
                    count += 1;
                    if count > 1 do break;
                }
            }

            if count == 1 { 
                append(&dangerous_ingredients, [2]string{matched, allergen});
                // dangerous_ingredients[ingredient] = allergen;
                solved_allergens[allergen] = true;
                for a in allergens {
                    possible_allergens[{matched, a}] = false;
                }
            }
        }
    }
    slice.sort_by(dangerous_ingredients[:], proc(i, j: [2]string) -> bool {
        return i[1] < j[1];
    });
    for ing,i in dangerous_ingredients {
        fmt.print(ing[0]);
        if i < len(dangerous_ingredients) - 1 {
            fmt.print(",");
        }
    }
    fmt.println();
}