# Bond Docker

This creates a Docker image with the [Microsoft Bond](https://github.com/Microsoft/bond) 
compiler [gbc](https://microsoft.github.io/bond/manual/compiler.html) at /usr/local/bin.

Use this image in a multi-stage Docker build to copy the compiler to your
second build environment.

For example, to build an ASP.NET Core application that also requires bond:

```Dockerfile
FROM oliwheeler/microsoft-bond AS gbc-env

FROM microsoft/dotnet:sdk AS build-env

COPY --from=gbc-env /usr/local/bin/gbc /usr/local/bin/gbc

WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM microsoft/dotnet:aspnetcore-runtime
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
```
