var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..\\..\\..\\..\\..\\inputs\\03.txt"));
var text = File.ReadAllText(filePath);

for (int part = 1; part <= 2; part++)
{
    int sum = 0;
    bool doMul = true;
    
    for (int i = 0; i < text.Length; i++)
    {
        if (SafeSubstring(text, i, 4) == "mul(" && doMul)
        {
            int? a = GetNextNum(text, i + 4, true);
            int? b = GetNextNum(text, i + 4 + a.ToString().Length + 1, false);

            if (a.HasValue && b.HasValue)
            {
                sum += a.Value * b.Value;
            }
        }
        else if (part == 2)
        {
            if (SafeSubstring(text, i, 7) == "don't()")
            {
                doMul = false;
            }
            else if (SafeSubstring(text, i, 4) == "do()")
            {
                doMul = true;
            }
        }
    }
    Console.WriteLine(sum);
}

string SafeSubstring(string text, int index, int length)
{
    if (index + length > text.Length)
    {
        return text.Substring(index);
    }
    return text.Substring(index, length);
}

int? GetNextNum(string text, int index, bool first)
{
    var num = "";
    for (int i = index; i < text.Length; i++)
    {
        if (char.IsDigit(text[i]))
        {
            num += text[i];
        }
        else if (first && text[i] == ',')
        {
            break;
        }
        else if (!first && text[i] == ')')
        {
            break;
        }
        else return null;
    }
    return int.Parse(num);
}