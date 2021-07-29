using System;
using System.Collections.Generic;

namespace AdventOfCode
{
    public class AOC
    {
        public static IEnumerable<T[]> Permutations<T>(T[] input) {
            yield return input;

            var c = new int[input.Length];
            int i = 1;
            while (i < input.Length) {
                if (c[i] < i) {
                    int swapIndex = i % 2 == 0 ? 0 : c[i];
                    (input[swapIndex], input[i]) = (input[i], input[swapIndex]);
                    yield return input;
                    c[i] += 1;
                    i = 1;
                }
                else {
                    c[i] = 0;
                    i++;
                }
            }
        }

        public static IEnumerable<T[]> Permutations<T>(List<T> input) {
            return Permutations(input.ToArray());
        }

        public static List<int> ParseInts(string line) {
            List<int> results = new List<int>();
            
            for (int start = 0; start < line.Length; start++) {
                var cStart = line[start];
                if (cStart != '-' && (cStart < '0' || cStart > '9')) continue;
                for (int end = start + 1; end <= line.Length; end++) {
                    var cEnd = end == line.Length ? '|' : line[end];
                    if (cEnd < '0' || cEnd > '9') {
                        results.Add(Convert.ToInt32(line.Substring(start, end-start)));
                        start = end;
                        break;
                    }
                }
            }
            return results;
        }

        public static IEnumerable<List<int>> ParseIntsFromLines(string[] lines) {
            foreach (var line in lines) {
                yield return ParseInts(line);
            }
        }
    }
}
