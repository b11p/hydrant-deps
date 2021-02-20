FROM mcr.microsoft.com/dotnet/runtime:5.0-buster-slim
COPY install_chrome.sh .
RUN bash install_chrome.sh \
    && rm -rf /var/lib/apt/lists/* \
    && rm install_chrome.sh
