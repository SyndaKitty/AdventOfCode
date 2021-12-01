string inputFile = @"../../inputs/01.txt";

var input = File.ReadAllText(inputFile);
var lines = File.ReadAllLines(inputFile);
var numbers = lines.Select(l => Int32.Parse(l)).ToArray();

// Part 1
int increases = 0;
for (int i = 1; i < numbers.Length; i++) {
    if (numbers[i-1] < numbers[i]) {
        increases++;
    }
}

Console.WriteLine(increases);

// Part 2
increases = 0;
for (int i = 0; i < numbers.Length- 3; i++) {
    int sum1 = numbers[i + 0] + numbers[i + 1] + numbers[i + 2];
    int sum2 = numbers[i + 1] + numbers[i + 2] + numbers[i + 3];
    if (sum2 > sum1) {
        increases++;
    }
}

Console.WriteLine(increases);