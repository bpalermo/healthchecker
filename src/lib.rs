use hyper::{http::StatusCode, Client};
use std::error::Error;

pub async fn health_check(
    host: String,
    port: u16,
    path: String,
    http_code: u16,
) -> Result<(), Box<dyn Error>> {
    let client = Client::new();
    let uri = format!("http://{host}:{port}{path}").parse().unwrap();
    let res = client.get(uri).await;

    res.map(|res| {
        let status_code = res.status();
        if status_code != StatusCode::from_u16(http_code).unwrap() {
            return Err(());
        }
        return Ok(());
    })
    .map_err(|e| return e)
    .ok();

    Ok(())
}
