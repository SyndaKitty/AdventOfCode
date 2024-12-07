using System.Linq;
using System.Net;

var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\06.txt"));
var lines = File.ReadAllLines(filePath);

HashSet<(int, int)> blocked = [];

int startX = 0;
int startY = 0;

int width = lines[0].Length;
int height = lines.Length;

int y = 0;
foreach (var line in lines)
{
    int x = 0;
    foreach (var c in line)
    {
        if (c == '#')
        {
            blocked.Add((x, y));
        }

        if (c == '^')
        {
            startX = x;
            startY = y;

        }
        x++;
    }
    y++;
}

Console.WriteLine(RunPatrol(blocked, width, height, startX, startY));
// Place obstruction in all positions and see where it breaks
int loopCount = 0;
for (y = 0; y < height; y++)
{
    for (int x = 0; x < width; x++)
    {
        if (blocked.Contains((x, y)))
        {
            continue;
        }

        blocked.Add((x, y));
        int? tileCount = RunPatrol(blocked, width, height, startX, startY);
        if (!tileCount.HasValue)
        {
            loopCount++;
        }
        blocked.Remove((x, y));
    }
}    
Console.WriteLine(loopCount);

int? RunPatrol(HashSet<(int, int)> blocked, int width, int height, int startX, int startY)
{
    // Record the headings we've been in for each position
    // if at any point we end up in the same position and heading, we're in a loop
    Dictionary<(int, int), HashSet<int>> visited = [];
    (int x, int y)[] offset = { (0, -1), (1, 0), (0, 1), (-1, 0) };
    int heading = 0;

    int posX = startX;
    int posY = startY;
    while (posX >= 0 && posX < width && posY >= 0 && posY < height)
    {
        if (visited.TryGetValue((posX, posY), out var h))
        {
            if (h.Contains(heading))
            {
                return null;
            }
            h.Add(heading);
        }
        else
        {
            visited.Add((posX, posY), new HashSet<int> { heading });
        }

        int newX = posX + offset[heading].x;
        int newY = posY + offset[heading].y;

        if (blocked.Contains((newX, newY)))
        {
            heading = (heading + 1) % 4;
        }
        else
        {
            posX = newX;
            posY = newY;
        }
    }

    return visited.Count;
}