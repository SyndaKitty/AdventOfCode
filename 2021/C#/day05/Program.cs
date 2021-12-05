string inputFile = @"../../inputs/05.txt";
var input = File.ReadAllText(inputFile);
var lines = File.ReadAllLines(inputFile);

// For part 1 and 2 respectively
Dictionary<(int,int), int> grid1 = new Dictionary<(int, int), int>();
Dictionary<(int,int), int> grid2 = new Dictionary<(int, int), int>();

foreach (var line in lines) {
    string[] words = line.Split(" ");
    int x1 = Convert.ToInt32(words[0].Split(",")[0]);
    int y1 = Convert.ToInt32(words[0].Split(",")[1]);
    int x2 = Convert.ToInt32(words[2].Split(",")[0]);
    int y2 = Convert.ToInt32(words[2].Split(",")[1]);

    if (x1 == x2 || y1 == y2) {
        for (int x = Math.Min(x1, x2); x <= Math.Max(x1, x2); x++) {
            for (int y = Math.Min(y1, y2); y <= Math.Max(y1, y2); y++) {
                if (!grid1.ContainsKey((x,y))) {
                    grid1.Add((x,y), 0);
                }
                if (!grid2.ContainsKey((x,y))) {
                    grid2.Add((x,y), 0);
                }
                grid1[(x,y)] += 1;
                grid2[(x,y)] += 1;
            }
        }
    }
    else {
        int x = x1;
        int y = y1;
        int length = Math.Abs(x1 - x2);
        int dx = Math.Sign(x2 - x1);
        int dy = Math.Sign(y2 - y1);
        for (int i = 0; i <= length; i++) {
            if (!grid2.ContainsKey((x,y))) {
                grid2.Add((x,y), 0);
            }
            grid2[(x,y)] += 1;
            x += dx;
            y += dy;
        }
    }
}
int count = 0;
foreach (var kvp in grid1) {
    if (kvp.Value > 1) {
        count++;
    }
}
Console.WriteLine(count);
count = 0;
foreach (var kvp in grid2) {
    if (kvp.Value > 1) {
        count++;
    }
}
Console.WriteLine(count);