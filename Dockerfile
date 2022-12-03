# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM rust:1.65 as build-env
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

FROM --platform=$BUILDPLATFORM gcr.io/distroless/cc-debian11:nonroot
COPY --from=build-env /app/target/release/healthchecker /
ENTRYPOINT ["./healthchecker"]
