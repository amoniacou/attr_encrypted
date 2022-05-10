ARG RUBY_VERSION=2.7.5-slim-bullseye
ARG APP_ROOT=/app
ARG PG_MAJOR=12
ARG BUNDLER_VER=2.2.20
ARG SYSTEM_PACKAGES="curl gnupg1"
ARG BUILD_PACKAGES="build-essential libpq-dev libxml2-dev libxslt1-dev libc6-dev shared-mime-info libsqlite3-dev"
ARG DEV_PACKAGES="git unzip"
ARG RUBY_PACKAGES="tzdata postgresql-client-$PG_MAJOR"

# BASIC
FROM ruby:$RUBY_VERSION AS basic
ENV LANG C.UTF-8
ARG APP_ROOT
ARG BUILD_PACKAGES
ARG DEV_PACKAGES
ARG RUBY_PACKAGES
ARG SYSTEM_PACKAGES
ARG PG_MAJOR
ARG BUNDLER_VER
ENV APP_ROOT=${APP_ROOT}
ENV PG_MAJOR=${PG_MAJOR}
ENV BUNDLER_VER=${BUNDLER_VER}
ENV SYSTEM_PACKAGES=${SYSTEM_PACKAGES}
ENV BUILD_PACKAGES=${BUILD_PACKAGES}
ENV DEV_PACKAGES=${DEV_PACKAGES}
ENV RUBY_PACKAGES=${RUBY_PACKAGES}
ENV HOME=${APP_ROOT}

EXPOSE 3000
VOLUME /home/app/public/uploads

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
COPY docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh
RUN set -x && apt-get update && apt-get install --no-install-recommends --yes ${SYSTEM_PACKAGES} \
     && curl -sS -L https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
     && echo 'deb http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list \
     && sed -i "s/bullseye main/bullseye main contrib non-free/" /etc/apt/sources.list \
     && echo "deb http://http.debian.net/debian bullseye-backports main contrib non-free" >> /etc/apt/sources.list \
     && apt-get update \
     && apt-get upgrade --yes \
     && apt-get install --no-install-recommends --yes ${BUILD_PACKAGES} \
     ${DEV_PACKAGES} \
     ${RUBY_PACKAGES} \
     && mkdir -p ${APP_ROOT} ${APP_ROOT}/.yard ${APP_ROOT}/.config && adduser --system --gid 0 --uid 1001 --home ${APP_ROOT} appuser \
     && mkdir /tmp/bundle && chgrp -R 0 /tmp/bundle && chmod -R g=u /tmp/bundle \
     && chgrp -R 0 ${APP_ROOT} && chmod -R g=u ${APP_ROOT} && chmod g=u /etc/passwd \
     && gem update --system && apt-get clean \
     && rm -rf /var/lib/apt/lists/*
RUN gem install bundler:$BUNDLER_VER
# Set a user to run
USER 1001
ENTRYPOINT ["/docker-entrypoint.sh"]
# set working folder
WORKDIR $APP_ROOT
COPY --chown=1001:0 . .