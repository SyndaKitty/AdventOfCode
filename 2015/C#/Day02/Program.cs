using System;
using System.IO;
using System.Collections.Generic;

public class Program {
    public static void Main() {
        var file = File.ReadAllLines(@"..\..\inputs\02.txt");
        
        var boxes = new List<(int, int, int)>();
        foreach (var line in file) {
            var parts = line.Split("x");
            int l = Convert.ToInt32(parts[0]);
            int w = Convert.ToInt32(parts[1]);
            int h = Convert.ToInt32(parts[2]);
            boxes.Add((l, w, h));
        }

        Part1(boxes);
        Part2(boxes);
    }
    
    public static void Part1(List<(int, int, int)> boxes) {
        int totalArea = 0;
        foreach ((int l, int w, int h) in boxes) {
            int lw = l * w;
            int lh = l * h;
            int wh = w * h;
            totalArea += lw * 2 + lh * 2 + wh * 2 + Math.Min(lw, Math.Min(lh, wh));
        }
        Console.WriteLine(totalArea);
    }

    public static void Part2(List<(int, int, int)> boxes) {
        int totalRibbon = 0;
        foreach ((int l, int w, int h) in boxes) {
            int lw = 2 * (l + w);
            int lh = 2 * (l + h);
            int wh = 2 * (w + h);
            int volume = l * w * h;
            totalRibbon += Math.Min(lw, Math.Min(lh, wh)) + volume;
        }
        Console.WriteLine(totalRibbon);
    }
}