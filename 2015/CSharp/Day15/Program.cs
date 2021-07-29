using System;
using System.IO;
using System.Collections.Generic;
using AdventOfCode;
using System.Linq;

public class Program {
    public static void Main() {
        var lines = File.ReadAllLines(@"..\..\inputs\15.txt");
        var ingredients = new List<Ingredient>();
        foreach (var line in lines) {
            var nums = AOC.ParseInts(line);
            ingredients.Add(new Ingredient(nums[0], nums[1], nums[2], nums[3], nums[4]));
        }

        Part1(ingredients);
        Part2(ingredients);
    }

    public class Ingredient {
        public int C;
        public int D;
        public int F;
        public int T;
        public int Cal;
        public Ingredient(int c, int d, int f, int t, int cal) {
            C = c;
            D = d;
            F = f;
            T = t;
            Cal = cal;
        }
    }
    
    public static int Combine(int[] amounts, List<Ingredient> ingredients, bool require500Cals) {
        if (require500Cals && ingredients.Select((value,i) => value.Cal * amounts[i]).Sum() != 500) return 0;
        int capacity = Math.Max(ingredients.Select((value,i) => value.C * amounts[i]).Sum(), 0);
        int durability = Math.Max(ingredients.Select((value,i) => value.D * amounts[i]).Sum(), 0);
        int flavor = Math.Max(ingredients.Select((value,i) => value.F * amounts[i]).Sum(), 0);
        int texture = Math.Max(ingredients.Select((value,i) => value.T * amounts[i]).Sum(), 0);

        return capacity * durability * flavor * texture;
    }

    public static void Part1(List<Ingredient> ingredients) {
        int best = 0;
        for (int i = 0; i <= 100; i++) {
            for (int j = 0; j <= 100 - i; j++) {
                for (int k = 0; k <= 100 - i - j; k++) {
                    for (int l = 0; l <= 100 - i - j - k; l++) {
                        best = Math.Max(best, Combine(new int[] {i, j, k, l}, ingredients, false));
                    }
                }
            }
        }
        Console.WriteLine(best);
    }

    public static void Part2(List<Ingredient> ingredients) {
        int best = 0;
        for (int i = 0; i <= 100; i++) {
            for (int j = 0; j <= 100 - i; j++) {
                for (int k = 0; k <= 100 - i - j; k++) {
                    for (int l = 0; l <= 100 - i - j - k; l++) {
                        best = Math.Max(best, Combine(new int[] {i, j, k, l}, ingredients, true));
                    }
                }
            }
        }
        Console.WriteLine(best);
    }
}