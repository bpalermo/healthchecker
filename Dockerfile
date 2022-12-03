# syntax=docker/dockerfile:1
ARG RUST_VERSION=1.65
FROM --platform=$BUILDPLATFORM rust:${RUST_VERSION} as build-env
ARG TARGETARCH
COPY tools/platform.sh /
WORKDIR /app
COPY Cargo.* .
COPY .cargo .cargo
RUN /platform.sh && \
    rustup target add $(cat /.platform) && \
    apt-get update && apt-get install -y $(cat /.compiler)
RUN --mount=type=cache,target=/root/.cargo \
    cargo fetch --target $(cat /.platform)

COPY src src
RUN --mount=type=cache,target=/root/.cargo \
    cargo build --locked --release --target $(cat /.platform)
RUN mkdir -p /app/target/release && \
    mv /app/target/$(cat /.platform)/release/healthchecker /app/target/release/healthchecker

FROM --platform=$BUILDPLATFORM gcr.io/distroless/cc
COPY --from=build-env /app/target/release/healthchecker /
ENTRYPOINT ["./healthchecker"]
