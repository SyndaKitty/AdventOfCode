var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\05.txt"));
var parts = File.ReadAllText(filePath).Replace("\r", "").Split("\n\n");

var rulesRaw = parts[0].Split("\n").Select(x => x.Split("|").Select(int.Parse).ToList()).ToList();
var rules = new List<(int, int)>();
foreach (var r in rulesRaw)
{
    rules.Add((r[0], r[1]));
}

int total = 0;
int total2 = 0;
foreach (var line in parts[1].Split("\n"))
{
    var nums = line.Split(",").Select(int.Parse).ToList();
    if (CheckRules(nums, rules))
    {
        total += nums[nums.Count / 2];
    }
    else
    {
        // Reconstruct the list by adding the numbers in each possible position and rechecking the rules
        // This is not very efficient but it works for the input size
        List<int> corrected = [];
        for (int i = 0; i < nums.Count; i++)
        {
            List<int> nextIteration = corrected.ToList();
            for (int j = 0; j <= nextIteration.Count; j++)
            {
                nextIteration.Insert(j, nums[i]);
                if (!CheckRules(nextIteration, rules))
                {
                    nextIteration.RemoveAt(j);
                }
                else
                {
                    corrected = nextIteration.ToList();
                    break;
                }
            }
        }
        total2 += corrected[corrected.Count / 2];
    }
}

Console.WriteLine(total);
Console.WriteLine(total2);

bool CheckRules(List<int> line, List<(int, int)> rules)
{
    foreach (var rule in rules)
    {
        if (line.Contains(rule.Item1) && line.Contains(rule.Item2))
        {
            int pos1 = line.IndexOf(rule.Item1);
            int pos2 = line.IndexOf(rule.Item2);
            if (pos2 < pos1)
            {
                return false;
            }
        }
    }
    return true;
}