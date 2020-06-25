# system dependency image
FROM ruby:2.5-stretch AS ngao-sys-deps

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN groupadd -g ${GROUP_ID} ngao && \
    useradd -m -l -g ngao -u ${USER_ID} ngao && \
    apt-get update -qq && \
    apt-get -y install apt-transport-https && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    echo "deb http://http.us.debian.org/debian/ testing non-free contrib main" | tee -a /etc/apt/sources.list && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get update -qq && \
    apt-get install -y build-essential default-jre-headless libpq-dev nodejs \
    yarn && \
    rm -rf /var/lib/apt/lists/*
RUN yarn && \
    yarn config set no-progress && \
    yarn config set silent

###
# ruby dev image
FROM ngao-sys-deps AS ngao-dev

RUN mkdir /app && chown ngao:ngao /app && mkdir -p /run/data
WORKDIR /app

USER ngao:ngao
COPY --chown=ngao:ngao Gemfile Gemfile.lock ./

RUN gem update bundler
RUN bundle install -j 2 --retry=3

COPY --chown=ngao:ngao . .

ENV RAILS_LOG_TO_STDOUT true

###
# ruby dependencies image
FROM ngao-sys-deps AS ngao-deps

RUN mkdir /app && chown ngao:ngao /app
WORKDIR /app

USER ngao:ngao

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

COPY --chown=ngao:ngao Gemfile Gemfile.lock ./
RUN gem update bundler && \
    bundle install -j 2 --retry=3 --deployment --without development

COPY --chown=ngao:ngao . .

ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_ENV production

ENTRYPOINT ["bundle", "exec"]

###
# Queue processing image
FROM ngao-deps as ngao-delayed-job
USER ngao:ngao
ARG SOURCE_COMMIT
ENV SOURCE_COMMIT $SOURCE_COMMIT
CMD ./bin/delayed_job

###
# webserver image
FROM ngao-deps as ngao-web
USER ngao:ngao
RUN bundle exec rake assets:precompile
RUN mkdir /app/tmp/pids && chown ngao:ngao /app/tmp/pids
EXPOSE 3000
ARG SOURCE_COMMIT
ENV SOURCE_COMMIT $SOURCE_COMMIT
CMD puma -b tcp://0.0.0.0:3000
