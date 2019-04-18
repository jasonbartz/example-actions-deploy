extern crate hyper;

use hyper::{Body, Request, Response, Server};
use hyper::rt::Future;
use hyper::service::service_fn_ok;

const PHRASE: &str = "Hello this is an application!\n";

fn hello_world(_req: Request<Body>) -> Response<Body> {
    Response::new(Body::from(PHRASE))
}

fn main() {
    let addr = ([0, 0, 0, 0], 3000).into();
    let new_svc = || {
        service_fn_ok(hello_world)
    };
    let server = Server::bind(&addr)
        .serve(new_svc)
        .map_err(|e| eprintln!("Server error: {:?}", e));

    println!("Listening on http://{}", addr);
    hyper::rt::run(server);
}
