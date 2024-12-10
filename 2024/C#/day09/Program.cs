// oof

var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\09.txt"));
string text = File.ReadAllText(filePath);
List<AmphipodFile> filesystem = [];

int id = 0;
for (int i = 0; i < text.Length; i++)
{
    int length = int.Parse(text[i].ToString());
    bool isGap = i % 2 == 1;

    filesystem.Add(new(isGap ? null : id, length));
    
    if (!isGap)
    {
        id++;
    }
}

// Break filesystem into blocks
var fs1 = Discretize(filesystem);
Defrag(fs1);
Console.WriteLine(CalculateChecksum(fs1));

var fs2 = filesystem.ToList();
Defrag(fs2);
Console.WriteLine(CalculateChecksum(Discretize(fs2)));

void Defrag(List<AmphipodFile> filesystem)
{
    while (true)
    {
        int lastFileIndex = filesystem.Count;
        int firstGapIndex = 0;
        AmphipodFile? lastFile = null;
        while (true)
        {
            bool found = false;
            for (int i = lastFileIndex - 1; i >= 0; i--)
            {
                if (!filesystem[i].IsGap)
                {
                    lastFileIndex = i;
                    found = true;
                    break;
                }
            }

            if (!found)
            {
                return;
            }

            lastFile = filesystem[lastFileIndex];
            firstGapIndex = filesystem.FindIndex(x => x.IsGap && x.Length >= lastFile.Length);

            if (firstGapIndex < 0 || firstGapIndex > lastFileIndex)
            {
                continue;
            }
            else
            {
                break;
            }
        }
        
        var firstGap = filesystem[firstGapIndex];
        
        filesystem.Insert(firstGapIndex, new AmphipodFile(lastFile.Id, lastFile.Length));
        lastFile.Id = null;

        firstGap.Length -= lastFile.Length;
        if (firstGap.Length == 0)
        {
            filesystem.RemoveAt(firstGapIndex + 1);
        }
    }
}

void DisplayFilesystem(List<AmphipodFile> filesystem)
{
    foreach (var file in filesystem)
    {
        for (int i = 0; i < file.Length; i++)
        {
            Console.Write(file.IsGap ? "." : file.Id);
        }
    }
    Console.WriteLine();
}

List<AmphipodFile> Discretize(List<AmphipodFile> inputFilesystem)
{
    // Break filesystem into blocks of size 1
    var filesystem = new List<AmphipodFile>();
    foreach (var file in inputFilesystem)
    {
        for (int i = 0; i < file.Length; i++)
        {
            filesystem.Add(new(file.Id, 1));
        }
    }
    return filesystem;
}

long CalculateChecksum(List<AmphipodFile> filesystem)
{
    long result = 0;
    for (int i = 0; i < filesystem.Count; i++)
    {
        if (!filesystem[i].IsGap)
        {
            Console.WriteLine(filesystem[i].Id!.Value + "*" + i);
            result += filesystem[i].Id!.Value * i;
        }
    }
    return result;
}

class AmphipodFile
{
    public long? Id { get; set; }
    public int Length { get; set; }
    public bool IsGap => Id is null;
    public AmphipodFile(long? id, int length)
    {
        Id = id;
        Length = length;
    }
}