# dockerfile-phoenix
## Dockerfile to create a phoenix container in OCP

Running a container image in Kubernetes / Openshift implies some changes to the configuration of the application and a Dockerfile that can create it.

This Dockerfile uses a Fedora image to build a mix release from the source code, downloaded from GitHub, compiling it in the objective platform, and then creates a container with the minimal installation to make so it can run with the release.

By default, the MIX_ENV is set to production (production environment for node and MIX_ENV=prod), but you can provide the environment as a build parameters.

As it runs in production, you need to set up SECRET_KEY_BASE to make it run (there is no default)

Environment variables  defined for the build (See code for defaults):
-----

SRC_CODE: The https git address of the source code, defaults to a base phx image without ecto.
MIX_ENV: THe environment to run the application (defaults to prod)


-----

Build.sh holds the configuration to upload your image to Quay.

Locally:
-----
podman run --env "SECRET_KEY_BASE=$SECRET_KEY_BASE" <--env "OTHER ENV=VALE" <image-name>

In OCP:
-----
Make sure that the SECRET_KEY_BASE environment variable is present in the environment.

