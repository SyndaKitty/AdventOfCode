string inputFile = @"../../inputs/05.txt";
var input = File.ReadAllText(inputFile);
var lines = File.ReadAllLines(inputFile);

for (int pt = 1; pt <= 2; pt++) {
    Dictionary<(int,int), int> grid = new Dictionary<(int, int), int>();
    
    foreach (var line in lines) {
        string[] words = line.Split(" ");
        int x1 = Convert.ToInt32(words[0].Split(",")[0]);
        int y1 = Convert.ToInt32(words[0].Split(",")[1]);
        int x2 = Convert.ToInt32(words[2].Split(",")[0]);
        int y2 = Convert.ToInt32(words[2].Split(",")[1]);

        if (pt == 2 || (x1 == x2 || y1 == y2)) {
            int x = x1;
            int y = y1;
            for (int i = 0; i <= Math.Max(Math.Abs(x2-x1), Math.Abs(y2-y1)); i++) {
                if (!grid.ContainsKey((x,y))) {
                    grid.Add((x,y), 0);
                }
                grid[(x,y)] += 1;
                x += Math.Sign(x2 - x1);
                y += Math.Sign(y2 - y1);
            }
        }
    }
    
    int count = 0;
    foreach (var kvp in grid) {
        if (kvp.Value > 1) {
            count++;
        }
    }
    Console.WriteLine(count);
}