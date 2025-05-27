using System;
using System.Collections.Generic;
using System.IO;

public class Program {
    public static void Main() {
        var lines = File.ReadAllLines(@"..\..\inputs\23.txt");
        var instructions = new List<Instruction>();
        foreach (var line in lines) {
            var parts = line.Split(new char[] {' ', ','}, StringSplitOptions.RemoveEmptyEntries);
            var ins = new Instruction {
                Operation = parts[0],
                Operands = new List<int>()
            };

            for (int i = 1; i < parts.Length; i++) {
                if (parts[i] == "a") {
                    ins.Operands.Add(0);
                }
                else if (parts[i] == "b") {
                    ins.Operands.Add(1);
                }
                else {
                    ins.Operands.Add(Convert.ToInt32(parts[i]));
                }
            }
            
            instructions.Add(ins);
        }

        Part1(instructions);
        Part2(instructions);
    }
    
    public class Instruction {
        public string Operation;
        public List<int> Operands;
    }

    public class State {
        public int IP;
        public int[] Registers;
    }

    public static void RunInstruction(State state, Instruction ins) {
        if (ins.Operation == "hlf") {
            state.Registers[ins.Operands[0]] /= 2;
            state.IP++;
        }
        else if (ins.Operation == "tpl") {
            state.Registers[ins.Operands[0]] *= 3;
            state.IP++;
        }
        else if (ins.Operation == "inc") {
            state.Registers[ins.Operands[0]] += 1;
            state.IP++;
        }
        else if (ins.Operation == "jmp") {
            state.IP += ins.Operands[0];
        }
        else if (ins.Operation == "jie") {
            if (state.Registers[ins.Operands[0]] % 2 == 0) {
                state.IP += ins.Operands[1];
            }
            else state.IP++;
        }
        else if (ins.Operation == "jio") {
            if (state.Registers[ins.Operands[0]] == 1) {
                state.IP += ins.Operands[1];
            }
            else state.IP++;
        }
    }

    public static void Part1(List<Instruction> instructions) {
        var state = new State {
            IP = 0,
            Registers = new int[] {0, 0}
        };
        
        while (state.IP < instructions.Count) {
            RunInstruction(state, instructions[state.IP]);
        }

        Console.WriteLine(state.Registers[1]);
    }

    public static void Part2(List<Instruction> instructions) {
        var state = new State {
            IP = 0,
            Registers = new int[] {1, 0}
        };
        
        while (state.IP < instructions.Count) {
            RunInstruction(state, instructions[state.IP]);
        }

        Console.WriteLine(state.Registers[1]);
    }
}