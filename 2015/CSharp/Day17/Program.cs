using System.IO;
using System.Collections.Generic;
using AdventOfCode;
using System.Linq;
using System;

public class Program {
    public static void Main() {
        var sizes = AOC.ParseInts(File.ReadAllText(@"..\..\inputs\17.txt"))
            .OrderByDescending(s => s).ToList();
        
        Part1(sizes);
        Part2(sizes);
    }
    
    public static void Part1(List<int> sizes) {
        int combinations = AOC.Combinations<int>(sizes).Where(combo => combo.Sum() == 150).Count();
        Console.WriteLine(combinations);
    }

    public static void Part2(List<int> sizes) {
        var validCombos = AOC.Combinations<int>(sizes).Where(combo => combo.Sum() == 150);
        int minCount = validCombos.Select(combo => combo.Count()).Min();
        int sameCountCombos = validCombos.Where(combo => combo.Count() == minCount).Count();
        
        Console.WriteLine(sameCountCombos);
    }
}