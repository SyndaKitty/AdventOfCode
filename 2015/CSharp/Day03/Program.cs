using System;
using System.IO;
using System.Collections.Generic;

public class Program {
    public static void Main() {
        var directions = File.ReadAllText(@"..\..\inputs\03.txt");
    
        Part1(directions);
        Part2(directions);
    }
    
    public static void Part1(string directions) {
        int x = 0;
        int y = 0;
        var housesVisited = new HashSet<(int, int)>();
        housesVisited.Add((0, 0));

        foreach (var d in directions) {
            if (d == '^') y++;
            else if (d == 'v') y--;
            else if (d == '<') x--;
            else x++;
            housesVisited.Add((x, y));
        }

        Console.WriteLine(housesVisited.Count);
    }

    public static void Part2(string directions) {
        int x1 = 0; int y1 = 0;
        int x2 = 0; int y2 = 0;

        var housesVisited = new HashSet<(int, int)>();
        housesVisited.Add((0, 0));

        int index = 0;
        foreach (var d in directions) {
            if (index == 0) {
                if (d == '^') y1++;
                else if (d == 'v') y1--;
                else if (d == '<') x1--;
                else x1++;
                housesVisited.Add((x1, y1));
            }
            else {
                if (d == '^') y2++;
                else if (d == 'v') y2--;
                else if (d == '<') x2--;
                else x2++;
                housesVisited.Add((x2, y2));
            }
            index = (index + 1) % 2;
        }

        Console.WriteLine(housesVisited.Count);
    }
}