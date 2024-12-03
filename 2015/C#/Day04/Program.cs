using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

public class Program {
    public static void Main() {
        var secret = File.ReadAllText(@"..\..\inputs\04.txt");
    
        Part1(secret);
        Part2(secret);
    }
    
    public static void Part1(string secret) {
        for (int i = 0;; i++) {
            var hash = Hash(secret, i);
            if (hash.StartsWith("00000")) {
                Console.WriteLine(i);
                return;
            }
        }
    }

    public static void Part2(string secret) {
        for (int i = 0;; i++) {
            var hash = Hash(secret, i);
            if (hash.StartsWith("000000")) {
                Console.WriteLine(i);
                return;
            }
        }
    }

    public static string Hash(string secret, int num) {
        string password = secret + num;
        var encodedPassword = new UTF8Encoding().GetBytes(password);
        var hashData = MD5.HashData(encodedPassword);
        return BitConverter.ToString(hashData).Replace("-", "");
    }
}