using System;
using System.IO;

class Program {
    static void Main(string[] args) {
        string input = File.ReadAllText(@"..\..\inputs\01.txt");
        Part1(input);
        Part2(input);
    }

    static void Part1(string input) {
        int floor = 0;
        foreach (var c in input) {
            if (c == '(') floor++;
            if (c == ')') floor--;
        }
        Console.WriteLine(floor);
    }

    static void Part2(string input) {
        int floor = 0;
        int index = 0;
        foreach (var c in input) {
            index++;
            if (c == '(') floor++;
            if (c == ')') floor--;
            if (floor == -1) break;
        }
        Console.WriteLine(index);
    }
}