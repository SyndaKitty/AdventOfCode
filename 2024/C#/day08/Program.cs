
var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\08.txt")); 
var lines = File.ReadAllLines(filePath);

int width = lines[0].Length;
int height = lines.Length;

Dictionary<char, List<(int x, int y)>> antennas = [];

int y = 0;
foreach (var line in lines)
{
    int x = 0;
    foreach (var c in line)
    {
        if (c != '.')
        {
            if (!antennas.ContainsKey(c))
            {
                antennas.Add(c, []);
            }
            antennas[c].Add((x, y));
        }
        x++;
    }
    y++;
}

HashSet<(int, int)> antinodesPart1 = [];
HashSet<(int, int)> antinodesPart2 = [];

foreach (var kvp in antennas)
{
    char frequency = kvp.Key;
    List<(int x, int y)> positions = kvp.Value;

    // Get every pair of positions
    for (int i = 0; i < positions.Count; i++)
    {
        for (int j = i + 1; j < positions.Count; j++)
        {
            var pos1 = positions[i];
            var pos2 = positions[j];
            CalcAntinodes1(pos1, pos2, antinodesPart1);
            CalcAntinodes2(pos1, pos2, antinodesPart2);
        }
    }
}

Console.WriteLine(antinodesPart1.Count);
Console.WriteLine(antinodesPart2.Count);

void CalcAntinodes1((int x, int y) pos1, (int x, int y) pos2, HashSet<(int, int)> antinodes)
{
    (int x, int y) delta = (pos2.x - pos1.x, pos2.y - pos1.y);
    var a1 = (pos2.x + delta.x, pos2.y + delta.y);
    var a2 = (pos1.x - delta.x, pos1.y - delta.y);

    if (CheckPos(a1)) antinodes.Add(a1);
    if (CheckPos(a2)) antinodes.Add(a2);
}

void CalcAntinodes2((int x, int y) pos1, (int x, int y) pos2, HashSet<(int, int)> antinodes)
{
    (int x, int y) delta = (pos2.x - pos1.x, pos2.y - pos1.y);
    for (int i = -width; i <= width; i++)
    {
        var a = (pos1.x + i * delta.x, pos1.y + i * delta.y);
        if (CheckPos(a)) antinodes.Add(a);
    }
}

bool CheckPos((int x, int y) pos)
{
    return pos.x >= 0 && pos.x < width && pos.y >= 0 && pos.y < height;
}