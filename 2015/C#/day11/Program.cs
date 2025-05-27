using System;
using System.IO;

public class Program {
    public static void Main() {
        var password = File.ReadAllText(@"..\..\inputs\11.txt");

        // Part 1
        password = FindNextPassword(password);
        Console.WriteLine(password);
        
        // Part 2
        password = FindNextPassword(password);
        Console.WriteLine(password);
    }
    
    public static string FindNextPassword(string password) {
        string nextPassword = password;
        while (true) {
            nextPassword = IncrementWord(nextPassword);
            if (IsValid(nextPassword)) {
                return nextPassword;
            }
        }
    }

    public static string IncrementWord(string word) {
        string nextWord = "";
        bool carry = true;
        for (int i = word.Length - 1; i >= 0; i--) {
            var nextChar = (char)(word[i] + (carry ? 1 : 0));
            if (nextChar > 'z') {
                nextChar = 'a';
                carry = true;
            }
            else carry = false;
            nextWord = nextChar + nextWord;
        }
        return nextWord;
    }

    public static bool IsValid(string password) {
        // Cannot contain confusing letters
        if (password.Contains("i") || password.Contains("o") || password.Contains("l")) {
            return false;
        }
        
        // Must contain at least 2 pairs of letters
        int pairCount = 0;
        for (int i = 0; i < password.Length - 1; i++) {
            if (password[i] == password[i+1]) {
                pairCount++;
                i++;
            }
        }
        if (pairCount < 2) return false;
        
        // Must contain increasing straight of at least 3 letters
        for (int i = 0; i < password.Length - 2; i++) {
            if (password[i] == password[i+1]-1 && password[i+1] == password[i+2]-1) {
                return true;
            }
        }
        return false;
    }
}