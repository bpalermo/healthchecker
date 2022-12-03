use clap::Parser;
use std::process::exit;

#[derive(Parser, Default, Debug)]
#[clap(author = "Bruno Palermo", version, about = "Minimal health checker")]
struct Arguments {
    #[clap(default_value = "localhost", long)]
    // host to health check
    host: String,
    #[clap(default_value = "8080", long)]
    // port to health check
    port: u16,
    #[clap(default_value = "/", long)]
    // path to health check
    path: String,
    #[clap(default_value = "200", long)]
    // http code to check
    http_code: u16,
}

#[tokio::main]
async fn main() -> ! {
    let args = Arguments::parse();
    match healthchecker::health_check(args.host, args.port, args.path, args.http_code).await {
        Ok(_) => {
            exit(0)
        },
        Err(_) => {
            exit(1)
        }
    }
}
