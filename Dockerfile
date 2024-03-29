FROM elixir:1.11-alpine AS build

EXPOSE 5000
ARG host=
ARG databaseUrl=
ARG secretKeyBase=
ARG githubToken=

ENV PORT=5000
ENV MIX_ENV=prod
ENV HOST=$host
ENV DATABASE_URL=$databaseUrl
ENV SECRET_KEY_BASE=$secretKeyBase
ENV GITHUB_TOKEN=$githubToken

# install build dependencies
RUN apk add --no-cache build-base npm git

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/dashy ./

ARG host=
ENV HOST=$host
ENV HOME=/app
ENV PORT=5000

ENTRYPOINT ["bin/dashy"]

CMD ["start"]