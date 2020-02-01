# https://hub.docker.com/_/microsoft-dotnet-core
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY WebApplication/*.csproj ./WebApplication/
RUN dotnet restore -r win-x64

# copy everything else and build app
COPY WebApplication/. ./WebApplication/
WORKDIR /source/WebApplication/
RUN dotnet publish -c release -o /app -r win-x64 --self-contained false --no-restore

# final stage/image
# Uses the 1909 release; 1903, and 1809 are other choices
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-nanoserver-1809 AS runtime
EXPOSE 80
EXPOSE 443
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["WebApplication"]
