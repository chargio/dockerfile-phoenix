FROM fedora:34

EXPOSE 4000

LABEL io.k8s.description="Platform for building and running a phoenix app" \
      io.k8s.display-name="build-phoenix" \
      io.openshift.expose-services="4000:http" \
      io.openshift.tags="builder,elixir,phoenix"

ENV SRC_CODE=https://github.com/chargio/phoenix-container-buildah.git
ENV LANG=en_US.UTF-8
ENV LOCALE=${LANG}
ENV PHX_VER=1.5.7


ENV CODE=/opt/app-root/
WORKDIR ${CODE}



ENV MIX_ENV=prod
ENV MIX_HOME=/usr/bin/

RUN dnf -y install elixir nodejs git &&  dnf -y clean all && rm -rf /var/cache/yum;\ 
    mix local.hex --force; \
    mix local.rebar --force ; \
    mix archive.install hex phx_new ${PHX_VER} --force

RUN git clone ${SRC_CODE} .

ENV HOME=${CODE}
RUN mix deps.get; mix deps.compile; \
    (cd assets; npm install;)

RUN chown -R 1001:1001 ${CODE}


USER 1001

CMD mix phx.server