FROM fedora:34

EXPOSE 4000/tcp

ENV SRC_CODE=https://github.com/chargio/phoenix-container-buildah.git
ENV LANG=en_US.utf8
ENV LOCALE=${LANG}
ENV PHX_VER=1.5.7


ENV CODE=src/
WORKDIR ${CODE}


ENV MIX_ENV=prod
ENV MIX_HOME=/usr/bin/

RUN dnf -y install elixir nodejs git &&  dnf -y clean all && rm -rf /var/cache/yum;\ 
    mix local.hex --force; \
    mix local.rebar --force ; \
    mix archive.install hex phx_new ${PHX_VER} --force

RUN git clone ${SRC_CODE} .
RUN mix deps.get; mix deps.compile; \
    (cd assets; npm install;)

CMD mix phx.server