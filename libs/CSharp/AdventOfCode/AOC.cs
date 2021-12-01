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

        public static IEnumerable<bool[]> CombinationBools(int length) {
            int combinations = 1;
            for (int i = 0; i < length; i++) {
                combinations *= 2;
            }

            for (int i = 0; i < combinations; i++) {
                var result = new bool[length];
                for (int j = 0; j < length; j++) {
                    result[j] = ((i >> j) & 1) == 0;
                }
                yield return result;
            }
        }

        public static IEnumerable<IEnumerable<T>> Combinations<T>(List<T> input) {
            foreach (var combination in CombinationBools(input.Count)) {
                List<T> result = new List<T>();
                for (int i = 0; i < input.Count; i++) {
                    if (combination[i]) {
                        result.Add(input[i]);
                    }
                }
                yield return result;
            }
        }

        // public static IEnumerable<int[]> Groupings(int itemCount, int groups) {
        //     int[] result = new int[itemCount];
        //     yield return result;

        //     long count = 1;
        //     for (int i = 0; i < itemCount; i++) {
        //         count *= groups;
        //     }
        //     Console.WriteLine(count);

        // TODO

        // }

        public static IEnumerable<bool[]> ChooseBools(int n, int s, bool[] b) {
            for (int i = s; i < b.Length; i++) {
                Console.WriteLine(n + " " + s + " " + i);
                b[i] = true;
                if (n > 0) {
                    foreach (var chosen in ChooseBools(n - 1, i + 1, b)) {
                        yield return b;
                    }
                }
                else yield return b;

                b[i] = false;
            }
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

        public static T[] Clone<T>(T[] array) => (T[])array.Clone();
        public static T[,] Clone<T>(T[,] array) => (T[,])array.Clone();

        public static IEnumerable<TNode> Backtrack<TData,TNode>(TData data, TNode node, 
            Func<TData, TNode, bool> Reject, 
            Func<TData, TNode, bool> Accept, 
            Func<TData, TNode, IEnumerable<TNode>> Children) {
            if (!Reject(data, node)) {
                if (Accept(data, node)) {
                    yield return node;
                }
                else {
                    foreach (var child in Children(data, node)) {
                        foreach (var valid in Backtrack(data, child, Reject, Accept, Children)) {
                            yield return valid;
                        }
                    }
                }
            }
        }
    }
}
