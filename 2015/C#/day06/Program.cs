using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;

public class Program {
    public static void Main() {
        var lines = File.ReadAllLines(@"..\..\inputs\06.txt");

        var instructions = new List<Instruction>();
        foreach (var line in lines) {
            var instruction = new Instruction();
            instruction.On = line.StartsWith("turn on");
            instruction.Off = line.StartsWith("turn off");
            instruction.Toggle = line.StartsWith("toggle");

            var parts = line.Split(",");
            instruction.X1 = Convert.ToInt32(parts[0].Split(" ").Last());
            instruction.Y1 = Convert.ToInt32(parts[1].Split(" ")[0]);
            instruction.X2 = Convert.ToInt32(parts[1].Split(" ").Last());
            instruction.Y2 = Convert.ToInt32(parts[2]);

            instructions.Add(instruction);
        }


        Part1(instructions);
        Part2(instructions);
    }
    
    public struct Instruction {
        public bool On;
        public bool Off;
        public bool Toggle;

        public int X1;
        public int Y1;
        public int X2;
        public int Y2;
    }

    public static void Part1(List<Instruction> instructions) {
        var lights = new bool[1000, 1000];

        foreach (var instruction in instructions) {
            for (int y = instruction.Y1; y <= instruction.Y2; y++) {
                for (int x = instruction.X1; x <= instruction.X2; x++) {
                    if (instruction.On || instruction.Off) {
                        lights[x,y] = instruction.On && !instruction.Off;
                    }
                    else {
                        lights[x,y] = !lights[x,y];
                    }
                }
            }
        }

        int count = 0;
        for (int y = 0; y < 1000; y++) {
            for(int x = 0; x < 1000; x++) {
                if (lights[x,y]) count++;
            }
        }
        Console.WriteLine(count);
    }

    public static void Part2(List<Instruction> instructions) {
        var lights = new int[1000, 1000];

        foreach (var instruction in instructions) {
            for (int y = instruction.Y1; y <= instruction.Y2; y++) {
                for (int x = instruction.X1; x <= instruction.X2; x++) {
                    if (instruction.On) {
                        lights[x,y]++;
                    }
                    else if (instruction.Off) {
                        lights[x,y] = Math.Max(lights[x,y] - 1, 0);
                    }
                    else {
                        lights[x,y] += 2;
                    }
                }
            }
        }

        int count = 0;
        for (int y = 0; y < 1000; y++) {
            for(int x = 0; x < 1000; x++) {
                count += lights[x,y];
            }
        }
        Console.WriteLine(count);
    }
}