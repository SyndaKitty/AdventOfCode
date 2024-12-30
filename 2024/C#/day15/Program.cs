
using System.Text;

var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\15.txt"));
var text = File.ReadAllText(filePath).Replace("\r", "");

var parts = text.Split("\n\n");
var mapDesc = parts[0];
var mapLines = mapDesc.Split("\n");
var movesDesc = parts[1];

Dictionary<(int x, int y), Cell> map = [];
List<Move> moves = [];
(int x, int y)[] delta = [(0, -1), (0, 1), (-1, 0), (1, 0)];

int width = mapLines[0].Length;
int height = mapLines.Length;

for (int y = 0; y < height; y++)
{
    for (int x = 0; x < width; x++)
    {
        Cell c = CharToCell(mapLines[y][x]);
        if (c != Cell.Empty)
        {
            map[(x, y)] = c;
        }
    }
}

var part2Map = WidenMap(map);

foreach (var c in movesDesc)
{
    if (c == '\n')
        continue;
    moves.Add(CharToMove(c));
}

ApplyMoves(moves, map, false);
ApplyMoves(moves, part2Map, true);

Console.WriteLine(GPSScore(map));
Console.WriteLine(GPSScore(part2Map));

void ApplyMoves(List<Move> moves, Dictionary<(int x, int y), Cell> map, bool wide)
{
    int w = wide ? width * 2 : width;
    int h = height;
    (int x, int y) robotPos = map.First(kvp => kvp.Value == Cell.Robot).Key;

    foreach (var move in moves)
    {
        bool verticalMove = move == Move.Up || move == Move.Down;
        var d = delta[(int)move];
        (int x, int y) newPos = (robotPos.x + d.x, robotPos.y + d.y);

        bool validMove = true;

        List<(int x, int y)> blocks = [];
        Queue<(int x, int y)> potentialObstacles = [];
        potentialObstacles.Enqueue(newPos);

        while (potentialObstacles.Any())
        {
            var checkPos = potentialObstacles.Dequeue();
            if (map.TryGetValue(checkPos, out var obstacle))
            {
                if (obstacle == Cell.Wall)
                {
                    validMove = false;
                    break;
                }
                else if (obstacle == Cell.Box || obstacle == Cell.BoxRight)
                {
                    if (!blocks.Contains(checkPos))
                    {
                        blocks.Add(checkPos);
                    }
                    
                    potentialObstacles.Enqueue((checkPos.x + d.x, checkPos.y + d.y));

                    if (wide && verticalMove)
                    {
                        if (obstacle == Cell.Box)
                        {
                            var blockPos = (checkPos.x + 1, checkPos.y);
                            if (!blocks.Contains(blockPos))
                            {
                                blocks.Add(blockPos);
                            }
                            potentialObstacles.Enqueue((checkPos.x + d.x + 1, checkPos.y + d.y));
                        }
                        else
                        {
                            var blockPos = (checkPos.x - 1, checkPos.y);
                            if (!blocks.Contains(blockPos))
                            {
                                blocks.Add(blockPos);
                            }
                            potentialObstacles.Enqueue((checkPos.x + d.x - 1, checkPos.y + d.y));
                        }
                    }
                }
            }
        }

        // Execute the move
        if (validMove)
        {
            for (int i = blocks.Count - 1; i >= 0; i--)
            {
                var block = blocks[i];
                var boxType = map[block];
                map.Remove(block);
                map[(block.x + d.x, block.y + d.y)] = boxType;
            }
            map.Remove(robotPos);
            map[newPos] = Cell.Robot;
            robotPos = newPos;
        }
    }
}

long GPSScore(Dictionary<(int x, int y), Cell> map)
{
    long total = 0;
    foreach (var kvp in map)
    {
        var pos = kvp.Key;
        var cell = kvp.Value;
        if (cell != Cell.Box) continue;
        total += pos.y * 100 + pos.x;
    }

    return total;
}

Dictionary<(int x, int y), Cell> WidenMap(Dictionary<(int x, int y), Cell> map)
{
    Dictionary<(int, int), Cell> newMap = [];
    foreach (var kvp in map)
    {
        newMap.Add((kvp.Key.x * 2, kvp.Key.y), kvp.Value);
        if (kvp.Value == Cell.Box)
        {
            newMap.Add((kvp.Key.x * 2 + 1, kvp.Key.y), Cell.BoxRight);
        }
        else if (kvp.Value != Cell.Robot)
        {
            newMap.Add((kvp.Key.x * 2 + 1, kvp.Key.y), kvp.Value);
        }
    }

    return newMap;
}

StringBuilder PrintMap(Dictionary<(int, int), Cell> map, int width, int height, bool wide)
{
    StringBuilder sb = new();
    for (int y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
            if (map.TryGetValue((x, y), out var cell))
            {
                sb.Append(cell switch {
                    Cell.Empty => '.',
                    Cell.Wall => '#',
                    Cell.Box => wide ? '[' : 'O',
                    Cell.BoxRight => ']',
                    Cell.Robot => '@',
                    _ => throw new NotImplementedException()
                });
            }
            else
            {
                sb.Append('.');
            }
        }
        sb.AppendLine();
    }
    return sb;
}

Cell CharToCell(char c)
{
    return c switch {
        '.' => Cell.Empty,
        '#' => Cell.Wall,
        'O' => Cell.Box,
        '@' => Cell.Robot,
        _ => throw new NotImplementedException()
    };
}

Move CharToMove(char c)
{
    return c switch {
        '^' => Move.Up,
        'v' => Move.Down,
        '<' => Move.Left,
        '>' => Move.Right,
        _ => throw new NotImplementedException()
    };
}

enum Cell
{
    Empty,
    Wall,
    Box,
    BoxRight,
    Robot
}

enum Move
{
    Up,
    Down,
    Left,
    Right
}