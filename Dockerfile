FROM mcr.microsoft.com/azure-powershell


ENV PSModulePath /usr/local/share/powershell/Modules:/opt/microsoft/powershell/7/Modules:/root/.local/share/powershell/Modules

RUN pwsh -c install-module -Name ActiveDirectory -Force
RUN pwsh -c install-module -Name AzureAD -Force
RUN pwsh -c install-module -Name ExchangeOnlineManagement -Force

FROM mhart/alpine-node:latest

RUN apk --no-cache add \
    wget \
    nano \
    curl \
    nodejs \
    npm \
    supervisor \
    tzdata

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
