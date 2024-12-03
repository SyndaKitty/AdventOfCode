using System;
using System.IO;
using System.Collections.Generic;
using AdventOfCode;
using System.Linq;

public class Program {
    public static void Main() {
        var lines = File.ReadAllLines(@"..\..\inputs\09.txt");
        
        var cityDistances = new Dictionary<(string, string), int>();

        foreach (var line in lines) {
            var parts = line.Split(" ");
            var city1 = parts[0];
            var city2 = parts[2];
            var distance = Convert.ToInt32(parts[4]);
           cityDistances.Add((city1, city2), distance);
           cityDistances.Add((city2, city1), distance); 
        }

        Part1(cityDistances);
        Part2(cityDistances);
    }
    
    public static void Part1(Dictionary<(string, string), int> cityDistances) {
        var cities = cityDistances.Keys.Select(c => c.Item1).Distinct().ToArray();
        var lowestDistance = Int32.MaxValue;
        foreach (var path in AOC.Permutations<string>(cities)) {
            int distance = 0;
            var lastCity = path[0];
            for (int i = 1; i < path.Length; i++) {
                distance += cityDistances[(lastCity, path[i])];
                lastCity = path[i];
            }
            lowestDistance = Math.Min(lowestDistance, distance);
        }
        Console.WriteLine(lowestDistance);
    }

    public static void Part2(Dictionary<(string, string), int> cityDistances) {
        var cities = cityDistances.Keys.Select(c => c.Item1).Distinct().ToArray();
        var highestDistance = 0;
        foreach (var path in AOC.Permutations<string>(cities)) {
            int distance = 0;
            var lastCity = path[0];
            for (int i = 1; i < path.Length; i++) {
                distance += cityDistances[(lastCity, path[i])];
                lastCity = path[i];
            }
            highestDistance = Math.Max(highestDistance, distance);
        }
        Console.WriteLine(highestDistance);
    }
}