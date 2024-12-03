using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace AOC2017
{
    class Program {

        
        static string ParseCommandLineArgs(string[] args)
        {
            string puzzleSelect = null;

            foreach (string arg in args)
            {
                if (double.TryParse(arg, out double num))
                {
                    puzzleSelect = arg;
                }
                else
                {
                    Console.WriteLine($"Unrecognized argument: {arg}");
                }
            }

            return puzzleSelect;
        }

        static void Main(string[] args)
        {
            string puzzleSelect = ParseCommandLineArgs(args);

            // For unselected parameters, ask user
            if (puzzleSelect == null)
            {
                Console.Write("Please select puzzle: ");
                while (puzzleSelect == null)
                {
                    string input = Console.ReadLine();
                    if (double.TryParse(input, out var num))
                    {
                        puzzleSelect = input;
                    }
                    else Console.Write("Please provide a valid puzzle number:");
                }
            }

            RunPuzzle(puzzleSelect);

            Console.ReadKey();
        }

        static string GetFilePath(string puzzleSelect) 
        {
            string filename = puzzleSelect.Split('.')[0];
            return $"../inputs/{filename:00}.txt";
        }

        static string GetFileInput(string puzzleInput) => File.ReadAllText(GetFilePath(puzzleInput));

        static void RunPuzzle(string puzzleSelect)
        {
            string fileInput = GetFileInput(puzzleSelect);
            switch(puzzleSelect) {

                case "1":
                    Puzzle1(fileInput);
                    break;
                case "1.2":
                    Puzzle1_2(fileInput);
                    break;
                case "2":
                    Puzzle2(fileInput);
                    break;
                case "2.2":
                    Puzzle2_2(fileInput);
                    break;
                case "3":
                    Puzzle3(fileInput);
                    break;
                case "3.2":
                    Puzzle3_2(fileInput);
                    break;
                case "4":
                    Puzzle4(fileInput);
                    // Puzzle4LINQ(filePath);
                    break;
                case "4.2":
                    Puzzle4_2(GetFilePath(puzzleSelect));
                    break;
                case "5":
                    Puzzle5(GetFilePath(puzzleSelect));
                    break;
                case "5.2":
                    Puzzle5_2(GetFilePath(puzzleSelect));
                    break;
                case "6":
                    Puzzle6(GetFilePath(puzzleSelect));
                    break;
                case "6.2":
                    Puzzle6_2(GetFilePath(puzzleSelect));
                    break;
                case "7":
                    Puzzle7(GetFilePath(puzzleSelect));
                    break;
                case "7.2":
                    Puzzle7_2(GetFilePath(puzzleSelect));
                    break;
                case "8":
                    break;
                case "9":
                    break;
                case "10":
                    break;
                case "11":
                    break;
                case "12":
                    break;
                case "13":
                    break;
                case "14":
                    break;
                case "15":
                    break;
                case "16":
                    break;
                case "17":
                    break;
                case "18":
                    break;
                case "19":
                    break;
                case "20":
                    break;
                case "21":
                    break;
                default:
                    Console.WriteLine("Non-existent puzzle");
                    break;
            }
        }

        static void Puzzle1(string puzzleInput)
        {
            int total = 0;
            char[] puzzle = puzzleInput.Trim().ToCharArray();
            char previousChar = puzzle.Last();

            foreach (char c in puzzle)
            {
                total += (c == previousChar)? previousChar-'0' : 0;
                previousChar = c;
            }

            Console.WriteLine(total);
        }
        static void Puzzle1_2(string puzzleInput)
        {
            int total = 0;
            char[] puzzle = puzzleInput.ToCharArray();
            int previousCharPos = puzzle.Length/2;

            for(int c=0; c<puzzle.Length; c++)
            {
                total += (puzzle[c] == puzzle[previousCharPos]) ?  puzzle[c] - '0' : 0;
                previousCharPos = (previousCharPos + 1) % puzzle.Length;
            }

            Console.WriteLine(total);
        }

        static int CharArrayToInt(char[] chars)
        {
            int digitMultiplier = (int)Math.Pow(10, chars.Length - 1);
            int finalNumber = 0;
            foreach (var c in chars)
            {
                int digit = c - '0';
                finalNumber += digit * digitMultiplier;
                digitMultiplier /= 10;
            }

            return finalNumber;
        }

        static void Puzzle2(string input)
        {
            int total = 0;
            int lineHigh = 0;
            int lineLow = Int32.MaxValue;
            StringBuilder number = new StringBuilder();

            foreach (char c in input)
            {
                switch (c)
                {
                    case '\r': continue;
                    case '\n':
                    case '\t':
                        if (number.Length > 0)
                        {
                            int num = int.Parse(number.ToString());
                            if (num > lineHigh)
                            {
                                lineHigh = num;
                            }
                            else if (num < lineLow)
                            {
                                lineLow = num;
                            }
                        }
                        number.Clear();
                        break;
                    default:
                        number.Append(c);
                        break;
                }

                if (c == '\n')
                {
                    total += lineHigh - lineLow;
                    lineHigh = 0;
                    lineLow = Int32.MaxValue;
                }
            }

            Console.WriteLine(total);
        }

        static void Puzzle2_2(string input)
        {
            int total = 0;
            StringBuilder numberChars = new StringBuilder();

            int lineNumber = 1;

            List<int> numbers = new List<int>();
            foreach (char c in input)
            {
                switch (c)
                {
                    case '\r': continue;
                    case '\n':
                    case '\t':
                        if (numberChars.Length > 0)
                        {
                            int num = int.Parse(numberChars.ToString());
                            numbers.Add(num);
                        }
                        numberChars.Clear();
                        break;
                    default:
                        numberChars.Append(c);
                        break;
                }

                if (c == '\n')
                {
                    
                    for (int i = 0; i < numbers.Count; i++)
                    {
                        for (int j = 0; j < numbers.Count; j++)
                        {
                            if (j == i) {
                                //skip
                                continue;
                            }
                            // Check if numbers are evenly divisible
                            if (numbers[i] % numbers[j] == 0)
                            {
                                Console.WriteLine($"line:{lineNumber} {numbers[i]} {numbers[j]} {numbers[i] / numbers[j]}");
                                total += numbers[i] / numbers[j];
                                goto asd;
                            }
                        }
                    }
                    asd:

                    numbers.Clear();
                    lineNumber++;
                }
            }

            Console.WriteLine(total);
        }


        struct Vector2 : IEquatable<Vector2>
        {
            public int X;
            public int Y;

            public Vector2(int x, int y)
            {
                X = x;
                Y = y;
            }

            public bool Equals(Vector2 other)
            {
                return X == other.X && Y == other.Y;
            }

            public override int GetHashCode()
            {
                unchecked
                {
                    return (X * 397) ^ Y;
                }
            }
        }

        static void Puzzle3(string fileInput)
        {
            const bool debug = false;

            Vector2 position = new Vector2();
            int dir = 0; // 0 = right, 1 = up, 2 = left, 3 = down
            int number = 2;
            int length = 1;
            bool skipLengthAdd = true;

            int endingNumber = Int32.Parse(fileInput);

            Dictionary<int, Vector2> dirs = new Dictionary<int, Vector2>
            {
                { 0, new Vector2( 1,  0) },
                { 1, new Vector2( 0,  1) },
                { 2, new Vector2(-1,  0) },
                { 3, new Vector2( 0, -1) },
            };

            while (true)
            {
                for (int i = 0; i < length && number <= endingNumber; i++, number++)
                {
                    position.X += dirs[dir].X;
                    position.Y += dirs[dir].Y;
                    if (debug) Console.WriteLine($"({position.X} {position.Y}) number: {number}");
                }
                if (number >= endingNumber) break;

                if (!skipLengthAdd)
                {
                    length++;
                }
                skipLengthAdd = !skipLengthAdd;
                dir = (dir + 1) % 4;
            }

            Console.WriteLine("Final answer: " + (Math.Abs(position.X) + Math.Abs(position.Y)));
        }

        enum Direction
        {
            Right,
            Up,
            Left,
            Down
        }

        static void Puzzle3_2(string fileInput)
        {
            const bool debug = false;

            Vector2 position = new Vector2();
            int dir = 0; // 0 = right, 1 = up, 2 = left, 3 = down
            int length = 1;
            bool skipLengthAdd = true;

            int inputNum = Int32.Parse(fileInput);

            Dictionary<Vector2, int> values = new Dictionary<Vector2, int>()
            {
                {new Vector2(0, 0), 1}
            };

            Dictionary<int, Vector2> dirs = new Dictionary<int, Vector2>
            {
                {0, new Vector2(1, 0)},
                {1, new Vector2(0, 1)},
                {2, new Vector2(-1, 0)},
                {3, new Vector2(0, -1)},
                {4, new Vector2(-1, -1)},
                {5, new Vector2(1, -1)},
                {6, new Vector2(1, 1)},
                {7, new Vector2(-1, 1)},
            };

            while (true)
            {
                for (int i = 0; i < length; i++)
                {
                    position.X += dirs[dir].X;
                    position.Y += dirs[dir].Y;

                    // Add surrounding tiles
                    int total = 0;
                    for (int d = 0; d < 8; d++)
                    {
                        var delta = dirs[d];
                        var neighborPos = new Vector2(position.X + delta.X, position.Y + delta.Y);
                        if (values.ContainsKey(neighborPos))
                        {
                            total += values[neighborPos];
                        }
                    }

                    values.Add(position, total);
                    if (total > inputNum)
                    {
                        Console.WriteLine(total);
                        return;
                    }

                    if (debug) Console.WriteLine($"({position.X} {position.Y}) {total}");
                }

                if (!skipLengthAdd)
                {
                    length++;
                }

                skipLengthAdd = !skipLengthAdd;

                dir = (dir + 1) % 4;
            }
        }

        static void Puzzle4(string fileInput)
        {
            // read in the next word
            char[] chars = fileInput.ToCharArray();
            HashSet<string> words = new HashSet<string>();
            StringBuilder next_word = new StringBuilder();
            int total_valid = 0;
            bool invalid_code = false;
            int line_number = 1;

            foreach (var next_char in chars)
            {
                if (next_char == '\r') continue;
                if (invalid_code && next_char != '\n') continue;

                // process word if ' ' or end of line
                if ((next_char == ' ' || next_char == '\n') && !invalid_code)
                {
                    // check hash for next_word
                    string word = next_word.ToString();
                    if (words.Contains(word))
                    {
                        invalid_code = true;
                    } 
                    else
                    {
                        words.Add(word);
                    }

                    next_word.Clear();
                }

                // process line if \n
                if (next_char == '\n')
                {
                    if (!invalid_code) total_valid++;
                    


                    if (invalid_code)
                    {
                        Console.WriteLine(line_number + " " + !invalid_code + " " + string.Join(",", words));
                    }
                    line_number++;
                    words.Clear();
                    invalid_code = false;
                    

                    continue;
                }

                // append letter to current_word
                if (next_char != ' ' && next_char != '\n')
                {
                    next_word.Append(next_char);
                }
            }
            
            Console.WriteLine(total_valid);
        }

        static void Puzzle4LINQ(string filePath)
        {
            var lines = File.ReadAllLines(filePath);
            int totalValid = 0;
            int linenumber = 1;
            foreach (var line in lines)
            {
                string[] words = line.Split(' ');
                if (words.Distinct().Count() == words.Length)
                {
                    totalValid++;
                }
                else
                {
                    Console.WriteLine(linenumber);
                }

                linenumber++;
            }
            Console.WriteLine(totalValid);
        }

        static int Puzzle4_2(string filePath)
        {
            var lines = File.ReadAllLines(filePath);
            int totalValid = 0;
            int linenumber = 1;

            const bool debug = false;

            foreach (var line in lines)
            {
                string[] words = line.Split(' ').Select(str => string.Concat(str.OrderBy(c => c))).ToArray();
                if (words.Distinct().Count() == words.Length)
                {
                    totalValid++;
                }
                else if (debug)
                {
                    Console.WriteLine(linenumber);
                }

                linenumber++;
            }

            return totalValid;
        }
    
        static int Puzzle5(string filePath)
        {
            // maze
            // -1 moves previous instruction
            // 2 skips next one
            // start at index 0
            // follow until out of bound
            // record followed steps

            int followed_steps = 0;
            int current_instruction_index = 0;
            //List<int> instructions = fileInput.Split(new[] {'\r', '\n'}, StringSplitOptions.RemoveEmptyEntries).Select(x => int.Parse(x)).ToList();

            List<int> instructions = new List<int>();
            var lines = File.ReadAllLines(filePath);
            foreach (var line in lines)
            {
                if (line.Trim() == "") continue;
                instructions.Add(Int32.Parse(line));
            }

            //Console.WriteLine(string.Join(", ", instructions));

            while (current_instruction_index < instructions.Count)
            {

                // follow instruction
                int prev_index = current_instruction_index;
                current_instruction_index += instructions[current_instruction_index];

                instructions[prev_index]++;

                followed_steps++;
            }

            return followed_steps;
        }

        static int Puzzle5_2(string filePath)
        {
            int followed_steps = 0;
            int current_instruction_index = 0;
            //List<int> instructions = fileInput.Split(new[] {'\r', '\n'}, StringSplitOptions.RemoveEmptyEntries).Select(x => int.Parse(x)).ToList();

            List<int> instructions = new List<int>();
            var lines = File.ReadAllLines(filePath);
            foreach (var line in lines)
            {
                if (line.Trim() == "") continue;
                instructions.Add(Int32.Parse(line));
            }

            while (current_instruction_index < instructions.Count)
            {

                // follow instruction
                int prev_index = current_instruction_index;
                current_instruction_index += instructions[current_instruction_index];

                if (instructions[prev_index] >= 3)
                {
                    instructions[prev_index]--;
                }
                else instructions[prev_index]++;

                followed_steps++;
            }

            return followed_steps;
        }

        static int Puzzle6(string filePath)
        {
            // 16 memory banks
            // each bank any number of blocks
            // balance blocks in banks
            
            // find most blocked bank, lowest num bank win
            // takes all blocks from largest, distributes to all starting at +1
            
            // how many redistributions before same number of blocks in banks seen before

            List<int> memory = File.ReadAllText(filePath).Split(new [] {'\t', ' '}, StringSplitOptions.RemoveEmptyEntries).Select(str => Int32.Parse(str)).ToList();

            int sum = memory.Sum(i => i);

            HashSet<string> previousStates = new HashSet<string>();
            int heldBlocks = 0;
            int redistributions = 0;

            while (true)
            {
                // Find slot with highest
                int highestIndex = 0;
                for (int i = 1; i < memory.Count; i++)
                {
                    if (memory[i] > memory[highestIndex])
                    {
                        highestIndex = i;
                    }
                }

                // Take all blocks out (increaseBlocks)
                heldBlocks = memory[highestIndex];
                memory[highestIndex] = 0;

                // Redistribute the blocks from highestIndex + 1
                int index = (highestIndex + 1) % memory.Count;
                while (heldBlocks > 0)
                {
                    // add 1 to memory
                    memory[index]++;
                    heldBlocks--;
                    index = (index + 1) % memory.Count;
                }
                redistributions++;
                
                // Check our state again
                string state = string.Join(" ", memory);
                //Console.WriteLine(state);
                if (previousStates.Contains(state))
                {
                    return redistributions;
                }
                else
                {
                    previousStates.Add(state);
                }
            }
        }

        static void PrintState(int index, string memory, int heldBlocks)
        {
            Console.Clear();
            int charIndex = 0;
            for (int i = 0; i < index; i++)
            {
                charIndex = memory.IndexOf(' ', charIndex) + 1;
            }

            Console.WriteLine(memory);
            Console.Write(String.Concat(Enumerable.Repeat(" ", charIndex)));
            Console.WriteLine("^");
            Console.WriteLine("Heldblocks: " + heldBlocks);
        }

        static int Puzzle6_2(string filePath)
        {
            List<int> memory = File.ReadAllText(filePath).Split(new [] {'\t', ' '}, StringSplitOptions.RemoveEmptyEntries).Select(str => Int32.Parse(str)).ToList();

            int sum = memory.Sum(i => i);
            
            Dictionary<string ,int> previousStates = new Dictionary<string, int>();
            int heldBlocks = 0;
            int redistributions = 0;

            while (true)
            {
                // Find slot with highest
                int highestIndex = 0;
                for (int i = 0; i < memory.Count; i++)
                {
                    if (memory[i] > memory[highestIndex])
                    {
                        highestIndex = i;
                    }
                }

                // Take all blocks out (increaseBlocks)
                heldBlocks = memory[highestIndex];
                memory[highestIndex] = 0;

                // Redistribute the blocks from highestIndex + 1
                int index = (highestIndex + 1) % memory.Count;
                while (heldBlocks > 0)
                {
                    // add 1 to memory
                    memory[index]++;
                    heldBlocks--;
                    index = (index + 1) % memory.Count;

                    //PrintState(index, string.Join(" ", memory), heldBlocks);
                    //Console.ReadKey();
                }
                heldBlocks = 0;
                redistributions++;
                
                // num_banks, num_blocks, 

                
                // Check our state again
                string state = string.Join(" ", memory);
                //Console.WriteLine(state);
                if (previousStates.ContainsKey(state))
                {
                    return redistributions - previousStates[state];
                }
                else
                {
                    previousStates.Add(state, redistributions);
                }
            }
        }

        class Node
        {
            public Node parent;
            public String name;
            public int weight;
            public int adjustedWeight;
            public List<Node> children = new List<Node>();
            public bool balanced;
        }

        static string Puzzle7(string filePath)
        {
            string[] lines = File.ReadAllLines(filePath);
            Dictionary<string, Node> nodeLookup = new Dictionary<string, Node>();
            
            // word (weight) -> child, child 

            foreach (string line in lines) {
                // word ' ' () -> read to \n
                string[] words = line.Split(new[] {' ', '(', ')', '-', '>', ','}, StringSplitOptions.RemoveEmptyEntries);

                if (words[0] == "xxardqs")
                {
                    Console.WriteLine("AAAAAA");
                }

                Node node = GetNode(words[0], nodeLookup);
                node.weight = int.Parse(words[1]);

                // A: b c d, f, b: f e, g, c: g
                node.children = words.Where((w,i) => i >= 2).Select(w => GetNode(w, nodeLookup)).ToList();

                foreach( Node n in node.children)
                {
                    n.parent = node;
                }
            }

            Node root = nodeLookup.Values.First();
            while (root.parent != null)
            {
                root = root.parent;
            }

            return root.name;
        }

        static string Puzzle7_2(string filePath)
        {
            string[] lines = File.ReadAllLines(filePath);
            Dictionary<string, Node> nodeLookup = new Dictionary<string, Node>();
            
            // word (weight) -> child, child 

            foreach (string line in lines) {
                // word ' ' () -> read to \n
                string[] words = line.Split(new[] {' ', '(', ')', '-', '>', ','}, StringSplitOptions.RemoveEmptyEntries);

                if (words[0] == "xxardqs")
                {
                    Console.WriteLine("AAAAAA");
                }

                Node node = GetNode(words[0], nodeLookup);
                node.weight = int.Parse(words[1]);

                // A: b c d, f, b: f e, g, c: g
                node.children = words.Where((w,i) => i >= 2).Select(w => GetNode(w, nodeLookup)).ToList();

                foreach( Node n in node.children)
                {
                    n.parent = node;
                }
            }

            Node root = nodeLookup.Values.First();
            while (root.parent != null)
            {
                root = root.parent;
            }

            Console.WriteLine("Totaling Weight");
            // Depth first sum
            var aoeu = TotalWeights(root);

            Console.WriteLine("Parent is balanced: " + root.balanced);

            Node unbalancedNode = root;
            foreach (var c in unbalancedNode.children)
            {
                if (!c.balanced)
                {
                    unbalancedNode = c;
                    continue;
                }
            }
            //       no more children                or        children all balanced
            while (unbalancedNode.children.Select(x => x.weight).Distinct().Count() > 1)
            {
                var foundNext = false;
                foreach (Node c in unbalancedNode.children)
                {
                    if (!c.balanced)
                    {
                        unbalancedNode = c;
                        foundNext = true;
                        break;
                    }

                }
                // if unbalancedNode == same
                if (!foundNext){
                    // Console.WriteLine
                    Console.WriteLine($"{unbalancedNode.name}: {unbalancedNode.children.Count}");
                    break;
                }

            }

            // delta = siblingAdjustedWeight - adjusted
            // weight + siblingAdjustedWeight - adjusted
            Console.WriteLine("I have " + (unbalancedNode.parent.children.Count - 1) + " siblings");

            int commonWeight = unbalancedNode.children.GroupBy(c => c.adjustedWeight).Where(x => x.Count() > 1)
                .Select(k => k.Key).FirstOrDefault();
            Node uniqueBoi = unbalancedNode.children.First(x => x.adjustedWeight != commonWeight);

            Console.WriteLine();
            return (uniqueBoi.weight + commonWeight - uniqueBoi.adjustedWeight).ToString();
            //int good = 0; int next= 0; int next2=0; int bad = 0;
            //// 1 2 2 2 
            //foreach (var c in unbalancedNode.children)
            //{
            //    if (next == 0) {
            //        next = c.adjustedWeight;
            //        continue;
            //    }
            //    if (next == c.adjustedWeight) {
            //        good = c.adjustedWeight;
            //        continue;
            //    }
            //    if (next2 == 0) {
            //        next2 = c.adjustedWeight;
            //        continue;
            //    }
            //    if (good != c.adjustedWeight) {
            //        bad = c.adjustedWeight;
            //        continue;
            //    }
            //    if (next == c.adjustedWeight) {
            //        good = next;
            //        bad = next2;
            //    } else {
            //        good = next2;
            //        bad = next;
            //    }

                
            //}
            
            //return (unbalancedNode.weight + good - bad).ToString();


            return "uh oh";
        }

        static int TotalWeights(Node n)
        {
            int total = 0;
            foreach (var c in n.children)
            {
                total += TotalWeights(c);
            }

            if (n.children.Count > 0)
            {
                n.balanced = n.children.Select(x => x.adjustedWeight).Distinct().Count() == 1;
            }
            else n.balanced = true;

            n.adjustedWeight = total + n.weight;
            return n.adjustedWeight;
        }

        static Node GetNode(string name , Dictionary<string,Node> nl) {
            if(nl.ContainsKey(name))
                return nl[name];
            var node = new Node{name = name};
            nl.Add(name, node);
            return node;
        }

    }
}
