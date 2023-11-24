FROM ruby:3.2 as basebuilder

WORKDIR /app/

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  libpq-dev \
  nodejs \
  wait-for-it \
  yarn

ENV BUNDLER_VERSION="2.4.6"

COPY "Gemfile*" /app/
RUN mkdir -p /app/local_gems
COPY local_gems /app/local_gems
RUN gem install bundler -v "$BUNDLER_VERSION" && \
  bundle config --global github.https true && \
  bundle install -j "$(nproc)" --retry 5

FROM ruby:3.2-slim AS appimage

RUN apt-get update && apt-get install -y --no-install-recommends \
  curl && \
  curl -sL https://deb.nodesource.com/setup_18.x |bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y --no-install-recommends \
  libpq-dev \
  nodejs \
  wait-for-it \
  yarn \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean \
  && useradd -m rails \
  && mkdir /app \
  && mkdir -p /usr/local/bundle \
  && chown -R rails:rails -v /app /usr/local/bundle

WORKDIR /app

COPY --from=basebuilder --chown=rails:rails /usr/local/bundle /usr/local/bundle
COPY --chown=rails:rails . .
USER rails:rails

CMD ["bundle", "exec", "puma", "config/puma.rb"]
