using System.Diagnostics;
using System.Text;

const int DecemberDays = 31;

var readmePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..\\..\\..\\..\\README.md"));

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
File.WriteAllText(readmePath, readme.ToString());

void ParseYear(string yearText, StringBuilder readme)
{
    var lines = yearText.Split("\n");
    var yearNumber = int.Parse(lines[0]);
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
        var lang = ParseLang(langLines);
        readme.AppendLine($"### {lang.Name}");
        readme.AppendLine(GenerateCalendar(yearNumber, lang));
    }
}

string GenerateCalendar(int year, LangInfo lang)
{
    StringBuilder calendar = new();
    StringBuilder links = new();
    calendar.AppendLine("|Sun|Mon|Tue|Wed|Thu|Fri|Sat|");
    calendar.AppendLine("|---|---|---|---|---|---|---|");

    calendar.Append("|");
    var date = new DateTime(year, 12, 1);
    DayOfWeek dayOfWeek = DayOfWeek.Sunday;
    while (date.DayOfWeek != dayOfWeek)
    {
        calendar.Append("|");
        dayOfWeek++;
    }
    
    while (date <= new DateTime(year, 12, DecemberDays))
    {
        bool dayCompleted = lang.FirstStar[date.Day - 1] || lang.SecondStar[date.Day - 1];

        if (dayCompleted)
        {
            calendar.Append("[");  
        }
        calendar.Append($"{date.Day} ");
        calendar.Append($"{(lang.FirstStar[date.Day - 1] ? "🌟" : "☆")}");
        calendar.Append($"{(lang.SecondStar[date.Day - 1] ? "🌟" : "☆")}");
        if (dayCompleted)
        {
            calendar.Append("]");
            calendar.Append(GenerateLinkHeader(lang.Name, year, date.Day));
            links.AppendLine(GenerateLink(lang.Name, year, date.Day));
        }
        calendar.Append("|");

        date = date.AddDays(1);
        if (date.DayOfWeek == DayOfWeek.Sunday)
        {
            calendar.AppendLine();
        }
    }
    calendar.AppendLine();
    calendar.AppendLine();

    return calendar.ToString() + links.ToString();
}

string GenerateLinkHeader(string lang, int year, int day)
{
    var shorthand = lang switch
    {
        "C#" => "csharp",
        _ => lang
    };
    
    return $"[{year}d{day}{shorthand}]";
}

string GenerateLink(string lang, int year, int day)
{
    string prefix = $"{GenerateLinkHeader(lang, year, day)}: https://github.com/SyndaKitty/AdventOfCode/blob/master/{year}/";
    switch (lang) 
    {
        case "C#":
            return $"{prefix}C%23/day{day:D2}/Program.cs";
        case "Odin":
            return $"{prefix}Odin/day{day:D2}.odin";
        case "Java":
            return $"{prefix}Java/Day{day}.java";
        default:
            return "";
    }
}

LangInfo ParseLang(List<string> lines)
{
    return new LangInfo {
        Name = lines[0],
        FirstStar = ParseStars(lines[1]),
        SecondStar = ParseStars(lines[2])
    };
}

List<bool> ParseStars(string line)
{
    line = line.Replace("FirstStar ", "").Replace("SecondStar ", "").Replace("\t", "").Replace(" ", "");
    List<bool> stars = new();

    for (int i = 0; i < DecemberDays; i++)
    {
        stars.Add(false);
    }

    var tokens = line.Split(",");
    foreach (var token in tokens)
    {
        if (token.Contains("-"))
        {
            var range = token.Split("-");
            var start = int.Parse(range[0]);
            var end = int.Parse(range[1]);
            for (int i = start; i <= end; i++)
            {
                stars[i - 1] = true;
            }
        }
        else
        {
            var day = int.Parse(token);
            stars[day - 1] = true;
        }
    }

    return stars;
}

class LangInfo 
{
    public string Name { get; set; }
    public List<bool> FirstStar { get; set; }
    public List<bool> SecondStar { get; set; }
}