string inputFile = @"../../inputs/11.txt";
var input = File.ReadAllText(inputFile);
var lines = File.ReadAllLines(inputFile);

int height = lines.Length;
int width = lines[0].Length;
Dictionary<(int,int),int> energy = new Dictionary<(int, int), int>();

int y = 0;
foreach (var line in lines) {
    int x = 0;
    foreach (var c in line) {
        energy[(x,y)] = Convert.ToInt32(c.ToString());
        x++;
    }
    y++;
}

var neighbors = new (int,int)[] {
    (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)
};


int flashes = 0;
for (int i = 1;; i++) {
    var over9 = new Queue<(int,int)>();
    var flashed = new List<(int, int)>();
    
    for (y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            var key = (x,y);
            energy[key] += 1;
            if (energy[key] > 9) {
                over9.Enqueue(key);
            }
        }
    }
    while (over9.Count > 0) {
        var pos = over9.Dequeue();
        flashes++;
        flashed.Add(pos);
        foreach (var n in neighbors) {
            var neighbor = (n.Item1 + pos.Item1, n.Item2 + pos.Item2);
            if (neighbor.Item1 < 0 || neighbor.Item1 >= width || neighbor.Item2 < 0 || neighbor.Item2 >= height) {
                continue;
            }
            energy[neighbor]++;
            if (energy[neighbor] == 10) {
                over9.Enqueue(neighbor);
            }
        }
    }
    foreach (var pos in flashed) {
        energy[pos] = 0;
    }
    if (i == 100) {
        Console.WriteLine(flashes);
    }
    if (flashed.Count == width * height) {
        Console.WriteLine(i);
        return;
    }
}