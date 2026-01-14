FROM haskell:9.12.2-slim-bookworm AS builder
RUN echo cabal update date: 2026-01-05
RUN cabal update --verbose=2

WORKDIR /hs-base64-encode-lines
COPY --link ./hs-base64-encode-lines.cabal ./
RUN cabal update --verbose=2
RUN cabal build --only-dependencies
COPY --link ./app/ ./app/

RUN cabal build
RUN cp $( cabal list-bin hs-base64-encode-lines | fgrep --max-count=1 hs-base64-encode-lines ) /usr/local/bin/
RUN which hs-base64-encode-lines
RUN printf '%s\n' helo wrld | hs-base64-encode-lines


FROM debian:bookworm-slim
COPY --link --from=builder /usr/local/bin/hs-base64-encode-lines /usr/local/bin/

CMD ["/usr/local/bin/hs-base64-encode-lines"]
