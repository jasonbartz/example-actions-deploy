FROM rust

WORKDIR /usr/src/myapp

RUN USER=root cargo init

COPY Cargo.lock Cargo.toml ./

RUN cargo build --release

COPY . .

RUN cargo install --path .

CMD ["deploy-demo"]