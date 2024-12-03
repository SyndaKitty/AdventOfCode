var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..\\..\\..\\..\\..\\inputs\\24.txt"));
var packages = File.ReadAllLines(filePath).Select(int.Parse).OrderDescending().ToList();

Dictionary<int, int> maxRemaining = new();
for (int i = 0; i < packages.Count; i++)
{
    maxRemaining.Add(packages[i], packages.Skip(i).Sum());
}

int totalWeight = packages.Sum();
long lowestQE = long.MaxValue;

for (int part = 1; part <= 2; part++)
{
    int groupCount = part == 1 ? 3 : 4;
    int groupWeight = totalWeight / groupCount;


    lowestQE = long.MaxValue;
    GetMinGrouping(packages, groupWeight, 1);
    Console.WriteLine(lowestQE);
}


void GetMinGrouping(List<int> pickFrom, int remainder, long qe, int level = 0)
{
    foreach (var pick in pickFrom)
    {
        long newQe = qe * pick;
        if (pick > remainder)
        {
            continue;
        }
        if (newQe >= lowestQE)
        {
            continue;
        }
        if (maxRemaining[pick] < remainder)
        {
            continue;
        }

        if (pick == remainder)
        {
            lowestQE = newQe;
            return;
        }
        else
        {
            var newPickFrom = pickFrom.ToList();
            newPickFrom.Remove(pick);
            GetMinGrouping(newPickFrom, remainder - pick, newQe, level + 1);
        }
    }
}