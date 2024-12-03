using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;

public class Program {
    public static void Main() {
        var words = File.ReadAllLines(@"..\..\inputs\05.txt");
    
        Part1(words);
        Part2(words);
    }
    
    public static void Part1(string[] words) {
        int niceWords = 0;
        
        string vowels = "aeiou";
        string[] badStrings = { "ab", "cd", "pq", "xy" };

        foreach (var word in words) {
            if (badStrings.Any(b => word.Contains(b))) continue;
            
            int vowelCount = word.Count(c => vowels.Contains(c));
            bool repeatedLetter = false;
            for (int i = 0; i < word.Length - 1; i++) {
                if (word[i] == word[i+1]) {
                    repeatedLetter = true;
                }
            }

            if (vowelCount >= 3 && repeatedLetter) {
                niceWords++;
            }
        }

        Console.WriteLine(niceWords);
    }

    public static void Part2(string[] words) {
        int niceWords = 0;
        
        foreach (var word in words) {
            bool doublePairFound = false;
            for (int i = 0; i < word.Length - 1; i++) {
                string pair = word.Substring(i, 2);
                if (word.Substring(i + 2).Contains(pair)) {
                    doublePairFound = true;
                    break;
                }
            }
            bool pairFound = false;
            for (int i = 0; i < word.Length - 2; i++) {
                if (word[i] == word[i + 2]) {
                    pairFound = true;
                    break;
                }
            }
            
            if (doublePairFound && pairFound) {
                niceWords++;
            }
        }
        
        Console.WriteLine(niceWords);
    }
}