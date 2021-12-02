string inputFile = @"../../inputs/02.txt";

var input = File.ReadAllText(inputFile);
var lines = File.ReadAllLines(inputFile);

// Part 1
int x = 0;
int y = 0;

foreach (var line in lines) {
    string[] words = line.Split(" ");
    string command = words[0];
    int amount = Int32.Parse(words[1]);

    if (command == "forward") {
        x += amount;
    }
    else if (command == "down") {
        y += amount;
    }
    else if (command == "up") {
        y -= amount;
    }
}

Console.WriteLine(x * y);

// Part 2
x = 0;
y = 0;
int aim = 0;

foreach (var line in lines) {
    string[] words = line.Split(" ");
    string command = words[0];
    int amount = Int32.Parse(words[1]);

    if (command == "forward") {
        x += amount;
        y += aim * amount;
    }
    else if (command == "down") {
        aim += amount;
    }
    else if (command == "up") {
        aim -= amount;
    }
}

Console.WriteLine(x * y);