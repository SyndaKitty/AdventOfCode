var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\16.txt")); 
var lines = File.ReadAllLines(filePath);
Dictionary<(int x, int y), char> map = [];
HashSet<(int x, int y)> visited = [];

int width = lines[0].Length;
int height = lines.Length;

for (int y = 0; y < height; y++)
{
    for (int x = 0; x < width; x++)
    {
        if (lines[y][x] != '#')
        {
            map[(x, y)] = lines[y][x];
        }
    }
}

PriorityQueue<Move, int> priorityQueue = new();
var pos = map.First(x => x.Value == 'S').Key;
priorityQueue.Enqueue(new Move((pos.x, pos.y, 0)), 0);

(int x, int y)[] directions = [(1, 0), (0, -1), (-1, 0), (0, 1)];
Dictionary<(int x, int y, int h), HashSet<(int x, int y, int h, int c)>> links = [];
Dictionary<(int x, int y, int h), int> bestCost = [];
HashSet<int> endHeadings = [];
long bestTotalCost = long.MaxValue;

while(priorityQueue.Count > 0)
{
    priorityQueue.TryPeek(out var next, out int cost);
    priorityQueue.Dequeue();    
    
    if (map.TryGetValue(next.XY, out var m))
    {
        if (!bestCost.ContainsKey(next.Pos))
        {
            bestCost[next.Pos] = cost;
        }
        else if (bestCost[next.Pos] < cost)
        {
            continue;
        }

        if (!links.ContainsKey(next.Pos))
        {
            links.Add(next.Pos, []);
        }
        else if (links[next.Pos].First().c < cost)
        {
            continue;
        }
        links[next.Pos].Add((next.From.x, next.From.y, next.From.h, cost));

        if (m == 'E')
        {
            if (cost < bestTotalCost)
            {
                bestTotalCost = cost;
                Console.WriteLine(cost);
            }
            else if (cost > bestTotalCost)
            {
                break;
            }
            endHeadings.Add(next.Pos.h);
        }
        else
        {
            var d = directions[next.Pos.h];
            priorityQueue.Enqueue(new Move(next.Pos, (next.Pos.x + d.x, next.Pos.y + d.y, next.Pos.h)), cost + 1);
            priorityQueue.Enqueue(new Move(next.Pos, (next.Pos.x, next.Pos.y, Mod(next.Pos.h + 1, 4))), cost + 1000);
            priorityQueue.Enqueue(new Move(next.Pos, (next.Pos.x, next.Pos.y, Mod(next.Pos.h - 1, 4))), cost + 1000);
        }
    }
}

HashSet<(int x, int y)> bestPath = [];
Queue<(int x, int y, int h)> bestPathQueue = new();
var endPos = map.First(x => x.Value == 'E').Key;
var endLocations = links.Where(x => x.Key.x == endPos.x && x.Key.y == endPos.y && endHeadings.Contains(x.Key.h));

for (int y = 0; y < height; y++)
{
    for (int x = 0; x < width; x++)
    {
        bool found = false;
        for (int i = 0; i < 4; i++)
        {
            if (links.ContainsKey((x, y, i)))
            {
                found = true;
            }
        }
        Console.Write(found ? "O" : " ");
    }
    Console.WriteLine();
}

foreach (var end in endLocations)
{
    bestPathQueue.Enqueue(end.Key);
}

while (bestPathQueue.Count > 0)
{
    var next = bestPathQueue.Dequeue();
    if (!bestCost.ContainsKey(next)) continue;

    bestPath.Add((next.x, next.y));
    if (links.TryGetValue(next, out var from))
    {
        foreach (var f in from)
        {
            bestPathQueue.Enqueue((f.x, f.y, f.h));
        }
    }
}

Console.WriteLine(bestPath.Count);

int Mod(int a, int b) => (a % b + b) % b;

struct Move
{
    public (int x, int y, int h) From;
    public (int x, int y, int h) Pos;

    public (int x, int y) XY => (Pos.x, Pos.y);

    public Move((int x, int y, int h) from, (int x, int y, int h) to)
    {
        Pos = to;
        From = from;
    }

    public Move((int x, int y, int h) pos)
    {
        Pos = pos;
        From = (-1, -1, -1);
    }
}