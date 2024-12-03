var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..\\..\\..\\..\\..\\inputs\\03.txt"));
var lines = File.ReadAllLines(filePath);
var text = File.ReadAllText(filePath);
var lineTokens = lines.Select(x => x.Split(' ')).ToList();

foreach (var tokens in lineTokens)
{
    foreach (var token in tokens)
    {
       
    }
}

foreach (var line in lines)
{
    
}