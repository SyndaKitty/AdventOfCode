mkdir %1
cd %1
dotnet new console
dotnet new sln
dotnet sln %1.sln add %1.csproj
"C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe" %1.sln