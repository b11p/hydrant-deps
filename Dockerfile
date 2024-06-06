FROM mcr.microsoft.com/dotnet/runtime:8.0-bookworm-slim
RUN addgroup --gid 1000 xfs \
    && adduser --uid 1000 --gid 1000 xfs
COPY install_chrome.sh .
RUN bash install_chrome.sh \
    && rm -rf /var/lib/apt/lists/* \
    && rm install_chrome.sh
