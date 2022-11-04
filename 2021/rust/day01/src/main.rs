use std::fs;

fn main() {
    part_1();
    part_2();
}

fn part_1() {
    let content = fs::read_to_string("../../inputs/01.txt")
        .expect("Unable to read file");
    let lines = content.split("\r\n");
    
    let mut previous = i32::MAX;
    let mut increases = 0;

    for line in lines {
        let line: i32 = line.parse()
            .expect("Unable to read line number");
        if line > previous {
            increases += 1;
        }
        previous = line;
    }

    println!("Part 1: {}", increases);
}

fn part_2() {
    let content = fs::read_to_string("../../inputs/01.txt")
        .expect("Unable to read file");
    let lines = content.split("\r\n");
    let mut heights: Vec<i32> = Vec::new();

    for line in lines {
        let line: i32 = line.parse()
            .expect("Unable to parse line");
        heights.push(line);
    }

    let mut increases = 0;
    for index in 0..heights.len()-3 {
        let prev = heights[index + 0] + heights[index + 1] + heights[index + 2];
        let next = heights[index + 1] + heights[index + 2] + heights[index + 3];

        if next > prev {
            increases += 1;
        }
    }

    println!("Part 2: {}", increases);
}