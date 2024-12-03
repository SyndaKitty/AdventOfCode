mkdir %1
cd %1
dotnet new console
dotnet new sln
dotnet sln day%1.sln add day%1.csproj