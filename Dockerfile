FROM mcr.microsoft.com/dotnet/runtime:10.0-noble
RUN groupmod -n xfs ubuntu \
    && usermod -l xfs -d /home/xfs -m ubuntu
# 腾讯图片服务器只有弱加密的 workaround
RUN sed -i '/^\[openssl_init\]/a ssl_conf = ssl_sect' /etc/ssl/openssl.cnf \
    && printf '\n[ssl_sect]\nsystem_default = system_default_sect\n\n[system_default_sect]\nCipherString = DEFAULT@SECLEVEL=2\n' >> /etc/ssl/openssl.cnf
COPY install_chrome.sh .
RUN bash install_chrome.sh \
    && rm -rf /var/lib/apt/lists/* \
    && rm install_chrome.sh
