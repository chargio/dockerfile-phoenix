# dockerfile-phoenix
## Dockerfile to create a phoenix container in OCP

It uses a Fedora image to build a release with the code, downloaded from GitHub, and then creates a container with the minimal installation to make it run using that release.

The code is run in production

You need to set up  SECRET_KEY_BASE to make it run
podman run --env "SECRET_KEY_BASE=$SECRET_KEY_BASE" <image-name>
