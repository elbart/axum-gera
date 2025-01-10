use axum::{routing::get, Json, Router};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Serialize, Deserialize, Clone)]
struct TodoItem {
    id: Uuid,
    title: String,
    completed: bool,
}

async fn list_todos() -> Json<Vec<TodoItem>> {
    let todo = TodoItem {
        id: Uuid::new_v4(),
        title: "First ToDo".into(),
        completed: false,
    };
    return Json(vec![todo]);
}

#[tokio::main]
async fn main() {
    let app = Router::new().route("/todos", get(list_todos));
    println!("Server running on http://127.0.0.1:3000");
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
