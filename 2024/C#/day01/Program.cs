
var lines = File.ReadAllLines("../../inputs/01.txt");

var listA = new List<int>();
var listB = new List<int>();

foreach (var line in lines)
{
    var nums = line.Split(" ", StringSplitOptions.RemoveEmptyEntries).Select(int.Parse).ToList();
    listA.Add(nums[0]);
    listB.Add(nums[1]);
}

listA.Sort();
listB.Sort();

int total = 0;

for (int i = 0; i < listA.Count; i++)
{
    int distance = Math.Abs(listB[i] - listA[i]);
    total += distance;
}

Console.WriteLine(total);

// Part 2
int similarityScore = 0;
for (int i = 0; i < listA.Count; i++)
{
    similarityScore += listA[i] * listB.Count(x => x == listA[i]);
}

Console.WriteLine(similarityScore);