# target for use with vscode - debug build 
FROM vsdbg

WORKDIR /app

# copy csproj and restore as distinct layers 
COPY *.csproj ./
RUN dotnet restore 

# copy everything else and build 
COPY . ./
RUN dotnet publish -c Debug -o .

ENV ASPNETCORE_URLS=http://+:81
EXPOSE 81
EXPOSE 443

ENTRYPOINT [ "dotnet", "GreybeanSolutionsCompanySite.dll" ]