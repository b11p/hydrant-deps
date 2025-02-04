FROM mcr.microsoft.com/dotnet/runtime:8.0-bookworm-slim
RUN addgroup --gid 1000 xfs \
    && adduser --uid 1000 --gid 1000 xfs
# 腾讯图片服务器只有弱加密的 workaround
RUN cat <<'EOF' >> /etc/ssl/openssl.cnf
[openssl_init]
ssl_conf = ssl_sect

[ssl_sect]
system_default = system_default_sect

[system_default_sect]
CipherString = DEFAULT@SECLEVEL=2
EOF
COPY install_chrome.sh .
RUN bash install_chrome.sh \
    && rm -rf /var/lib/apt/lists/* \
    && rm install_chrome.sh
