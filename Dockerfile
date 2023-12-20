FROM mcr.microsoft.com/dotnet/runtime:8.0-bookworm-slim
COPY install_chrome.sh .
RUN bash install_chrome.sh \
    && rm -rf /var/lib/apt/lists/* \
    && rm install_chrome.sh
