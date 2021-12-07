string inputFile = @"../../inputs/07.txt";

var crabs = File.ReadAllText(inputFile).Split(",").Select(x => Convert.ToInt32(x)).ToArray();

List<int> costs1 = new List<int>();
List<int> costs2 = new List<int>();
for (int i = 0; i < crabs.Max(); i++) {
    int cost1 = 0;
    int cost2 = 0;
    for (int j = 0; j < crabs.Length; j++) {
        var diff = Math.Abs(crabs[j] - i);
        cost1 += diff;
        cost2 += (diff * diff + diff) / 2; // Triangle numbers
    }
    costs1.Add(cost1);
    costs2.Add(cost2);
}
Console.WriteLine(costs1.Min());
Console.WriteLine(costs2.Min());