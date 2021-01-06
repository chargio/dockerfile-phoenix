# Change the name for whatever fits you so it can be uploded to quay with your username

# buildah bud -t <image-name>
IMAGE_TAG=quay.io/chargio/phoenix-test
MIX_ENV=prod buildah bud -t $IMAGE_TAG
