mkdir %1
cd %1
dotnet new console
dotnet add reference ..\..\..\libs\CSharp\AdventOfCode\AdventOfCode.csproj
template Program.cs aoc