using System;
using System.IO;
using System.Collections.Generic;
using AdventOfCode;

public class Program {
    public static void Main() {
        var input = File.ReadAllText(@"..\..\inputs\21.txt");
        var ints = AOC.ParseInts(input);
        var boss = new FighterStat {
            Hp = ints[0],
            Damage = ints[1],
            Armor = ints[2]
        };
        
        var weapons = new List<Item> {
            new Item(8, 4, 0),
            new Item(10, 5, 0),
            new Item(25, 6, 0),
            new Item(40, 7, 0),
            new Item(74, 8, 0)
        };

        var armor = new List<Item> {
            new Item(13, 0, 1),
            new Item(31, 0, 2),
            new Item(53, 0, 3),
            new Item(75, 0, 4),
            new Item(102, 0, 5)
        };

        var rings = new List<Item> {
            new Item(25, 1, 0),
            new Item(50, 2, 0),
            new Item(100, 3, 0),
            new Item(20, 0, 1),
            new Item(40, 0, 2),
            new Item(80, 0, 3)
        };

        Part1(boss, weapons, armor, rings);
        Part2(boss, weapons, armor, rings);
    }

    public class Item {
        public int Cost;
        public int Damage;
        public int Armor;
        public Item(int c, int d, int a) {
            Cost = c;
            Damage = d;
            Armor = a;
        }
    }

    public class FighterStat {
        public int Hp;
        public int Damage;
        public int Armor;
        public FighterStat Clone() {
            return new FighterStat {
                Hp = Hp,
                Damage = Damage,
                Armor = Armor
            };
        }
    }

    public static bool SimulateFight(FighterStat player, FighterStat boss) {
        while (player.Hp > 0) {
            // Player's turn
            boss.Hp -= Math.Max(1, player.Damage - boss.Armor);
            if (boss.Hp <= 0) return true;

            // Boss's turn
            player.Hp -= Math.Max(1, boss.Damage - player.Armor);
        }
        return false;
    }
    
    public static void Part1(FighterStat boss, List<Item> weapons, List<Item> armor, List<Item> rings) {
        var emptyItem = new Item(0, 0, 0);
        var playerStats = new FighterStat {
            Armor = 0,
            Damage = 0,
            Hp = 100
        };

        // Number of possible setups = 5c1 * 5c1 * 6c1 * 6c2 = 4500
        int lowestCost = Int32.MaxValue;
        for (int w = 0; w < weapons.Count; w++) {
            var chosenWeapon = weapons[w];
            for (int a = -1; a < armor.Count; a++) {
                var chosenArmor = a == -1 ? emptyItem : armor[a];
                for (int r1 = -1; r1 < rings.Count; r1++) {
                    var chosenRing1 = r1 == -1 ? emptyItem : rings[r1];
                    for (int r2 = -1; r2 != r1 && r2 < rings.Count; r2++) {
                        var chosenRing2 = r2 == -1 ? emptyItem : rings[r2];
                        playerStats.Armor = chosenArmor.Armor + chosenRing1.Armor + chosenRing2.Armor;
                        playerStats.Damage = chosenWeapon.Damage + chosenRing1.Damage + chosenRing2.Damage;
                        int cost = chosenWeapon.Cost + chosenArmor.Cost + chosenRing1.Cost + chosenRing2.Cost;

                        if (SimulateFight(playerStats.Clone(), boss.Clone())) {
                            lowestCost = Math.Min(cost, lowestCost);
                        }
                    }
                }
            }
        }

        Console.WriteLine(lowestCost);
    }

    public static void Part2(FighterStat boss, List<Item> weapons, List<Item> armor, List<Item> rings) {
        var emptyItem = new Item(0, 0, 0);
        var playerStats = new FighterStat {
            Armor = 0,
            Damage = 0,
            Hp = 100
        };

        // Number of possible setups = 5c1 * 5c1 * 6c1 * 6c2 = 4500
        int highestCost = 0;
        for (int w = 0; w < weapons.Count; w++) {
            var chosenWeapon = weapons[w];
            for (int a = -1; a < armor.Count; a++) {
                var chosenArmor = a == -1 ? emptyItem : armor[a];
                for (int r1 = -1; r1 < rings.Count; r1++) {
                    var chosenRing1 = r1 == -1 ? emptyItem : rings[r1];
                    for (int r2 = -1; r2 != r1 && r2 < rings.Count; r2++) {
                        var chosenRing2 = r2 == -1 ? emptyItem : rings[r2];
                        playerStats.Armor = chosenArmor.Armor + chosenRing1.Armor + chosenRing2.Armor;
                        playerStats.Damage = chosenWeapon.Damage + chosenRing1.Damage + chosenRing2.Damage;
                        int cost = chosenWeapon.Cost + chosenArmor.Cost + chosenRing1.Cost + chosenRing2.Cost;

                        if (!SimulateFight(playerStats.Clone(), boss.Clone())) {
                            highestCost = Math.Max(cost, highestCost);
                        }
                    }
                }
            }
        }

        Console.WriteLine(highestCost);
    }
}