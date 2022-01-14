
FROM mcr.microsoft.com/powershell:7.1.0-ubuntu-18.04

ENV CRON_PATH /etc/crontabs

# base installs
RUN apt-get update
RUN apt-get install -y curl nano nodejs supervisor tzdata
RUN apt-get install -y npm

# install powershell
RUN apt-get install -y wget apt-transport-https software-properties-common 
RUN wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update
RUN apt-get install -y powershell

# install powershell modules
ENV PSModulePath /usr/local/share/powershell/Modules:/opt/microsoft/powershell/7/Modules:/root/.local/share/powershell/Modules
RUN pwsh -c install-module -Name PSWSMan -Force
RUN pwsh -c install-module -Name ActiveDirectory -Force
RUN pwsh -c install-module -Name AzureAD -Force
RUN pwsh -c install-module -Name ExchangeOnlineManagement -Force
RUN pwsh -c Install-Module -Name PSWSMan -Scope AllUsers
RUN pwsh -c Install-WSMan

# install crontab-ui
RUN npm install -g crontab-ui
RUN mkdir /crontab-ui
VOLUME /crontab-ui

COPY supervisord.conf /etc/supervisord.conf

ENV BASIC_AUTH_USER admin
ENV BASIC_AUTH_PWD zc*t5BDj?lNcnc(?9]l8
ENV HOST 0.0.0.0
ENV PORT 8000
ENV CRON_IN_DOCKER true
ENV CRON_DB_PATH /crontab-ui

EXPOSE 8080
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
