using System;
using System.IO;
using System.Collections.Generic;

public class Program {
    public static void Main() {
        var lines = File.ReadAllLines(@"..\..\inputs\16.txt");
        
        var sues = new List<Dictionary<string, int>>();
        foreach (var line in lines) {
            var items = line.Split(new char[] {' ', ',', ':'}, StringSplitOptions.RemoveEmptyEntries);
            var sue = new Dictionary<string, int>();
            sue.Add(items[2], Convert.ToInt32(items[3]));
            sue.Add(items[4], Convert.ToInt32(items[5]));
            sue.Add(items[6], Convert.ToInt32(items[7]));

            sues.Add(sue);
        }

        var expected = new Dictionary<string, int> {
            {"children", 3},
            {"cats", 7},
            {"samoyeds", 2},
            {"pomeranians", 3},
            {"akitas", 0},
            {"vizslas", 0},
            {"goldfish", 5},
            {"trees", 3},
            {"cars", 2},
            {"perfumes", 1}
        };

        Part1(sues, expected);
        Part2(sues, expected);
    }

    public static void Part1(List<Dictionary<string, int>> sues, Dictionary<string, int> expected) {
        for (int i = 0; i < sues.Count; i++) {
            var sue = sues[i];
            bool valid = true;
            foreach (var kvp in expected) {
                if (sue.ContainsKey(kvp.Key)) {
                    if (sue[kvp.Key] != kvp.Value) {
                        valid = false;
                    }
                }
            }
            if (valid) {
                Console.WriteLine(i + 1);
                return;
            }
        }
    }

    public static void Part2(List<Dictionary<string, int>> sues, Dictionary<string, int> expected) {
        for (int i = 0; i < sues.Count; i++) {
            var sue = sues[i];
            bool valid = true;
            foreach (var kvp in expected) {
                var key = kvp.Key;
                if (sue.ContainsKey(key)) {
                    if (key == "cats" || key == "trees") {
                        if (sue[key] <= kvp.Value) {
                            valid = false;
                        }
                    }
                    else if (key == "pomeranians" || key == "goldfish") {
                        if (sue[key] >= kvp.Value) {
                            valid = false;
                        }
                    }
                    else if (sue[key] != kvp.Value) {
                        valid = false;
                    }
                }
            }
            if (valid) {
                Console.WriteLine(i + 1);
                return;
            }
        }
    }
}