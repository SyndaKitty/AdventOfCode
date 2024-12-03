var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\01.txt"));
var text = File.ReadAllText(filePath);
var directions = text.Split(", ").ToList();

for (int part = 1; part <= 2; part++)
{
    int x = 0;
    int y = 0;
    int heading = 0; // 0 = N, 1 = E, 2 = S, 3 = W
    HashSet<(int,int)> visited = new();
    foreach (var direction in directions)
    {
        var turn = direction[0];
        var distance = int.Parse(direction.Substring(1));

        if (turn == 'R')
        {
            heading++;
        }
        else
        {
            heading--;
        }

        heading = mod(heading, 4);

        for (int i = 0; i < distance; i++)
        {
            switch (heading)
            {
                case 0:
                    y++;
                    break;
                case 1:
                    x++;
                    break;
                case 2:
                    y--;
                    break;
                case 3:
                    x--;
                    break;
            }
            if (visited.Contains((x,y)) && part == 2)
            {
                Console.WriteLine(Math.Abs(x) + Math.Abs(y));
                return;
            }
            visited.Add((x, y));
        }

    }
    if (part == 1)
    {
        Console.WriteLine(Math.Abs(x) + Math.Abs(y));
    }
}

int mod(int val, int div) => (val % div + div) % div;