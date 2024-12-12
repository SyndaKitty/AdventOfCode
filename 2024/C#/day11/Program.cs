var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\11.txt"));
var numbers = File.ReadAllText(filePath).Split(" ").Select(long.Parse).ToList();
Dictionary<(long, int), long> memo = [];

Console.WriteLine(numbers.Select(x => BlinkMemoized(x, 25)).Sum());
Console.WriteLine(numbers.Select(x => BlinkMemoized(x, 75)).Sum());

long BlinkMemoized(long num, int iterations)
{
    if (iterations == 0) return 1;

    var key = (num, iterations);
    if (memo.ContainsKey(key))
    {         
        return memo[key];
    }

    long res = 0;

    string str = num.ToString();
    if (num == 0)
    {
        res = BlinkMemoized(1, iterations - 1);
    }
    else if (str.Length % 2 == 0)
    {
        res += BlinkMemoized(long.Parse(str.Substring(0, str.Length / 2)), iterations - 1);
        res += BlinkMemoized(long.Parse(str.Substring(str.Length / 2)), iterations - 1);
    }
    else return BlinkMemoized(num * 2024, iterations - 1);

    memo.Add(key, res);

    return res;
}