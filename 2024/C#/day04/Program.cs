var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..\\..\\..\\..\\..\\inputs\\04.txt"));

Dictionary<(int, int), char> search = new();

var lines = File.ReadAllLines(filePath);
int row = 0;
foreach (var line in lines)
{
    int col = 0;
    foreach (var c in line)
    {
        search[(col, row)] = c;
        col++;
    }
    row++;
}

int width = lines[0].Length;
int height = row;

for (int part = 1; part <= 2; part++)
{
    int found = 0;
    for (int y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
            if (part == 1 && search[(x, y)] == 'X')
            {
                found += XmasSearch(x, y,  1,  0, width, height, search);
                found += XmasSearch(x, y,  1,  1, width, height, search);
                found += XmasSearch(x, y,  0,  1, width, height, search);
                found += XmasSearch(x, y, -1,  1, width, height, search);
                found += XmasSearch(x, y, -1,  0, width, height, search);
                found += XmasSearch(x, y, -1, -1, width, height, search);
                found += XmasSearch(x, y,  0, -1, width, height, search);
                found += XmasSearch(x, y,  1, -1, width, height, search);
            }
            else if (part == 2 && search[(x, y)] == 'A')
            {
                found += X_MasSearch(x, y, width, height, search);
            }
        }
    }

    Console.WriteLine(found);
}

int XmasSearch(int x, int y, int dx, int dy, int w, int h, Dictionary<(int,int), char> search)
{
    string word = "XMAS";
    for (int i = 0; i < 4; i++)
    {
        int xx = x + dx * i;
        int yy = y + dy * i;
        if (Get(search, xx, yy) != word[i])
        {
            return 0;
        }
    }
    return 1;
}

int X_MasSearch(int x, int y, int w, int h, Dictionary<(int, int), char> search)
{
    char topLeft = Get(search, x - 1, y - 1);
    char bottomRight = Get(search, x + 1, y + 1);
    char topRight = Get(search, x + 1, y - 1);
    char bottomLeft = Get(search, x - 1, y + 1);

    var match = new[] { ('M', 'S'), ('S', 'M') };
    if (match.Contains((topLeft, bottomRight)) && match.Contains((bottomLeft, topRight)))
    {
        return 1;
    }
    return 0;
}


char Get(Dictionary<(int, int), char> search, int x, int y)
{
    if (search.TryGetValue((x, y), out char c))
    {
        return c;
    }
    return ' ';
}