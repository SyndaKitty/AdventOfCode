rem Usage: setup 01
mkdir day%1
cd day%1
dotnet new console
dotnet new sln
dotnet sln day%1.sln add day%1.csproj
del "Program.cs"
echo var filePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, @"..\\..\\..\\..\\..\\inputs\\%1.txt")); >> "Program.cs"
start "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe" day%1.sln /edit "Program.cs"
code ../../inputs/%1.txt