+++
title = "Comments - Take 3 - On Zola"
date = 2022-08-05
draft = true
[taxonomies]
tags = ["tech", "gamedev"]
+++

A [while ago](@comments-on-jekyll/index.md) I added comments for my Jekyll base blog. Now, a while ago I switched to [zola](https://www.getzola.org/).
Its basically a Rust based "clone" of the SSG (static site generator) Hugo. Compared to Jekyll, it is a lot faster, and I found it to be a lot simpler.
It still has some problems (changing themes or selectable themes are neigh impossible, theme extension is a mess, ...) - that is content for another post.
At some point I might consider creating my own SSG. Building a small one should be easy enough (and due to GitHub's Actions it could be used immediately).

[Previously](@comments-on-jekyll/index.md#step-1-create-a-service-that-accepts-comments) I used CGI. It's a bit archaic and cumbersome.
So here's what we'll do:
1. First, we'll transform it to a web service
2. We'll switch from our custom (and now obsolete) GitHub client to a working one I don't have to maintain
3. Our Javascript client needs to be re-added to the new Zola generated site


# Our own Web Server
Now, first, we need to implement our own TCP stack... J/k we'll use [hyper](https://hyper.rs/). We could use [Axum](https://github.com/tokio-rs/axum/) but we won't be needing any full blown web server anytime soon.

Let's fire up a simple server at `127.0.0.0:3000`:

```Rust
use core::convert::Infallible;
use hyper::service::{make_service_fn, service_fn};
use hyper::{Body, Error, Request, Response, Server};
use std::net::SocketAddr;

async fn post_comment_service(_req: Request<Body>) 
        -> Result<Response<Body>, Infallible> {
    Ok(Response::new("Hello World".into()))
}

#[tokio::main]
pub async fn main() -> Result<(), Error> {
    let addr = SocketAddr::from(([127, 0, 0, 1], 3000));

    let post_comment_service =
        make_service_fn(|_conn| async { 
        Ok::<_, Infallible>(service_fn(post_comment_service))
    });
    let server = Server::bind(&addr).serve(post_comment_service);
    server.await
}
```

# A working GitHub client
According to [GitHub](ttps://docs.github.com/en/rest/overview/libraries-for-the-rest-api?apiVersion=2022-11-28#rust) - there's no official client for Rust. But there are two third party clients. [Octocat](https://github.com/octocat-rs/octocat-rs) seems to be on the decline. I'm sorry if I misjudged here, I just compared the activity to the alternative [Octocrab](https://github.com/XAMPPRocky/octocrab) which has a lot more "everything". A quick check reveals it seems to be able to create branches, commits and PRs - everything we need. So we're using that, just a quick `cargo add octocrab`.

First, lets limit the input our services receives to have some basic DDOS protection:
```Rust
    let body = Limited::new(req.into_body(), 100 * 1024);
```

Most of the post handling code is the same as before, for brevities sake I will only skim through here:
```Rust

```


