string inputFile = @"../../inputs/04.txt";

var input = File.ReadAllText(inputFile);
var lines = File.ReadAllLines(inputFile);

var groups = input.Split("\n\n");
var boards = new List<Board>();

new Board(groups[1]);

foreach (var group in groups.Skip(1)) {
    boards.Add(new Board(group));
}

var inputs = groups[0].Split(",").Select(x => Convert.ToInt32(x));

bool first = false;

foreach (var x in inputs) {
    foreach (var board in boards) {
        if (board.Apply(x)) {
            if (!first || boards.Count == 1) {
                Console.WriteLine(x * board.Score());
                first = true;
            }
        }
    }
    boards = boards.Where(x => !x.Won).ToList();
}

class Board {
    int[,] Values;
    bool[,] Marked;

    public Board(string group) {
        var lines = group.Split("\n");;

        Values = new int[5, 5];
        Marked = new bool[5, 5];

        int x = 0;
        int y = 0;
        foreach (var line in lines) {
            var valStrings = line.Split(" ", StringSplitOptions.RemoveEmptyEntries);
            foreach (var valString in valStrings) {
                Values[x, y] = Convert.ToInt32(valString);
                x++;
            }
            x = 0;
            y++;
        }
    }

    public bool Apply(int val) {
        for (int y = 0; y < 5; y++) {
            for (int x = 0; x < 5; x++) {
                if (Values[x, y] == val) {
                    Marked[x, y] = true;
                }
            }
        }

        // Check if there is a row or column complete
        for (int y = 0; y < 5; y++) {
            Won = true;
            for (int x = 0; x < 5; x++) {
                if (!Marked[x, y]) {
                    Won = false;
                }
            }
            if (Won) {
                return true;
            }
        }

        for (int y = 0; y < 5; y++) {
            Won = true;
            for (int x = 0; x < 5; x++) {
                if (!Marked[y, x]) {
                    Won = false;
                }
            }
            if (Won) {
                return true;
            }
        }

        return false;
    }

    public bool Won;

    public int Score() {
        int sum = 0;
        for (int y = 0; y < 5; y++) {
            for (int x = 0; x < 5; x++) {
                if (!Marked[x, y]) {
                    sum += Values[x, y];
                }
            }
        }

        return sum;
    }
} 