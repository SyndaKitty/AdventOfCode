using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using AdventOfCode;

public class Program {
    public static void Main() {
        var lines = File.ReadAllLines(@"..\..\inputs\13.txt");
        var happinessBonuses = new Dictionary<(string, string), int>();
        foreach (var line in lines) {
            var words = line.Split(new char[] {' ', '.'}, StringSplitOptions.RemoveEmptyEntries);
            int points = Convert.ToInt32(words[3]);
            string person1 = words[0];
            string person2 = words.Last();
        
            if (line.Contains("lose")) {
                points = -points;
            }
            happinessBonuses.Add((person1, person2), points);
        }

        Part1(happinessBonuses);
        Part2(happinessBonuses);
    }
    
    public static int ScoreSeatingArrangement(string[] people, Dictionary<(string, string), int> happinessBonuses) {
        int total = 0;
        for (int i = 0; i < people.Length; i++) {
            var person1 = people[i];
            var person2 = people[(i + 1) % people.Length];

            total += happinessBonuses[(person1, person2)];
            total += happinessBonuses[(person2, person1)];
        }

        return total;
    }

    public static void Part1(Dictionary<(string, string), int> happinessBonuses) {
        var distinctPeople = happinessBonuses.Keys.Select(k => k.Item1).Distinct().ToArray();
        var arrangements = AOC.Permutations(distinctPeople);
        int bestScore = arrangements.Select(s => ScoreSeatingArrangement(s, happinessBonuses)).Max();

        Console.WriteLine(bestScore);
    }

    public static void Part2(Dictionary<(string, string), int> happinessBonuses) {
        var distinctPeople = happinessBonuses.Keys.Select(k => k.Item1).Distinct().ToList();
        distinctPeople.ForEach(p => {
            happinessBonuses.Add((p, "me"), 0);
            happinessBonuses.Add(("me", p), 0);
        });
        distinctPeople.Add("me");

        var arrangements = AOC.Permutations(distinctPeople);
        int bestScore = arrangements.Select(s => ScoreSeatingArrangement(s, happinessBonuses)).Max();

        Console.WriteLine(bestScore);
    }
}