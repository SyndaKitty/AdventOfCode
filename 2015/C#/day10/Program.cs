using System;
using System.IO;
using System.Text;

public class Program {
    public static void Main() {
        var input = File.ReadAllText(@"..\..\inputs\10.txt");

        Part1(input);
        Part2(input);
    }
    
    public static void Part1(string input) {
        string newString = input;
        for (int i = 0; i < 40; i++) {
            newString = LookAndSay(newString);
        }
        Console.WriteLine(newString.Length);
    }

    public static void Part2(string input) {
        var newString = input;
        for (int i = 0; i < 50; i++) {
            newString = LookAndSay(newString);
        }
        Console.WriteLine(newString.Length);
    }

    public static string LookAndSay(string input) {
        var result = new StringBuilder();
        var start = 0;
        var end = 1;
        while(start < input.Length) {
            if (end >= input.Length || input[start] != input[end]) {
                result.Append(end - start);
                result.Append(input[start]);
                start = end;
            }
            end++;
        }
        return result.ToString();
    }
}