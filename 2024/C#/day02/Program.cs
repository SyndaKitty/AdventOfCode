var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..\\..\\..\\..\\..\\inputs\\02.txt"));
var reports = File.ReadAllLines(filePath);

for (int part = 1; part <= 2; part++)
{
    int safeCount = 0;
    foreach (var report in reports)
    { 
        var levels = report.Split(" ", StringSplitOptions.RemoveEmptyEntries).Select(int.Parse).ToList();
        if (ValidateDifferences(GetDifferences(levels)))
        {
            safeCount++;
        }
        else if (part == 2)
        {
            for (int i = 0; i < levels.Count; i++)
            {
                var newLevels = levels.ToList();
                newLevels.RemoveAt(i);
                if (ValidateDifferences(GetDifferences(newLevels)))
                {
                    safeCount++;
                    break;
                }
            }
        }
    }
    Console.WriteLine(safeCount);
}


bool ValidateDifferences(List<int> differences)
{
    return (differences.All(x => x > 0) || differences.All(x => x < 0)) && differences.All(x => Math.Abs(x) <= 3);
}

List<int> GetDifferences(List<int> values)
{
    List<int> differences = new();
    for (int i = 1; i < values.Count; i++)
    {
        int from = values[i - 1];
        int to = values[i];
        int difference = to - from;
        differences.Add(difference);
    }

    return differences;
}