using System.IO;
using System.Collections.Generic;
using System.Linq;
using System;

namespace Game {
    public class ScriptableActions {
        public enum Target {
            A, B
        }
    }
}

public class Program {
    public static void Main() {
        var lines = File.ReadAllLines(@"..\..\inputs\19.txt");
        // var lines = File.ReadAllLines(@"test.txt");

        var fabrications = new List<Fabrication>();
        var targetMolecule = lines.Last();

        foreach (var line in lines.Take(lines.Length - 2)) {
            var parts = line.Split(" => ");
            fabrications.Add(new Fabrication(parts[0], parts[1]));
        }

        Part1(fabrications, targetMolecule);
        Part2(fabrications, targetMolecule);
    }

    public class Fabrication {
        public string Initial;
        public string Replacement;
        public Fabrication(string initial, string replacement) {
            Initial = initial;
            Replacement = replacement;
            if (replacement.Contains("(")) {
                Prefix = replacement[0].ToString();
                HasParentheses = true;
                int l = Replacement.IndexOf('(');
                int r = Replacement.LastIndexOf(')');

                Inner = Replacement.Substring(l + 1, r - l - 1);
            }
        }

        public int CommaCount => Replacement.Where(c => c == ',').Count();
        public bool HasParentheses;
        public string Inner;
        public string Prefix;
    }
    
    public static void Part1(List<Fabrication> fabrications, string targetMolecule) {
        var molecules = new HashSet<string>();
        foreach (var fab in fabrications) {
            int previousIndex = -1;
            while (true) {
                previousIndex = targetMolecule.IndexOf(fab.Initial, previousIndex + 1);
                if (previousIndex < 0) {
                    break;
                }
                var newMolecule = targetMolecule.Substring(0, previousIndex) + fab.Replacement + targetMolecule.Substring(previousIndex + fab.Initial.Length);
                molecules.Add(newMolecule);
            }
        }
        Console.WriteLine(molecules.Count);
    }

    public static void Part2(List<Fabrication> fabrications, string targetMolecule) {
        // Highly dependent on input data
        // Rn can be considered (
        // Y can be considered ,
        // Ar can be considered )
        var left = 'R';
        var comma = 'Y';
        var right = 'A';
        var structureCharacters = new char[] {left, comma, right};

        // All productions can be grouped into different forms (X can be replaced with any individual element)
        // X => XX
        // X => X(X)
        // X => X(X,X)
        // X => X(X,X,X)

        // Key insight: if we can distinguish which of the above production groups matches a specific substring
        //  we can count how many steps it takes to reduce regardless of the actual symbols

        // There are a couple reasons we are able to do this
        //  It is pre-supposed the target molecule is able to be generated, so the exact technique 
        //    and specific molecules do not matter as long as each of the productions are unambiguous
        //    and each production group adds the same amount of characters
        //  Every production group adds at least one character, so we are able to count how many steps 
        //    it took to generate a string by the number of characters alone, 
        //    without caring about the specific molecules used in each step

        int total = 0;
        // Lowercase letters are just noise, remove
        targetMolecule = new String(targetMolecule.Where(c => !char.IsLower(c)).ToArray());
        Console.WriteLine(targetMolecule);

        for (int i = 0; i < targetMolecule.Length; i++) {
            // Parentheses are consumed automatically from previous steps, so do not count towards total
            var currentChar = targetMolecule[i];
            if (currentChar == left || currentChar == right) {
                continue;
            }
            // Each comma indicates that the next element should consumed from a previous step
            else if (currentChar == comma) {
                total -= 1;
            }
            else total++;
        }

        Console.WriteLine(total);
    }
}