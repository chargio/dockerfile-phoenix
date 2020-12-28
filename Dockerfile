FROM fedora:34 as build

EXPOSE 4000

LABEL io.k8s.description="Container for building and running a phoenix app" \
      io.k8s.display-name="build-phoenix" \
      io.openshift.expose-services="4000:http" \
      io.openshift.tags="builder,elixir,phoenix"

ENV SRC_CODE=https://github.com/chargio/phoenix-container-buildah.git
ENV LANG=en_US.UTF-8
ENV PHX_VER=1.5.7


ENV CODE=/app
WORKDIR ${CODE}


ENV MIX_ENV=prod
ENV MIX_HOME=/usr/bin/

RUN dnf -y install elixir nodejs git &&  dnf -y clean all && rm -rf /var/cache/yum;\ 
    mix local.hex --force; \
    mix local.rebar --force ; \
    mix archive.install hex phx_new ${PHX_VER} --force

RUN git clone ${SRC_CODE} .

ENV HOME=${CODE}
RUN mix do deps.get --only prod, deps.compile && \
    npm --prefix ./assets ci --no-audit --loglevel=error &&\
    npm run --prefix ./assets deploy && mix phx.digest &&\
    mix do compile, release --path /app_release



# prepare release image
FROM fedora:34 AS app
RUN dnf -y install openssl

WORKDIR /deploy/
ENV HOME=/deploy




COPY --from=build --chown=1001:0 /app_release .
RUN chgrp -R 0 /deploy &&\
    chmod -R g=u /deploy

USER 1001

CMD ["bin/container", "start"]