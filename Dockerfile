# A dockerfile to grab some source code from github, compile and create a release,
#  and then create another container that executes the release
FROM fedora:35 as build

# Standard port for the application (over 1024 to be run by any user)
EXPOSE 4000

# Source code of the application
ARG SRC_CODE=https://github.com/chargio/phoenix-container-buildah.git
# MIX_ENV dev, test, prod
ARG MIX_ENV=prod

ARG NODE_APP=.

# Useful OpenShift labels for the application
LABEL io.k8s.description="Container for building and running a phoenix app" \
      io.k8s.display-name="build-phoenix" \
      io.openshift.expose-services="4000:http" \
      io.openshift.tags="builder,elixir,phoenix"

# Define where the source code can be found
ENV SRC_CODE=${SRC_CODE}

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENV MIX_ENV=${MIX_ENV}

# The code will be in this directory in the image
ENV CODE=/app
# Changing working directory to restrain access
WORKDIR ${CODE}

# We need this to avoid problems where MIX_HOME is not found
ENV MIX_HOME=/usr/bin/

# Installation of elixir, nodejs, git and phoenix
RUN dnf -y install glibc-locale-source glibc-langpack-en; \
    localedef --verbose --force -i C -f UTF-8 en_US.UTF-8; \
    dnf -y install elixir nodejs git &&  dnf -y clean all && rm -rf /var/cache/yum;\
    mix local.hex --force; \
    mix local.rebar --force

# Copying the source code into the working directory
RUN git clone ${SRC_CODE} .

ENV HOME=${CODE}

# Compile assets and prepare release

RUN mix do deps.get --only ${MIX_ENV}, deps.compile && \
    npm --prefix ${NODE_APP}/assets ci --no-audit --loglevel=error &&\
    npm run --prefix ${NODE_APP}/assets deploy && mix phx.digest &&\
    mix do compile, release --path /app_release



# Generating a new image that will run the application
# Prepare release image with the necessary components and install the release

FROM fedora:35 AS app

WORKDIR /deploy/
ENV HOME=/deploy

# Copying source code to the destination
COPY --from=build --chown=1001:0 /app_release .
# In OpenShift, images are run with a random UUID and group 0
# We change the ownership of the files to allow that random user to write files
RUN chgrp -R 0 /deploy &&\
    chmod -R g=u /deploy

# This will be updated to a random user
USER 1001

# The container entry point
CMD ["bin/container", "start"]
