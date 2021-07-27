using System;
using System.IO;

public class Program {
    public static void Main() {
        var strings = File.ReadAllLines(@"..\..\inputs\08.txt");
    
        Part1(strings);
        Part2(strings);
    }
    
    public static void Part1(string[] strings) {
        int codeCount = 0;
        int memoryCount = 0;
        
        foreach (var str in strings) {
            codeCount += str.Length;
            
            for (int i = 1; i < str.Length - 1; i++) {
                string slice = str.Substring(i, 2);
                if (slice == "\\x") {
                    i += 3;
                }
                else if (slice == "\\\\" || slice == "\\\"") {
                    i += 1;
                }
                memoryCount += 1;
            }
        }

        Console.WriteLine($"{codeCount - memoryCount}");
    }

    public static void Part2(string[] strings) {
        int total = 0;
        foreach (var str in strings) {
            total += 2; // Contain encoding in quotes
            foreach (var c in str) {
                if (c == '\\' || c == '\"') {
                    total += 1;
                }
            }
        }
        Console.WriteLine(total);
    }
}