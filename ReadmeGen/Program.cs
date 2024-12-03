using System.Diagnostics;
using System.Text;

var text = File.ReadAllText("Tally.txt").Replace("\r", "");
var years = text.Split("\n\n");

StringBuilder readme = new();
readme.AppendLine("# AdventOfCode");
readme.AppendLine("My solutions to the Advent of Code challenges.");
readme.AppendLine();

foreach (var year in years)
{
    ParseYear(year, readme);
}


void ParseYear(string yearText, StringBuilder readme)
{
    var lines = yearText.Split("\n");
    var yearNumber = lines[0];
    readme.AppendLine($"## {yearNumber}");

    var extraLines = (lines.Count() - 1) % 3;
    Debug.Assert(extraLines == 0, $"Invalid number of lines under year {yearNumber}");

    for (int i = 0; ; i++)
    {
        var langLines = lines.Skip(1 + i * 3).Take(3).ToList();
        if (langLines.Count == 0)
        {
            break;
        }
        ParseLang(langLines, readme);
    }
}

void ParseLang(List<string> lines, StringBuilder readme)
{
    string langName = lines[0];
    string firstStar = lines[1];
    string secondStar = lines[2];

    readme.AppendLine($"### {langName}");

    ParseStars(firstStar);
}

void ParseStars()
{

}