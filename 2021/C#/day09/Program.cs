string inputFile = @"../../inputs/09.txt";

var input = File.ReadAllText(inputFile);
var lines = File.ReadAllLines(inputFile);


Dictionary<(int,int),int> points = new Dictionary<(int, int), int>();
int y = 0;
foreach (var line in lines) {
    int x = 0;
    foreach (var c in line) {
        points[(x,y)] = Convert.ToInt32(c.ToString());
        x++;
    }
    y++;
}

int width = lines[0].Length;
int height = lines.Length;

int GetPoint(Dictionary<(int,int),int> points, int x, int y, int w, int h) {
    if (x < 0 || x >= width) {
        return 10;
    }
    if (y < 0 || y >= height) {
        return 10;
    }
    // Console.WriteLine(x + " " + y + " " + points[(x,y)]);
    return points[(x,y)];
}

var risk = 0;
for (y = 0; y < lines.Length; y++) {
    for (int x = 0; x < lines[0].Length; x++) {
        var left = GetPoint(points, x-1,y, width, height);
        var right = GetPoint(points, x+1,y, width, height);
        var up = GetPoint(points, x,y+1, width, height);
        var down = GetPoint(points, x,y-1, width, height);
        var val = GetPoint(points, x,y, width, height);

        if (val < left && val < right && val < up && val < down) {
            risk += 1 + val;
        }
    }
}

Console.WriteLine(risk);

var neighbors = new List<(int,int)> {
    (-1, 0),
    (1, 0),
    (0, 1),
    (0, -1),
};

List<List<(int,int)>> basins = new List<List<(int, int)>>();
Queue<(int,int)> toVisit = new Queue<(int, int)>();
HashSet<(int,int)> visited = new HashSet<(int,int)>();

for (y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
        if (visited.Contains((x,y)) || GetPoint(points, x, y, width, height) >= 9) {
            continue;
        }
       
        toVisit.Enqueue((x,y));
        var basin = new List<(int,int)>();

        while (toVisit.Count > 0) {
            var pos = toVisit.Dequeue();
            
            visited.Add(pos);
            basin.Add(pos);
            
            foreach (var n in neighbors) {
                var neighbor = (pos.Item1 + n.Item1, pos.Item2 + n.Item2);
                var nval = GetPoint(points, neighbor.Item1, neighbor.Item2, width, height);

                if (!visited.Contains(neighbor) && nval < 9) {
                    toVisit.Enqueue(neighbor);
                    visited.Add(neighbor);
                }
            }
        }
        basins.Add(basin);
    }
}

int count = 1;
var top3 = basins.OrderByDescending(b => b.Count).Take(3);
foreach (var b in top3) {
    count *= b.Count;
}

Console.WriteLine(count);