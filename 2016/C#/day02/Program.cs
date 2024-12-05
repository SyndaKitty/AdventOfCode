var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\02.txt"));

var keypad1 =
@"123
456
789";

var keypad2 =
@"
  1
 234
56789
 ABC
  D
";

var directions = new Dictionary<char, (int x, int y)>
{
    { 'U', (0, -1) },
    { 'D', (0, 1) },
    { 'L', (-1, 0) },
    { 'R', (1, 0) }
};

var keypad = GetKeypad(keypad1);
int x = 1;
int y = 1;

for (int part = 1; part <= 2; part++)
{
    if (part == 2)
    {         
        keypad = GetKeypad(keypad2);
        x = 2;
        y = 2;
    }  
    foreach (var line in File.ReadLines(filePath))
    {
        foreach (var c in line)
        {
            (int xx, int yy) = (x + directions[c].x, y + directions[c].y);
            if (keypad.ContainsKey((xx, yy)))
            {
                x = xx;
                y = yy;
            }
        }
        Console.Write(keypad[(x, y)]);
    }
    Console.WriteLine();
}

Dictionary<(int, int), char> GetKeypad(string keypad)
{
    Dictionary<(int, int), char> lookup = [];

    int y = 0;
    foreach (var line in keypad.Replace("\r","").Split("\n"))
    {
        int x = 0;
        foreach (var c in line)
        {
            if (c != ' ')
            {
                lookup.Add((x, y), c);
            }
            x++;
        }
        y++;
    }

    return lookup;
}