string inputFile = @"../../inputs/06.txt";
var input = File.ReadAllText(inputFile);
var lines = File.ReadAllLines(inputFile);

var numbers = lines[0].Split(",").Select(x => Convert.ToInt64(x));

var fish = new long[9];
foreach (var num in numbers) {
    fish[num]++;
}

for (int i = 0; i < 256; i++) {
    if (i == 80) {
        Console.WriteLine(fish.Sum());
    }
    long count = fish[0];
    
    for (int j = 0; j < 8; j++) {
        fish[j] = fish[j + 1];
    }  

    fish[8] = count;
    fish[6] += count;
}
Console.WriteLine(fish.Sum());