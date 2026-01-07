FROM swift:5.9 as builder
WORKDIR /src
COPY . .
RUN swift build -c release

FROM ubuntu:22.04
RUN apt-get update && apt-get install -y libatomic1 libgcc-s1 ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
# Copy the built binary
COPY --from=builder /src/.build/release/swift-ingest /app/swift-ingest
# Copy Swift runtime libraries from the builder image so the binary can run on a minimal image
COPY --from=builder /usr/lib/swift /usr/lib/swift
ENV LD_LIBRARY_PATH=/usr/lib/swift/linux:${LD_LIBRARY_PATH}
ENTRYPOINT ["/app/swift-ingest"]
