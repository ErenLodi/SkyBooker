# 1. Aşama: Çalışma Ortamı (Runtime)
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# 2. Aşama: Derleme (Build)
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Proje dosyasını kopyala ve bağımlılıkları yükle
COPY ["SkyBooker.API.csproj", "./"]
RUN dotnet restore "SkyBooker.API.csproj"

# Kalan tüm kodları kopyala ve derle
COPY . .
WORKDIR "/src/."
RUN dotnet build "SkyBooker.API.csproj" -c $BUILD_CONFIGURATION -o /app/build

# 3. Aşama: Yayınlama (Publish)
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "SkyBooker.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# 4. Aşama: Final (Çalıştırılabilir İmaj)
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SkyBooker.API.dll"]