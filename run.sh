# Uses the container name from the build and the env for SECRET_KEY_BASE

podman run -p 4000:4000 --env SECRET_KEY_BASE=$SECRET_KEY_BASE quay.io/chargio/phoenix-test

