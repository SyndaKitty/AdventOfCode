using System.IO;
using System.Collections.Generic;
using System;
using System.Linq;

public class Program {
    public static void Main() {
        var lines = File.ReadAllLines(@"..\..\inputs\14.txt");
        var stats = new List<ReindeerSpecs>();        

        foreach (var line in lines) {
            var words = line.Split(" ");
            var speed = Convert.ToInt32(words[3]);
            var length = Convert.ToInt32(words[6]);
            var rest = Convert.ToInt32(words[13]);
            stats.Add(new ReindeerSpecs(speed, length, rest));
        }

        Part1(stats);
        Part2(stats);
    }

    public class ReindeerSpecs {
        public int FlySpeed;
        public int FlyLength;
        public int RestLength;

        public ReindeerSpecs(int flySpeed, int flyLength, int restLength) {
            FlySpeed = flySpeed;
            FlyLength = flyLength;
            RestLength = restLength;
        }
    }
    
    public class ReindeerState {
        public int StaminaRemaining;
        public int RestRemaining;
        public bool Running;
        public int Distance;
        public ReindeerSpecs Specs;
        
        public ReindeerState(ReindeerSpecs specs) {
            StaminaRemaining = specs.FlyLength;
            RestRemaining = specs.RestLength;
            Running = true;
            Specs = specs;
        }
    }

    public static void Part1(List<ReindeerSpecs> specs) {
        var reindeerStates = new List<ReindeerState>();
        specs.ForEach(s => reindeerStates.Add(new ReindeerState(s)));

        for (int t = 0; t < 2503; t++) {
            foreach (var state in reindeerStates) {
                if (state.Running) {
                    state.StaminaRemaining--;
                    state.Distance += state.Specs.FlySpeed;
                    if (state.StaminaRemaining == 0) {
                        state.Running = false;
                        state.StaminaRemaining = state.Specs.FlyLength;
                    }
                }
                else {
                    state.RestRemaining--;
                    if (state.RestRemaining == 0) {
                        state.Running = true;
                        state.RestRemaining = state.Specs.RestLength;
                    }
                }
            }
        }

        Console.WriteLine(reindeerStates.Max(s => s.Distance));
    }

    public static void Part2(List<ReindeerSpecs> specs) {
        var reindeerStates = new List<ReindeerState>();
        specs.ForEach(s => reindeerStates.Add(new ReindeerState(s)));
        var points = new int[specs.Count];

        for (int t = 0; t < 2503; t++) {
            foreach (var state in reindeerStates) {
                if (state.Running) {
                    state.StaminaRemaining--;
                    state.Distance += state.Specs.FlySpeed;
                    if (state.StaminaRemaining == 0) {
                        state.Running = false;
                        state.StaminaRemaining = state.Specs.FlyLength;
                    }
                }
                else {
                    state.RestRemaining--;
                    if (state.RestRemaining == 0) {
                        state.Running = true;
                        state.RestRemaining = state.Specs.RestLength;
                    }
                }
            }
            for (int i = 0; i < reindeerStates.Count; i++) {
                if (reindeerStates[i].Distance == reindeerStates.Max(s => s.Distance)) {
                    points[i]++;
                }
            }
        }
        Console.WriteLine(points.Max());
    }
}