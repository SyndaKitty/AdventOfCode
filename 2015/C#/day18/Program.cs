using System;
using System.IO;
using System.Collections.Generic;
using AdventOfCode;

public class Program {
    public static void Main() {
        var lines = File.ReadAllLines(@"..\..\inputs\18.txt");
        // var lines = File.ReadAllLines(@"test.txt");
        var lights = new bool[lines.Length,lines[0].Length];

        for (int x = 0; x < lines.Length; x++) {
            var line = lines[x];
            for (int y = 0; y < lines.Length; y++) {
                lights[x, y] = line[y] == '#';
            }
        }

        Part1(lights);
        Part2(lights);
    }

    public static void Step(bool[,] currentLights, bool[,] newLights) {
        var offsets = new List<(int, int)> { (1,0), (1,1), (0,1), (-1,1), (-1,0), (-1,-1), (0,-1), (1,-1) };
        int width = currentLights.GetLength(0);
        int height = currentLights.GetLength(1);
        for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
                int neighbors = 0;
                foreach (var (dx, dy) in offsets) {
                    var nx = x + dx;
                    var ny = y + dy;
                    if (nx >=0 && nx < width && ny >= 0 && ny < height && currentLights[nx, ny]) {
                        neighbors++;
                    }
                }
                bool stayOn = currentLights[x,y] && neighbors >= 2 && neighbors <= 3;
                bool turnOn = !currentLights[x,y] && neighbors == 3;
                newLights[x,y] = stayOn || turnOn;
            }
        }
    }

    public static void Part1(bool[,] lights) {
        var currentLights = AOC.Clone(lights);
        var newLights = new bool[lights.GetLength(0), lights.GetLength(1)];
        
        for (int t = 0; t < 100; t++) {
            Step(currentLights, newLights);
            currentLights = AOC.Clone(newLights);
        }

        int count = 0;
        for (int x = 0; x < currentLights.GetLength(0); x++) {
            for (int y = 0; y < currentLights.GetLength(1); y++) {
                if (currentLights[x,y]) count++;
            }
        }

        Console.WriteLine(count);
    }

    public static void Part2(bool[,] lights) {
        var currentLights = AOC.Clone(lights);
        int width = currentLights.GetLength(0) - 1;
        int height = currentLights.GetLength(1) - 1;
        
        currentLights[0, 0] = true;
        currentLights[0, height] = true;
        currentLights[width, 0] = true;
        currentLights[width, height] = true;

        var newLights = new bool[lights.GetLength(0), lights.GetLength(1)];

        for (int t = 0; t < 100; t++) {
            Step(currentLights, newLights);
            currentLights = AOC.Clone(newLights);
            currentLights[0, 0] = true;
            currentLights[0, height] = true;
            currentLights[width, 0] = true;
            currentLights[width, height] = true;
        }

        int count = 0;
        for (int x = 0; x < currentLights.GetLength(0); x++) {
            for (int y = 0; y < currentLights.GetLength(1); y++) {
                if (currentLights[x,y]) count++;
            }
        }

        Console.WriteLine(count);
    }
}