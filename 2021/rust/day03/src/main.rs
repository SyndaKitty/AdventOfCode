use std::fs;

fn main() {
    part_1();
    part_2();
}

fn part_1() {
    let content = fs::read_to_string("../../inputs/03.txt")
        .expect("Unable to read file");

    let lines: Vec<&str> = content.split("\r\n").collect();

    let mut bit_count = Vec::new();

    for _ in lines[0].chars() {
        bit_count.push((0, 0));
    }

    for line in lines {
        let mut char_index = 0;
        for c in line.chars() {
            match c {
                '0' => bit_count[char_index].0 += 1,
                '1' => bit_count[char_index].1 += 1,
                _ => panic!("Unexpected value {}", c)
            }
            char_index += 1;
        }
    }

    let mut epsilon = 0;
    let mut gamma = 0;
    for count in bit_count {
        match count {
            (x, y) if x > y => {
                epsilon <<= 1;
                gamma <<= 1;
                gamma += 1;
            },
            _ => {
                epsilon <<= 1;
                gamma <<= 1;
                epsilon += 1;
            }
        }
    }
    println!("Part1: {}", epsilon * gamma);
}

fn part_2() {
    let content = fs::read_to_string("../../inputs/03.txt")
        .expect("Unable to read file");

    let lines: Vec<&str> = content.split("\r\n").collect();

    let mut o2_items = lines.clone();
    let mut bit_index = 0;
    while o2_items.len() > 1 {
        filter(&mut o2_items, bit_index, true);
        bit_index += 1;
    }

    let mut co2_items = lines.clone();
    bit_index = 0;
    while co2_items.len() > 1 {
        filter(&mut co2_items, bit_index, false);
        bit_index += 1;
    }

    let o2 = binary_to_decimal(o2_items[0]);
    let co2 = binary_to_decimal(co2_items[0]);
    println!("Part2: {}", o2 * co2);
}

fn filter(items: &mut Vec<&str>, bit_index: usize, most_common: bool) {
    let mut count = (0, 0);
    for item in items {
        let chars: Vec<char> = item.chars().collect();
        println!("{}", chars[bit_index]);
        match chars[bit_index] {
            '0' => count.0 += 1,
            '1' => count.1 += 1,
            c => panic!("Unexpected value {}", c)
        }
    }
    let mut discard = match count {
        (x, y) if x > y => 0,
        (x, y) if y > x => 1,
        _ => 1
    };
    println!("Discarding: {}", discard);

    if !most_common {
        discard = 1 - discard;
    }

    let discard = char::from_digit(discard, 10)
        .expect("Invalid digit");

    items.iter().filter(|x| {
        let chars: Vec<char> = x.chars().collect();
        chars[bit_index] == discard
    });
}

fn binary_to_decimal(str: &str) -> i32 {
    let mut num = 0;
    for bit in str.chars() {
        num <<= 1;
        if bit == '1' {
            num += 1;
        }
    }
    num
}