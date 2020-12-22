package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import c "core:container"

import "../../libs/Odin/aoc"

Deck :: struct {
    cards: [dynamic]int,
    index: int
}

main :: proc() {
    input := string(#load("../inputs/22.txt"));

    da1: [dynamic]int;
    da2: [dynamic]int;
    db1: [dynamic]int;
    db2: [dynamic]int;

    parts := strings.split(aoc.replace(aoc.replace(input, "Player 2:\r\n", ""), "Player 1:\r\n", ""), "\r\n\r\n");
    lines := strings.split(parts[0], "\r\n");
    for line in lines {
        append(&da1, aoc.parse_int(line));
        append(&da2, aoc.parse_int(line));
    }
    lines = strings.split(parts[1], "\r\n");
    for line in lines {
        append(&db1, aoc.parse_int(line));
        append(&db2, aoc.parse_int(line));
    }

    a := &Deck{da1, 0};
    b := &Deck{db1, 0};
    for turn(a, b) { }
    fmt.println(score(a, b));

    a = &Deck{da2, 0};
    b = &Deck{db2, 0};
    recursive_combat(a, b, 1);
    fmt.println(score(a, b));
}

score :: proc(da, db: ^Deck) -> int {
    winning_deck: Deck;
    if da.index < len(da.cards) {
        winning_deck = da^;
    }
    else {
        winning_deck = db^;
    }
    score := 0;
    multiplier := 1;
    for i := len(winning_deck.cards)-1; i >= winning_deck.index; i-=1 {
        score += winning_deck.cards[i] * multiplier;
        multiplier += 1;
    }
    return score;
}

turn :: proc(da: ^Deck, db: ^Deck) -> bool {
    a := get_card(da);
    b := get_card(db);

    if a > b {
        append(&da.cards, a, b);
    }
    if b > a {
        append(&db.cards, b, a);   
    }

    return da.index < len(da.cards) && db.index < len(db.cards);
}

get_card :: proc(deck: ^Deck) -> int {
    card := deck.cards[deck.index];
    deck.index += 1;
    return card;
}


card_count :: proc(deck: ^Deck) -> int {
    return len(deck.cards) - deck.index;
}

recursive_combat :: proc(da, db: ^Deck, depth: int) -> int {
    previous_rounds := make([dynamic][2][dynamic]int);
    round := 1;
    for {
        if (recursive_round(da, db, &previous_rounds, depth)) {
            return 0;
        }
        round += 1;
        if card_count(da) == 0 {
            return 1;
        }
        else if card_count(db) == 0 {
            return 0;
        }
    }
}


recursive_round :: proc(da, db: ^Deck, previous_rounds: ^[dynamic][2][dynamic]int, depth: int) -> bool {
    // Check for previous round
    for round in previous_rounds {
        if equal(da.cards[da.index:len(da.cards)], round[0][:]) &&
           equal(db.cards[db.index:len(db.cards)], round[1][:]) {
                return true;
        }
    }

    // Record previous round
    snapshot: [2][dynamic]int;
    snapshot[0] = make([dynamic]int);
    snapshot[1] = make([dynamic]int);
    for i := da.index; i < len(da.cards); i += 1 {
        append(&snapshot[0], da.cards[i]);
    }
    for i := db.index; i < len(db.cards); i += 1 {
        append(&snapshot[1], db.cards[i]);
    }
    append(previous_rounds, snapshot);

    // Both players draw
    a := get_card(da);
    b := get_card(db);

    if card_count(da) >= a && card_count(db) >= b {
        new_a := make([dynamic]int);
        for i := da.index; i < da.index + a; i+=1 {
            append(&new_a, da.cards[i]);
        }
        new_b := make([dynamic]int);
        for i := db.index; i < db.index + b; i+=1 {
            append(&new_b, db.cards[i]);
        }

        winner := recursive_combat(&Deck{new_a, 0}, &Deck{new_b, 0}, depth + 1);
        if winner == 0 {
            append(&da.cards, a);
            append(&da.cards, b);
        }
        else {
            append(&db.cards, b);
            append(&db.cards, a);
        }
    }
    else {
        if a > b {
            append(&da.cards, a);
            append(&da.cards, b);
        } else {
            append(&db.cards, b);
            append(&db.cards, a);
        }
    }
    return false;
}


equal :: proc(a,b: []int) -> bool {
    if len(a) != len(b) do return false;
    for d,i in a {
        if b[i] != d {
            return false;
        }
    }
    return true;
}

print_deck :: proc(a: Deck) {
    for i := a.index; i < len(a.cards); i+=1 {
        fmt.print(a.cards[i]);
        fmt.print(", ");
    }
}