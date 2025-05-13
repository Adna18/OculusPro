FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5116
ENV ASPNETCORE_URLS=http://+:5116


FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . .

FROM build AS publish
RUN dotnet publish "OftamoloskaOrdinacija/OftamoloskaOrdinacija.csproj" -c Release -o /app
FROM base AS final
WORKDIR /app
COPY --from=publish /app .

ENTRYPOINT ["dotnet", "OftamoloskaOrdinacija.dll"]