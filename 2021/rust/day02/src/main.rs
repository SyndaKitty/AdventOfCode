use std::fs;

fn main() {
    part_1();
    part_2();
}

fn part_1() {
    let content = fs::read_to_string("../../inputs/02.txt")
        .expect("Unable to read file");
    let lines = content.split("\r\n");

    let mut x = 0;
    let mut y = 0;

    for line in lines {
        let args: Vec<&str> = line.split(" ").collect();
        let command = args[0];
        let amount: i32 = args[1].parse()
            .expect("Unable to parse amount");

        if command == "forward" {
            x += amount;
        }
        else if command == "down" {
            y += amount;
        }
        else if command == "up" {
            y -= amount;
        }
    }

    println!("Part 1: {}", x * y);
}

fn part_2() {
    let content = fs::read_to_string("../../inputs/02.txt")
        .expect("Unable to read file");
    let lines = content.split("\r\n");

    let mut x = 0;
    let mut y = 0;
    let mut aim = 0;

    for line in lines {
        let args: Vec<&str> = line.split(" ").collect();
        let command = args[0];
        let amount: i32 = args[1].parse()
            .expect("Unable to parse amount");

        if command == "forward" {
            x += amount;
            y += aim * amount;
        }
        else if command == "down" {
            aim += amount;
        }
        else if command == "up" {
            aim -= amount;
        }
    }

    println!("Part 2: {}", x * y);
}