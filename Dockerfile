FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
 WORKDIR /app
EXPOSE 80
EXPOSE 443
 
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["NetCoreWebAppDemo/DemoNetCoreWebApp.csproj", "NetCoreWebAppDemo/"]
RUN dotnet restore "NetCoreWebAppDemo/DemoNetCoreWebApp.csproj"
COPY . .
WORKDIR "/src/NetCoreWebAppDemo"
RUN dotnet build "DemoNetCoreWebApp.csproj" -c Release -o /app/build
 
FROM build AS publish
RUN dotnet publish "DemoNetCoreWebApp.csproj" -c Release -o /app/publish
 
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DemoNetCoreWebApp.dll"]