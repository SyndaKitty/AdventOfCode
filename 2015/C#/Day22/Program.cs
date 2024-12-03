using System;
using System.IO;
using System.Collections.Generic;
using AdventOfCode;
using System.Linq;

public class Program {
    public static void Main() {
        var nums = AOC.ParseInts(File.ReadAllText(@"..\..\inputs\22.txt"));
    
        // var bossStats = new FighterStats(14, 8, 0, 0);
        var bossStats = new FighterStats(nums[0], nums[1], 0, 0);

        var spells = new List<Spell> {
            new Spell("Magic missile", 53, 4, 0, null), // Magic missile
            new Spell("Drain", 73, 2, 2, null),  // Drain
            new Spell("Shield", 113, 0, 0, new Effect { ID = 1, Duration = 6, Armor = 7 }), // Shield
            new Spell("Poison", 173, 0, 0, new Effect { ID = 2, Duration = 6, Damage = 3 }), // Poison
            new Spell("Recharge", 229, 0, 0, new Effect { ID = 3, Duration = 5, Mana = 101 }), // Recharge
        };

        Part1(bossStats, spells);
        Part2(bossStats, spells);
    }
    
    public class FighterStats {
        public int Hp;
        public int Damage;
        public int Armor;
        public int Mana;
        public FighterStats(int h, int d, int a, int m) {
            Hp = h;
            Damage = d;
            Armor = a;
            Mana = m;
        }

        public FighterStats Clone() {
            return new FighterStats(Hp, Damage, Armor, Mana);
        }
    }

    public class Effect {
        public int ID;
        public int Duration;
        public int Armor;
        public int Damage;
        public int Mana;

        public Effect Clone() {
            return new Effect {
                ID = ID,
                Duration = Duration,
                Armor = Armor,
                Damage = Damage,
                Mana = Mana,
                TimeRemaining = Duration
            };
        }
        public int TimeRemaining;
    }

    public class Spell {
        public string Name;
        public int Cost;
        public int InstantDamage;
        public int InstantHeal;
        public Effect Effect;

        public Spell(string name, int c, int d, int h, Effect e) {
            Name = name;
            Cost = c;
            InstantDamage = d;
            InstantHeal = h;
            Effect = e;
        }
    }
 
    public static void ApplyEffects(FighterStats boss, FighterStats player, List<Effect> activeEffects) {
        for (int i = 0; i < activeEffects.Count; i++) {
            var effect = activeEffects[i];

            boss.Hp -= effect.Damage;
            player.Mana += effect.Mana;
            effect.Duration--;
            
            if (effect.Duration == 0) {
                // Spell has expired
                player.Armor -= effect.Armor;
                activeEffects.RemoveAt(i);
                i--;
            }
        }
    }

    public static bool SimulateTurn(StateNode state, Spell chosenSpell, bool hardmode) {
        var tab = new String(' ', state.Depth);

        var player = state.Player;
        var boss = state.Boss;
        var activeEffects = state.ActiveEffects;
        
        // Players turn
        if (hardmode) {
            player.Hp--;
            if (player.Hp <= 0) {
                return true;
            }
        }

        // Apply effects
        ApplyEffects(boss, player, activeEffects);
        if (boss.Hp <= 0) return true;

        // Validate spell
        if (chosenSpell.Cost > state.Player.Mana) return false;
        if (chosenSpell.Effect != null && state.ActiveEffects.Any(e => e.ID == chosenSpell.Effect.ID)) return false;

        // Use spell
        boss.Hp -= chosenSpell.InstantDamage;
        player.Hp += chosenSpell.InstantHeal;
        if (chosenSpell.Effect != null) {
            player.Armor += chosenSpell.Effect.Armor;
            activeEffects.Add(chosenSpell.Effect.Clone());
        }
        state.ManaSpent += chosenSpell.Cost;
        player.Mana -= chosenSpell.Cost;
        if (boss.Hp <= 0) return true;

        // Boss turn
        // Apply effects
        ApplyEffects(boss, player, activeEffects);
        if (boss.Hp <= 0) return true;
        // Boss attack
        var dmg = Math.Max(1, boss.Damage - player.Armor);
        player.Hp -= dmg;
        return true;
    }

    public class Data {
        public List<Spell> Spells;
        public int MinManaUsed;
        public bool HardMode;
    }

    public class StateNode {
        public FighterStats Player;
        public FighterStats Boss;
        public List<Effect> ActiveEffects;
        public int ManaSpent;
        public int Depth;

        public StateNode Clone() {
            var newState = new StateNode {
                Player = Player.Clone(),
                Boss = Boss.Clone(),
                ActiveEffects = new List<Effect>(),
                ManaSpent = ManaSpent,
                Depth = Depth
            };
            newState.ActiveEffects.AddRange(ActiveEffects.Select(e => e.Clone()));
            return newState;
        }
    }

    public static IEnumerable<StateNode> TrySpells(Data data, StateNode state) {
        for (int i = 0; i < data.Spells.Count; i++) {
            var spell = data.Spells[i];
            
            var newState = state.Clone();
            if (SimulateTurn(newState, spell, data.HardMode)) {
                newState.Depth++;
                yield return newState;
            }
        }
    }

    public static void Part1(FighterStats boss, List<Spell> spells) {
        var player = new FighterStats(50, 0, 0, 500);
        var data = new Data {
            Spells = spells,
            MinManaUsed = Int32.MaxValue
        };
        var state = new StateNode { 
            Player = player,
            Boss = boss,
            ActiveEffects = new List<Effect>(),
        };
        
        Func<Data, StateNode, bool> reject = (Data data, StateNode state) => {
            if (state.Player.Hp <= 0 || state.Player.Mana <= 0 || state.ManaSpent > data.MinManaUsed) {
                return true;
            }
            return false;
        };
        Func<Data, StateNode, bool> accept = (Data data, StateNode state) => {
            if (state.Boss.Hp <= 0) {
                data.MinManaUsed = Math.Min(data.MinManaUsed, state.ManaSpent);
                return true;
            }
            return false;
        };
        
        Console.WriteLine(AOC.Backtrack(data, state, reject, accept, TrySpells).Select(s => s.ManaSpent).Min());
    }


    public static void Part2(FighterStats boss, List<Spell> spells) {
        var player = new FighterStats(50, 0, 0, 500);
        var data = new Data {
            Spells = spells,
            MinManaUsed = Int32.MaxValue,
            HardMode = true
        };
        var state = new StateNode { 
            Player = player,
            Boss = boss,
            ActiveEffects = new List<Effect>(),
        };
        
        Func<Data, StateNode, bool> reject = (Data data, StateNode state) => {
            if (state.Player.Hp <= 0 || state.Player.Mana <= 0 || state.ManaSpent > data.MinManaUsed) {
                return true;
            }
            return false;
        };
        Func<Data, StateNode, bool> accept = (Data data, StateNode state) => {
            if (state.Boss.Hp <= 0) {
                data.MinManaUsed = Math.Min(data.MinManaUsed, state.ManaSpent);
                return true;
            }
            return false;
        };
        
        Console.WriteLine(AOC.Backtrack(data, state, reject, accept, TrySpells).Select(s => s.ManaSpent).Min());
    }
}