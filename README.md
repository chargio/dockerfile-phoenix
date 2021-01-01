# dockerfile-phoenix
## Dockerfile to create a phoenix container in OCP

Running a container image in Kubernetes / Openshift implies some changes to the configuration of the application and a Dockerfile that can create it.

This Dockerfile uses a Fedora image to build a release from the source code, downloaded from GitHub, compiling it in the objective platform, and then creates a container with the minimal installation to make so it can run with the release.

The code is run in production (production environment for node and MIX_ENV=prod).

As it runs in production, you need to set up SECRET_KEY_BASE to make it run

Locally:
-----
podman run --env "SECRET_KEY_BASE=$SECRET_KEY_BASE" <image-name>

In OCP:
-----
Make sure that the SECRET_KEY_BASE environmen variable is present in the environment.

