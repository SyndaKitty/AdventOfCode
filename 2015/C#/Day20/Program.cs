using System;
using System.IO;
using System.Collections.Generic;

public class Program {
    public static void Main() {
        var input = Convert.ToInt32(File.ReadAllText(@"..\..\inputs\20.txt"));
    
        Part1(input);
        Part2(input);
    }
    
    public static void Part1(int input) {
        for (int house = 2;; house++) {
            int total = 10 * (1 + house);
            for (int elf = 2; elf * elf <= house; elf++) {
                if (house % elf == 0) {
                    total += elf * 10;
                    total += (house / elf) * 10;
                }
            }
            if (total >= input) {
                Console.WriteLine(house);
                return;
            }
        }
    }

    // 887040 too high
    public static void Part2(int input) {
        for (int house = 2;; house++) {
            int total = 11 * (1 + house);
            for (int elf = 2; elf * elf <= house; elf++) {
                if (house % elf == 0) {
                    if (house / elf <= 50) {
                        total += elf * 11;
                    }
                    if (elf <= 50) {
                        total += (house / elf) * 11;
                    }
                }
            }
            if (total >= input) {
                Console.WriteLine(house);
                return;
            }
        }
    }
}