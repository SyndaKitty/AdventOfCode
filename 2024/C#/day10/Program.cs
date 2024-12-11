var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\10.txt")); 
var lines = File.ReadAllLines(filePath);

int width = lines[0].Length;
int height = lines.Length;

Dictionary<(int, int), int> map = [];

int y = 0;
foreach (var line in lines)
{
    int x = 0;
    foreach (var c in line)
    {
        map.Add((x, y), int.Parse(c.ToString()));
        x++;
    }
    y++;
}

for (int part = 1; part <= 2; part++)
{
    int total = 0;
    for (y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
            if (map[(x, y)] == 0)
            {
                total += Pathfind(x, y, map, part == 1);
            }
        }
    }
    Console.WriteLine(total);
}


int Pathfind(int startX, int startY, Dictionary<(int, int), int> map, bool part1)
{
    (int dx, int dy)[] directions = { (1, 0), (0, 1), (-1, 0), (0, -1) };

    List<(int x, int y)> trails = [(startX, startY)];
    
    for (int level = 1; level <= 9; level++)
    {
        var newTrails = new List<(int x, int y)>();
        foreach (var trail in trails)
        {
            foreach (var dir in directions)
            {
                var nx = trail.x + dir.dx;
                var ny = trail.y + dir.dy;
                if (nx < 0 || nx >= width || ny < 0 || ny >= height)
                {
                    continue;
                }
                if (map[(nx, ny)] == level)
                {
                    newTrails.Add((nx, ny));
                }
            }
        }
        trails = newTrails;
    }
    if (part1) 
        return trails.ToHashSet().Count();
    return trails.Count();
}