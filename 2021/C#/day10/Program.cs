string inputFile = @"../../inputs/10.txt";

var lines = File.ReadAllLines(inputFile);

Dictionary<char, char> Closing = new Dictionary<char, char> {
    {'(', ')'},
    {'[', ']'},
    {'{', '}'},
    {'<', '>'},
};
Dictionary<char, int> Score = new Dictionary<char, int> {
    {')', 3},
    {']', 57},
    {'}', 1197},
    {'>', 25137},
};

// Part 1
long score = 0;
foreach (var line in lines) {
    string buffer = "";
    foreach (var c in line) {
        if ("([{<".Contains(c)) {
            buffer += c;
        }
        else if (Closing[buffer.Last()] == c) {
            buffer = buffer.Substring(0, buffer.Length - 1);
        }
        else {
            score += Score[c];
            break;
        }
    }
}

Console.WriteLine(score);

// Part 2
List<long> scores = new List<long>();
foreach (var line in lines) {
    score = 0;
    string buffer = "";
    bool corrupted = false;
    foreach (var c in line) {
        if ("([{<".Contains(c)) {
            buffer += c;
        }
        else if (Closing[buffer.Last()] == c) {
            buffer = buffer.Substring(0, buffer.Length - 1);
        }
        else {
            corrupted = true;
            break;
        }
    }
    if (!corrupted) {
        foreach (var c in buffer.Reverse()) {
            score *= 5;
            score += "([{<".IndexOf(c) + 1;
        }
        scores.Add(score);
    }
}
scores.Sort();
Console.WriteLine(scores[scores.Count / 2]);