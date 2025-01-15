use std::sync::Arc;

use axum::{extract::State, routing::get, Json, Router};
use serde::{Deserialize, Serialize};
use tokio::sync::RwLock;
use uuid::Uuid;

#[derive(Serialize, Deserialize, Clone)]
struct TodoItem {
    id: Uuid,
    title: String,
    completed: bool,
}

#[derive(Serialize, Deserialize, Clone)]
struct TodoItemCreateRequest {
    title: String,
    completed: bool,
}

#[derive(Default)]
struct AppState {
    todos: RwLock<Vec<TodoItem>>,
}

async fn list_todos(State(state): State<Arc<AppState>>) -> Json<Vec<TodoItem>> {
    let todos = state.todos.read().await.clone();
    return Json(todos);
}

async fn create_todo(
    State(state): State<Arc<AppState>>,
    Json(payload): Json<TodoItemCreateRequest>,
) -> Json<TodoItem> {
    let mut todos = state.todos.write().await;
    let todo = TodoItem {
        id: Uuid::new_v4(),
        title: payload.title,
        completed: payload.completed,
    };
    todos.push(todo.clone());
    return Json(todo);
}

#[tokio::main]
async fn main() {
    let state = Arc::new(AppState::default());
    let app = Router::new()
        .route("/todos", get(list_todos).post(create_todo))
        .with_state(state);
    println!("Server running on http://0.0.0.0:3000");
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
