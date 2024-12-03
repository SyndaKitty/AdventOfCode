using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;

public class Program {
    public static void Main() {
        var lines = File.ReadAllLines(@"..\..\inputs\07.txt");
        
        var gates = new List<Gate>();
        foreach (var line in lines) {
            var parts = line.Split(" ");
            
            var gate = new Gate();
            if (parts.Length == 3) {
                // 123 -> asd
                if (UInt16.TryParse(parts[0], out var num)) {
                    gate.Type = Type.Const;
                    gate.Const = num;
                }
                else {
                    gate.Type = Type.Passthrough;
                    gate.Operand1 = parts[0];
                }
                gate.Destination = parts[2];
            }
            else if (parts[0] == "NOT") {
                // NOT x -> h
                gate.Type = Type.Not;
                gate.Operand1 = parts[1];
                gate.Destination = parts[3];
            }
            else {
                // x AND y -> d
                gate.Operand1 = parts[0];
                string type = parts[1];
                gate.Operand2 = parts[2];
                gate.Destination = parts[4];

                if (type == "AND") {
                    gate.Type = Type.And;
                }
                else if (type == "OR") {
                    gate.Type = Type.Or;
                }
                else if (type == "LSHIFT") {
                    gate.Type = Type.LShift;
                }
                else if (type == "RSHIFT") {
                    gate.Type = Type.RShift;
                }
            }
            gates.Add(gate);
        }

        var p1 = Part1(gates);
        Console.WriteLine(p1);
        Console.WriteLine(Part2(gates, p1));
    }

    public class Gate {
        public Type Type;
        public string Operand1;
        public string Operand2;
        public string Destination;
        public ushort Const;
        public bool Ran;
    }

    public enum Type {
        Const,
        Not,
        And,
        Or,
        LShift,
        RShift,
        Passthrough
    }
    
    public static ushort? GetOperandValue(string operand, Dictionary<string, ushort> wireLookup) {
        if (string.IsNullOrEmpty(operand)) return null;
        if (UInt16.TryParse(operand, out var num)) {
            return num;
        }
        if (wireLookup.ContainsKey(operand)) {
            return wireLookup[operand];
        }
        return null;
    }

    public static bool IsGateReady(Gate gate, Dictionary<string, ushort> wireLookup) {
        var op1 = GetOperandValue(gate.Operand1, wireLookup);
        var op2 = GetOperandValue(gate.Operand2, wireLookup);

        if (gate.Type == Type.Const) {
            wireLookup.Add(gate.Destination, gate.Const);
            gate.Ran = true;
            return true;
        }
        if (gate.Type == Type.Not) {
            if (op1.HasValue) {
                wireLookup.Add(gate.Destination, (ushort)(ushort.MaxValue - op1));
                gate.Ran = true;
                return true;
            }
            return false;
        }
        if (gate.Type == Type.Passthrough) {
            if (op1.HasValue) {
                wireLookup.Add(gate.Destination, op1.Value);
                gate.Ran = true;
                return true;
            }
            return false;
        }
        if (op1.HasValue && op2.HasValue) {
            if (gate.Type == Type.And) {    
                wireLookup.Add(gate.Destination, (ushort)(op1 & op2));
            }
            else if (gate.Type == Type.Or) {
                wireLookup.Add(gate.Destination, (ushort)(op1 | op2));
            }
            else if (gate.Type == Type.RShift) {
                wireLookup.Add(gate.Destination, (ushort)(op1 >> op2));
            }
            else if (gate.Type == Type.LShift) {
                wireLookup.Add(gate.Destination, (ushort)(op1 << op2));
            }
            gate.Ran = true;
            return true;
        }
        return false;
    }

    public static ushort Part1(List<Gate> gates) {
        var wireLookup = new Dictionary<string, ushort>();

        bool gateChanged = true;
        while (gateChanged) {
            gateChanged = false;
            foreach (var gate in gates) {
                if (!gate.Ran && IsGateReady(gate, wireLookup)) {
                    gateChanged = true;
                }
            }
        }

        return wireLookup["a"];
    }

    public static ushort Part2(List<Gate> gates, ushort bValue) {
        // Reset gates from part 1
        foreach (var gate in gates) {
            gate.Ran = false;
        }
        var gateToOverride = gates.Where(g => g.Destination == "b").First();
        gateToOverride.Type = Type.Const;
        gateToOverride.Const = bValue;

        return Part1(gates);
    }
}