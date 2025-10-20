FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/MediaSavvy/MediaSavvy.git && \
    cd MediaSavvy && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git && \
    rm -rf node_modules

FROM --platform=$BUILDPLATFORM node:alpine AS build

WORKDIR /MediaSavvy
COPY --from=base /git/MediaSavvy .
RUN npm ci && \
    npm run docs:build

FROM lipanski/docker-static-website

COPY --from=build /MediaSavvy/.vitepress/dist .
