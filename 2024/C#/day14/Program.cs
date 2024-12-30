using System.Text;

var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\14.txt"));
var lines = File.ReadAllLines(filePath).ToList();
List<Robot> robots = [];

long Width = 101;
long Height = 103;

foreach (var line in lines)
{
    var parts = line.Replace("p=", "").Replace("v=", "").Split(" ");
    robots.Add(new Robot {
        X = long.Parse(parts[0].Split(",")[0]),
        Y = long.Parse(parts[0].Split(",")[1]),
        Vx = long.Parse(parts[1].Split(",")[0]),
        Vy = long.Parse(parts[1].Split(",")[1])
    });
}

HashSet<(long, long)> robotPresent = [];

for (int i = 1;; i++)
{
    bool duplicate = false;
    foreach (var robot in robots)
    {
        robot.Move(Width, Height);
        if (robotPresent.Contains((robot.X, robot.Y)))
        {
            duplicate = true;
        }
        robotPresent.Add((robot.X, robot.Y));
    }
    robotPresent.Clear();

    if (i == 100)
    {
        Console.WriteLine(GetSafetyFactor(Width, Height, robots));
    }
    
    // A bit of a hack, when the tree shows, no robots share a position
    if (!duplicate)
    {
        Console.WriteLine(i);
        break;
    }
}

StringBuilder PrintRobots(List<Robot> robots, long width, long height)
{
    StringBuilder buffer = new();

    for (int y = 0; y < Height; y++)
    {
        for (int x = 0; x < Width; x++)
        {
            buffer.Append(robotPresent.Contains((x, y)) ? "#" : ".");
        }
        buffer.AppendLine();
    }

    return buffer;
}

long GetSafetyFactor(long width, long height, List<Robot> robots)
{
    long[] quadrantCounts = new long[4];

    long hw = width / 2;
    long hh = height / 2;

    foreach (var robot in robots)
    {
        if (robot.X == hw || robot.Y == hh)
        {
            continue;
        }

        int quadrant = 0;
        quadrant += robot.X < hw ? 0 : 1;
        quadrant += robot.Y < hh ? 0 : 2;

        quadrantCounts[quadrant]++;
    }

    return quadrantCounts[0] * quadrantCounts[1] * quadrantCounts[2] * quadrantCounts[3];
}

class Robot
{
    public long X;
    public long Y;
    public long Vx;
    public long Vy;

    public void Move(long width, long height)
    {
        X = Mod(X + Vx, width);
        Y = Mod(Y + Vy, height);
    }

    long Mod(long a, long b)
    {
        return (a % b + b) % b;
    }
}