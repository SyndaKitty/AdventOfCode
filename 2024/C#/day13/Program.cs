using System.Diagnostics;

var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\13.txt"));
Dictionary<(long remainder, long divisor, long jumpReduction), long> RemainderJumpMemo = [];
var machines = File.ReadAllText(filePath).Replace("\r", "").Split("\n\n");
long total1 = 0;
long total2 = 0;
long total3 = 0;
foreach (var machineDesc in machines)
{
    var machine = ParseMachine(machineDesc);
    total1 += SolveMachinePart1(machine);
    //total2 += SolveMachinePart2(machine);
    total3 += SolveMachinePart2Again(machine);
    //Console.WriteLine(total2);
}

Console.WriteLine(total1);
Console.WriteLine(total3);

Machine ParseMachine(string machineDescription)
{
    var lines = machineDescription.Split("\n");
    var machine = new Machine {
        A = ParseNumbers(lines[0]),
        B = ParseNumbers(lines[1]),
        Prize = ParseNumbers(lines[2])
    };

    return machine;
}

(int, int) ParseNumbers(string buttonDesc)
{
    var vals = buttonDesc.Substring(buttonDesc.IndexOf(":") + 1);
    List<string> replaceChars = [" ", "X", "Y", "+", "="];
    foreach (var c in replaceChars)
    {
        vals = vals.Replace(c, "");
    }

    var nums = vals.Split(",").Select(int.Parse).ToList();
    return (nums[0], nums[1]);
}

const int ACost = 3;
const int BCost = 1;
const int MaxDepth = 100;

long SolveMachinePart1(Machine machine)
{
    long cost = long.MaxValue;

    for (int a = 0; a < MaxDepth; a++)
    {
        for (int b = 0; b < MaxDepth; b++)
        {
            (long x, long y) pos = (machine.A.x * a + machine.B.x * b, machine.A.y * a + machine.B.y * b);
            if (pos == machine.Prize)
            {
                cost = Math.Min(cost, a * ACost + b * BCost);
            }
        }
    }

    if (cost == long.MaxValue)
    {
        return 0;
    }
    return cost;
}

long SolveMachinePart2Again(Machine machine)
{
    (long x, long y) prize = (machine.Prize.x + 10000000000000, machine.Prize.y + 10000000000000);

    long numerator = prize.x * machine.B.y - prize.y * machine.B.x;
    long denominator = machine.A.x * machine.B.y - machine.A.y * machine.B.x;

    if (numerator % denominator != 0)
    {
        // Not solvable
        return 0;
    }

    long aCount = numerator / denominator;
    long bCount = (prize.x - aCount * machine.A.x) / machine.B.x;

    return aCount * ACost + bCount * BCost;
}

double Mag((long x, long y) v)
{
    return Math.Sqrt(v.x * v.x + v.y * v.y);
}

double Dot((long x, long y) a, (long x, long y) b)
{
    double aLength = Math.Sqrt(a.x * a.x + a.y * a.y);
    (double x, double y) aNorm = (a.x / aLength, a.y / aLength);

    double bLength = Math.Sqrt(b.x * b.x + b.y * b.y);
    (double x, double y) bNorm = (b.x / bLength, b.y / bLength);

    return aNorm.x * bNorm.x + aNorm.y * bNorm.y;
}

long SolveMachinePart2(Machine machine)
{
    long cost = long.MaxValue;
    (long x, long y) prize = (machine.Prize.x + 10000000000000, machine.Prize.y + 10000000000000);
    // (long x, long y) prize = machine.Prize;
    var s = Stopwatch.StartNew();
    var xCycle = FindCycle(prize.x, machine.A.x, machine.B.x);
    var yCycle = FindCycle(prize.y, machine.A.y, machine.B.y);
    s.Stop();
    Console.WriteLine("Cycle time: " + s.ElapsedMilliseconds);

    if (xCycle.start == -1 || yCycle.start == -1)
    {
        return 0;
    }

    var fullCycleLength = LCM(xCycle.length, yCycle.length);

    long startI = 0;

    // Find first instance where x and y cycles align
    s = Stopwatch.StartNew();
    for (long i = xCycle.start; ; i += xCycle.length)
    {
        long distance = prize.y - machine.A.y * i;
        if (distance < 0)
        {
            return 0;
        }
        if (distance % machine.B.y == 0)
        {
            startI = i;
            break;
        }
    }
    s.Stop();
    Console.WriteLine("Initial time: " + s.ElapsedMilliseconds);

    s = Stopwatch.StartNew();
    for (long i = startI; ; i += fullCycleLength)
    {
        (long x, long y) distance = (prize.x - machine.A.x * i, prize.y - machine.A.y * i);
        if (distance.x < 0 || distance.y < 0)
        {
            s.Stop();
            Console.WriteLine("Cost time: " + s.ElapsedMilliseconds);
            return cost;
        }

        long a = i;
        long b = distance.x / machine.B.x;

        cost = Math.Min(cost, a * ACost + b * BCost);
    }
}

(long start, long length) FindCycle(long prize, long a, long b)
{
    HashSet<long> seen = [];
    long firstInstance = 0;
    for (long i = 0;; i++)
    {
        long distance = prize - i * a;
        if (distance < 0)
        {
            return (-1, -1);
        }
        if (distance % b == 0)
        {
            firstInstance = i;
            break;
        }
        if (seen.Contains(distance % b))
        {
            // Stuck in a loop
            return (-1, -1);
        }
        seen.Add(distance % b);
    }

    seen = [];
    long nextInstance = 0;
    for (long i = firstInstance + 1; ; i++)
    {
        long distance = prize - i * a;
        if (distance < 0)
        {
            return (-1, -1);
        }
        if (distance % b == 0)
        {
            nextInstance = i;
            break;
        }
        if (seen.Contains(distance % b))
        {
            // Stuck in a loop
            return (-1, -1);
        }
        seen.Add(distance % b);
    }

    return (firstInstance, nextInstance - firstInstance);
}

// Reduce remainder by jumpReduction until it = 0, wrapping around if necessary
long RemainderJumps(long remainder, long divisor, long jumpReduction)
{
    if (remainder == 0) 
    {
        return 0;
    }

    if (RemainderJumpMemo.TryGetValue((remainder, divisor, jumpReduction), out var memoJumps))
    {
        return memoJumps;
    }

    long newRemainder = Mod(remainder - jumpReduction, divisor);

    var jumps = RemainderJumps(newRemainder, divisor, jumpReduction) + 1;
    RemainderJumpMemo.Add((remainder, divisor, jumpReduction), jumps);
    return jumps;
}

long GCD(long a, long b)
{
    while (b != 0)
    {
        (a, b) = (b, a % b);
    }
    return a;
}

long LCM(long a, long b)
{
    // Potential for overflow if a and b are very large
    return a * b / GCD(a, b);
}

long Mod(long a, long b)
{
    return (a % b + b) % b;
}

class Machine
{
    public (long x, long y) A;
    public (long x, long y) B;
    public (long x, long y) Prize;
}