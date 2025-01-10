use axum::{response::IntoResponse, routing::get, Router};

// Handler to list all todos
async fn list_todos() -> impl IntoResponse {
    // Just return something static
    return "Todos";
}

#[tokio::main]
async fn main() {
    let app = Router::new().route("/todos", get(list_todos));
    println!("Server running on http://127.0.0.1:3000");
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
