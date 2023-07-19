+++
title = "How to bring solar power to Grafana"
draft = true
+++

# Solar Power
# Deye SUNxyz Microinverter
# 

# Clap
Everytime I use clap, I somehow get the feeling, I'm wrestling a sumo, but they're also a bird-of-paradise: It's a bit too much for what I want, and lacks a bit in areas I want.

For example, trying to call `get_matches` will panic if arguments are wrong. Ok, then lets try `try_get_matches`! Oh, it also panics?







Now, how to get those values into my InfluxDB to finally show them in Grafana? I want to use v2 of the InfluxDB API, so the [influxdb](https://crates.io/crates/influxdb) crate won't cut it.
The crate [influxdb2](TODO) looked promising. Alas, it requires an async runtime. I tried using [block_on](TODO), but there's some [hyper](TODO) in there.
Now I could have switched to [tokio](TODO). But this tool is supposed to run once every minute or so, concurrent performance won't be an issue.

Now, the v2 of the API is just a set of REST calls. And even better, I only need the [write](https://docs.influxdata.com/influxdb/v2.0/api/#tag/Write) call. This will require the use of InfluxDB's [line protocol](https://docs.influxdata.com/influxdb/v2.7/reference/syntax/line-protocol/), which happens to be very easy as well.

I decided to go with this:
```
measurement,device=.. currentPower=..,yieldToday=.., totalYield=..
```
I'm not even bothering with a timestamp, whatever the DB will come up with will be good enough.

# Docker or how to build a statically linked binary in Rust
I started out using docker-compose to build and fire up the app. Mostly, because I wanted to use a minimal Docker image. That is, from `scratch`.
Because of this, I decided to include this chapter, although the result does not use docker.

So, lets start with my docker-compose file:
docker-compose.yml:
```
services:
  solar-grabber:
    environment:
      - SG_INVERTERS=[{"statusPageUrl":"http://INVERTER/status.html","user":"admin","password":"admin"}]
      - SG_INFLUXDBS=[{"influxUrl":"http://influxdb:8086", "bucket": "bucket", "org": "org", "token": "Token you generated in the InfluxDB web interface","measurement":"measurement"}]
    build: .
```

Nothing spectacular, it just builds and starts my little application (it does not even try to restart it).

The Dockerfile itself is, as expected, tiny:
```Dockerfile
FROM scratch
add sun-status-grabber /
CMD ["/sun-status-grabber"]
```

Now lets run this:
```bash
docker-compose up
[... Docker building the image ...]
exec /sun-status-grabber: no such file or directory
```

Wait! What? Turns out, Rust does link dynamically against `libc.c`:
```bash
> ldd target/x86_64-unknown-linux-gnu/release/sun-status-grabber
linux-vdso.so.1 (0x00007ffdae1a0000)
libgcc_s.so.1 => /usr/lib/libgcc_s.so.1 (0x00007fe51e33d000)
libc.so.6 => /usr/lib/libc.so.6 (0x00007fe51de16000)
/lib64/ld-linux-x86-64.so.2 => /usr/lib64/ld-linux-x86-64.so.2 (0x00007fe51e3a7000)
```

`scratch` is pretty much empty, so this won't work. So lets statically link everything. Hello [musl](https://musl.libc.org/)! Using the Rust target `x86_64-unknown-linux-musl` allows us to statically link *everything*.

So start by the target via rustup:
```bash
> rustup target add x86_64-unknown-linux-musl
info: downloading component 'rust-std' for 'x86_64-unknown-linux-musl'
info: installing component 'rust-std' for 'x86_64-unknown-linux-musl'
```

Now, instead of passing the `--target=x86_64-unknown-linux-musl` argument to `cargo build` all the time, let's create a config file for cargo:
Create the file `.cargo/config.toml`:
```toml
[build]
target = "x86_64-unknown-linux-musl"
```

Now lets build the app:
```bash
> cargo b
[...]
> ls target/x86_64-unknown-linux-musl/debug/ -1
build/
deps/
examples/
incremental/
sun-status-grabber*
sun-status-grabber.d
```

Now lets rebuild 
```bash
> docker-compose build
[... Docker building the image ...]
> docker-compose up
Starting solargrabber_solar-grabber_1 ... done
Attaching to solargrabber_solar-grabber_1
solar-grabber_1  | StatusData {
solar-grabber_1  |     device_sn: "..."
solar-grabber_1  |     current_power: ...,
solar-grabber_1  |     yield_today: ...,
solar-grabber_1  |     total_yield: ...,
solar-grabber_1  | }
solargrabber_solar-grabber_1 exited with code 0
```
