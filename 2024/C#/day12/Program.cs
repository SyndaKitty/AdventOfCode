using System.Linq;

var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\12.txt"));
var lines = File.ReadAllLines(filePath);

Dictionary<(int, int), char> map = [];

int width = lines[0].Length;
int height = lines.Length;

// Read in map
for (int y = 0; y < height; y++)
{
    for (int x = 0; x < width; x++)
    {
        map[(x, y)] = lines[y][x];
    }
}

HashSet<(int, int)> recorded = [];
(int x, int y)[] directions = [(0, 1), (1, 0), (0, -1), (-1, 0)];

 
long total = 0;
long total2 = 0;
for (int y = 0; y < height; y++)
{
    for (int x = 0; x < width; x++)
    {
        var key = (x, y);
        if (recorded.Contains(key))
        {
            continue;
        }

        var area = FloodFill(x, y, map, recorded);
        total += GetArea(area) * GetPerimeter(area);
        total2 += GetArea(area) * GetSides(area);
    }
}

Console.WriteLine(total);
Console.WriteLine(total2);

// Return a list of all cells connected to the starting cell, mark all visited cells in the recorded set
List<(int, int)> FloodFill(int x, int y, Dictionary<(int, int), char> map, HashSet<(int x, int y)> recorded)
{
    Queue<(int x, int y)> toVisit = new();
    List<(int, int)> area = new();
    
    toVisit.Enqueue((x, y));
    char expected = map[(x, y)];
    
    while (toVisit.Count > 0)
    {
        var nextPos = toVisit.Dequeue();
        if (recorded.Contains(nextPos))
        {
            continue;
        }
        var type = map[nextPos];
        
        area.Add(nextPos);
        recorded.Add(nextPos);
        foreach (var dir in directions)
        {
            var newPos = (nextPos.x + dir.x, nextPos.y + dir.y);
            if (newPos.Item1 < 0 || newPos.Item1 >= width || newPos.Item2 < 0 || newPos.Item2 >= height)
            {
                continue;
            }
            if (recorded.Contains(newPos) || map[newPos] != expected)
            {
                continue;
            }
            toVisit.Enqueue(newPos);
        }
    }
    return area;
}

// Get the perimeter of a list of cells
long GetPerimeter(List<(int, int)> a)
{
    var area = a.ToHashSet();
    long total = 0;
    for (int y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
            if (!area.Contains((x, y))) continue;

            foreach (var dir in directions)
            {
                var newPos = (x + dir.x, y + dir.y);
                if (area.Contains(newPos)) continue;
                total++;
            }
        }
    }
    return total;
}

long GetSides(List<(int x, int y)> a)
{
    var area = a.ToHashSet();
    

    HashSet<(int d, int x, int y)> edges = [];

    for (int i = 0; i < directions.Length; i++)
    {
        var dir = directions[i];
        foreach (var cell in area)
        {
            (int x, int y) newCell = (cell.x + dir.x, cell.y + dir.y);
            if (area.Contains(newCell))
            {
                continue;
            }

            edges.Add((i, cell.x, cell.y));
        }
    }

    HashSet<(int d, int x, int y)> visitedEdges = [];

    // Move along each edge using flood fill to determine number of unique sides
    long count = 0;
    foreach (var edge in edges)
    {
        if (visitedEdges.Contains(edge))
        {
            continue;
        }

        count++;

        // Move parallel to the recorded direction
        var pdir = directions[(edge.d + 1) % 4];
        for (int i = 1; i < width; i++)
        {
            var newEdge = (edge.d, edge.x + pdir.x * i, edge.y + pdir.y * i);
            if (edges.Contains(newEdge))
            {
                visitedEdges.Add(newEdge);
            }
            else
            {
                break;
            }
        }
        
        for (int i = -1; i > -width; i--)
        {
            var newEdge = (edge.d, edge.x + pdir.x * i, edge.y + pdir.y * i);
            if (edges.Contains(newEdge))
            {
                visitedEdges.Add(newEdge);
            }
            else
            {
                break;
            }
        }
    }

    return count;
}

long GetArea(List<(int, int)> area)
{
    return area.Count;
}
