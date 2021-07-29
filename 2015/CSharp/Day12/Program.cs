using System;
using System.IO;
using System.Collections.Generic;
using System.Text.Json;

public class Program {
    public static void Main() {
        var input = File.ReadAllText(@"..\..\inputs\12.txt");
        var json = JsonDocument.Parse(input);

        Part1(json);
        Part2(json);
    }
    
    public static int TraverseArray(JsonElement json, bool ignoreRed) {
        int total = 0;
        foreach (var element in json.EnumerateArray()) {
            if (element.ValueKind == JsonValueKind.Number) {
                total += element.GetInt32();
            }
            else if (element.ValueKind == JsonValueKind.Array) {
                total += TraverseArray(element, ignoreRed);
            }
            else if (element.ValueKind == JsonValueKind.Object) {
                total += TraverseObject(element, ignoreRed);
            }
        }
        return total;
    }

    public static int TraverseObject(JsonElement json, bool ignoreRed) {
        int total = 0;
        foreach (var property in json.EnumerateObject()) {
            var element = json.GetProperty(property.Name);
            if (ignoreRed && element.ValueKind == JsonValueKind.String && element.GetString() == "red") {
                return 0;
            }
            else if (element.ValueKind == JsonValueKind.Number) {
                total += element.GetInt32();
            }
            else if (element.ValueKind == JsonValueKind.Array) {
                total += TraverseArray(element, ignoreRed);
            }
            else if (element.ValueKind == JsonValueKind.Object) {
                total += TraverseObject(element, ignoreRed);
            }
        }
        return total;
    }

    public static void Part1(JsonDocument json) {
        Console.WriteLine(TraverseArray(json.RootElement, false));
    }

    public static void Part2(JsonDocument json) {
        Console.WriteLine(TraverseArray(json.RootElement, true));
    }
}