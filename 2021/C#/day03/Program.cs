string inputFile = @"../../inputs/03.txt";

var input = File.ReadAllText(inputFile);
var lines = File.ReadAllLines(inputFile);

// Part 1
string gamma = "";
string epsilon = "";

for (int i = 0; i < 12; i++) {
    int zero = 0;
    int one = 0;
    foreach (var line in lines) {
        if (line.ToCharArray()[i] == '0') zero++;
        else one++;
    }

    if (zero > one) {
        gamma += "0";
        epsilon += "1";
    } 
    else {
        gamma += "1";
        epsilon += "0";
    }
}

Console.WriteLine(Convert.ToInt32(epsilon, 2) * Convert.ToInt32(gamma, 2));


// Part 2 - messy but it works
List<string> validLines = new List<string>(lines);
for (int i = 0; i < 12; i++) {
    int zero = 0;
    int one = 0;
    foreach (var line in validLines) {
        if (line.ToCharArray()[i] == '0') {
            zero++;
        }
        else {
            one++;
        }
    }
    if (zero > one) {
        validLines = validLines.Where(l => l.ToCharArray()[i] == '0').ToList();
    }
    else {
        validLines = validLines.Where(l => l.ToCharArray()[i] == '1').ToList();
    }
}
int oxygen = Convert.ToInt32(validLines.First(), 2);

validLines = new List<string>(lines);
for (int i = 0; i < 12; i++) {
    int zero = 0;
    int one = 0;
    foreach (var line in validLines) {
        if (line.ToCharArray()[i] == '0') {
            zero++;
        }
        else {
            one++;
        }
    }
    if (zero > one) {
        validLines = validLines.Where(l => l.ToCharArray()[i] == '1').ToList();
    }
    else {
        validLines = validLines.Where(l => l.ToCharArray()[i] == '0').ToList();
    }
    if (validLines.Count == 1) break;
}
int co2 = Convert.ToInt32(validLines.First(), 2);

Console.WriteLine(oxygen * co2);