using System.Drawing;

var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\13.txt"));

var machines = File.ReadAllText(filePath).Replace("\r", "").Split("\n\n");
long total1 = 0;
long total2 = 0;

foreach (var machineDesc in machines)
{
    var machine = ParseMachine(machineDesc);
    total1 += SolveMachine(machine);

    machine.Prize = (machine.Prize.x + 10000000000000, machine.Prize.y + 10000000000000);
    total2 += SolveMachine(machine);
}

Console.WriteLine(total1);
Console.WriteLine(total2);

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

long SolveMachine(Machine machine)
{
    (long x, long y) prize = machine.Prize;

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

class Machine
{
    public (long x, long y) A;
    public (long x, long y) B;
    public (long x, long y) Prize;
}