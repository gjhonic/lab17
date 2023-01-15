FROM rust:1.65.0-slim-bullseye as builder

WORKDIR /home/projects/lab17

COPY . .

RUN cargo install --path .

EXPOSE 3000

CMD ["/usr/local/cargo/bin/lab17"]