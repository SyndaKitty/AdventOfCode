var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\03.txt")); 
var lines = File.ReadAllLines(filePath);

int count = 0;
foreach (var line in lines)
{
    var nums = line.Split(' ', StringSplitOptions.RemoveEmptyEntries).Select(int.Parse).ToList();
    if (IsTriangle(nums[0], nums[1], nums[2]))
    {
        count++;
    }
}

Console.WriteLine(count);

var array = lines.Select(l => l.Split(' ', StringSplitOptions.RemoveEmptyEntries).Select(int.Parse).ToList()).ToList();
for (int j = 0; j < 3; j++)
{
    for (int i = 0; i < array.Count / 3; i++)
    {
        Console.WriteLine(i * 3 + " " + j);
        if (IsTriangle(array[i * 3][j], array[i * 3 + 1][j], array[i * 3 + 2][j]))
        {
            count++;
        }
        Console.WriteLine();
    }
}
Console.WriteLine(count);

bool IsTriangle(int a, int b, int c)
{
    return a < b + c && b < a + c && c < a + b;
}