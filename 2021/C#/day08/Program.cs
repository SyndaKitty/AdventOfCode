string inputFile = @"../../inputs/08.txt";

var input = File.ReadAllText(inputFile);
var lines = File.ReadAllLines(inputFile);

// Part 1
int[] lengthToDigit = new int[] {-1, -1, 1, 7, 4, -1, -1, 8};

int count = 0;
foreach (var line in lines) {
    var parts = line.Split(" | ");
    var patterns = parts[0].Split(" ").Select(x => Sort(x));
    var output = parts[1].Split(" ").Select(x => Sort(x));

    Dictionary<string, int> lookup = new Dictionary<string, int>();
    
    foreach (var pattern in patterns) {
        int d = lengthToDigit[pattern.Length];
        if (d != -1) {
            lookup.Add(pattern, d);
        }
    }

    foreach (var str in output) {
        if (lookup.ContainsKey(str)) {
            count++;
        }
    }
}
Console.WriteLine(count);

// Part 2
int sum = 0;
foreach (var line in lines) {
    var parts = line.Split(" | ");
    var patterns = parts[0].Split(" ").Select(x => Sort(x));
    var output = parts[1].Split(" ").Select(x => Sort(x));

    Dictionary<int, string> digit = new Dictionary<int, string>();

    foreach (var pattern in patterns) {
        int d = lengthToDigit[pattern.Length];
        if (d != -1) {
            digit.Add(d, pattern);
        }
    }

    var fives = patterns.Where(p => p.Length == 5);
    var sixes = patterns.Where(p => p.Length == 6);

    string middles = Intersect(fives.ToArray());
    string sides = Diff("abcdefg", middles);

    string middle = Intersect(middles, Diff(digit[4], digit[7]));
    string leftTop = Diff(digit[4], digit[1], middle);
    string leftBottom = Diff(Intersect(sides, Diff(digit[8], digit[7])), leftTop);

    digit[5] = fives.First(p => p.Contains(leftTop));
    digit[2] = fives.First(p => p != digit[5] && p.Contains(leftBottom));
    digit[3] = fives.First(p => p != digit[5] && p != digit[2]);
    digit[0] = sixes.First(p => !p.Contains(middle));
    digit[6] = sixes.First(p => p != digit[0] && p.Contains(leftBottom));
    digit[9] = sixes.First(p => p != digit[0] && p != digit[6]);

    int mult = 1000;
    foreach (var str in output) {
        sum += digit.First(x => x.Value == str).Key * mult;
        mult /= 10;
    }
}

Console.WriteLine(sum);

string Intersect(params string[] strings) {
    string res = strings[0];
    foreach (var s in strings.Skip(1)) {
        res = new String(res.Where(c => s.Contains(c)).ToArray());
    }
    return res;
} 

string Diff(params string[] strings) {
    string res = strings[0];
    foreach (var s in strings.Skip(1)) {
        res = new String(res.Where(c => !s.Contains(c)).ToArray());
    }
    return res;
}
string Sort(string s) => new String(s.ToCharArray().OrderBy(x => x).ToArray());