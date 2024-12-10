var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\07.txt"));

long part1Total = 0;
long part2Total = 0;
foreach (var line in File.ReadLines(filePath))
{
    var l = line.Split(":");
    long result = long.Parse(l[0]);
    var numbers = l[1].Split(" ", StringSplitOptions.RemoveEmptyEntries).Select(int.Parse).ToList();

    if (CheckEquation(result, numbers, false))
    {
        part1Total += result;
    }
    if (CheckEquation(result, numbers, true))
    {
        part2Total += result;
    }
}
Console.WriteLine(part1Total);
Console.WriteLine(part2Total);

bool CheckEquation(long result, List<int> numbers, bool allowConcat)
{
    List<long> results = [numbers[0]]; 
    foreach (var number in numbers.Skip(1))
    {
        if (allowConcat)
        {
            results = results.SelectMany(x => new long[] {
                x * number, x + number,
                long.Parse(x.ToString() + number)
            }).ToList();
        }
        else
        {
            results = results.SelectMany(x => new long[] {
                x * number, x + number,
            }).ToList();
        }
    }
    return results.Contains(result);
}