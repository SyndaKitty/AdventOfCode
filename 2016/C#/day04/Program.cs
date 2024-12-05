using System.Text;

var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\04.txt"));

int sum = 0;
int targetSector = 0;
foreach (var line in File.ReadLines(filePath))
{
    var parts = line.Split('[');
    var roomName = parts[0].Substring(0, parts[0].LastIndexOf("-"));
    int sector = int.Parse(parts[0].Split('-').Last());
    string checksum = parts[1].Replace("]", "");

    Dictionary<char, int> letterCount = [];
    foreach (var c in roomName)
    {
        if (!char.IsLetter(c))
        {
            continue;
        }
        if (!letterCount.ContainsKey(c))
        {
            letterCount.Add(c, 0);
        }
        letterCount[c]++;
    }

    var orderedLetters = letterCount.Select(kvp => (kvp.Key, kvp.Value)).OrderByDescending(x => x.Value).ThenBy(x => x.Key).Select(x => x.Key).ToList();
    string expectedChecksum = string.Join("", orderedLetters.Take(5));

    if (expectedChecksum == checksum)
    {
        sum += sector;
        string decryptedName = ShiftString(roomName, sector);
        if (decryptedName.Contains("northpole"))
        {
            targetSector = sector;
        }
    }
}

Console.WriteLine(sum);
Console.WriteLine(targetSector);

string ShiftString(string word, int shiftAmount)
{
    StringBuilder sb = new StringBuilder();
    for (int i = 0; i < word.Length; i++)
    {
        if (word[i] == '-')
        {
            sb.Append(' ');
            continue;
        }
        sb.Append((char)((word[i] - 'a' + shiftAmount) % 26 + 'a'));
    }
    return sb.ToString();
}