# Used Base image for docker file
FROM mcr.microsoft.com/dotnet/aspnet:2.0 AS base

# Defined working directory
WORKDIR /app

# Copy the application files to the container
COPY . .

# Exposed port
EXPOSE 80

# Set up the entry point 
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
