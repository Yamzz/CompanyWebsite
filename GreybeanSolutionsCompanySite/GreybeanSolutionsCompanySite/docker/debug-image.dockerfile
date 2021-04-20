#Target for use with VSCode  - debug build
FROM microsoft/dotnet:2.2-sdk AS debug-env

RUN apt-get update && \
    apt-get install -y procps

WORKDIR /vsdbg

RUN apt-get install -y --no-install-recommends \
unzip \
&& rm -rf /var/lib/apt/lists/* \
&& curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l /vsdbg
