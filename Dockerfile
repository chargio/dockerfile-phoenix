FROM fedora:34

EXPOSE 4000/tcp

ENV SRC_CODE=https://github.com/chargio/phoenix-container-buildah.git
ENV LANG=en_US.utf8


ENV CODE=src/
WORKDIR ${CODE}

RUN dnf -y install elixir nodejs git; \ 
    mix local.hex --force; \
    mix archive.install hex phx_new 1.5.7 --force

RUN git clone ${SRC_CODE} ${CODE}
RUN mix deps.get; mix deps.compile \
    cd assets; npm install;

CMD mix phx.server