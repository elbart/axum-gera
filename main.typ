#import "@preview/touying:0.5.5": *
#import themes.metropolis: *
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.4": *

#show: codly-init.with()
#codly(languages: codly-languages)
#show: metropolis-theme.with(
    aspect-ratio: "16-9",
    config-common(preamble: {
      // codly()
  }),
)
// #set text(weight: "light", size: 20pt)

= Fast and safe web services with axum

== Goal
- Broad Overview about Rust and it's current usage
- Detailed example to illustrate some features
- Encourage audience to try it out

== Outline
- About myself
- My way to Rust
- Rust Introduction

== About myself
- Tim Eggert
- Working at #box(height: 20pt, image("img/qdrant-logo.png")) as Staff Engineer & Security Officer
- Recently moved to Baldenhain
#pause
- Looking for a cozy place to talk about tech frequently!
#image("memes/new-friends.jpg", fit: "contain", width: 370pt)

== My way to Rust
- Started with dynamic languages (PHP, later Python)
- Sometimes Java, but too verbose...
- Some C++ 11 with type inference (`auto`)
- Started my Rust journey in 2018
#pause
#image("memes/borrow-checker.jpg", fit: "contain", width: 330pt)

== Rust Intro
#set quote(block: true)
#quote(attribution: "https://www.rust-lang.org")[
 "A language empowering everyone to build reliable and efficient software."
]
== Rust Intro
//#TODO
Disclaimer: I am a fan of Rust
== Rust Intro
=== Overview 
- Compiled, statically typed language
- Ecosystem at hand with `cargo`: Build, test, release, format, lint, manage dependencies (so-called crates)
#pause
- #text(blue.lighten(20%), link("https://doc.rust-lang.org/rustc/platform-support.html")[Many different build targets])
  - Embedded devices like ESP32
  - Major CPU architectures: x86, ARM, 
  - Multiple platforms: Linux, Mac, Windows, Android, Web Assembly, ...
#pause
- Widely adopted own documentation standard
//#TODO: Error handling
- Enterprise features for stability and maintainability

== Rust Intro
=== Origins
- Brainchild of Graydon Hoare
- Adopted + Sponsored by Mozilla in 2010
- Decision at Mozilla: Build new Browser Engine (Servo) from scratch based on Rust

== Rust Intro
=== Reliability: Memory Safety & Thread Safety

#set quote(block: true)
#quote(attribution: "https://www.rust-lang.org")[
  "Rust's rich type system and ownership model guarantee memory-safety and thread-safety — enabling you to eliminate many classes of bugs at compile-time."
]

== Rust Intro
=== Usage / Adoption
- #text(blue.lighten(20%), link("https://google.github.io/comprehensive-rust/")[Android])
- AWS Lambda (via #text(blue.lighten(20%), link("https://firecracker-microvm.github.io/")[Firecracker]))
- Discord, Dropbox, Cloudflare backend systems
- Mozilla Servo (browser engine)
#pause
- Databases (Meilisearch, Qdrant, ...)
- CLI Tools , Editors, Terminal Emulators, Shells, Language tooling (ruff, uv, ...)
- Deno (nodejs runtime competitor)
- Operating Systems (Redox OS, Linux Kernel)
- Cryptocurrency projects

... and #text(blue.lighten(20%), link("https://github.com/rust-unofficial/awesome-rust")[many many more])

== Rust Intro
=== Hello World
- Install Rust toolchain via #text(blue.lighten(20%), link("https://rustup.rs/")[rustup.rs]):
  #codly(number-format: none)
  ```shell
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  ```

- Initiate a new project
  ```shell
  cargo init hello_world
  cd hello_world
  cargo run
  ```

== Rust Intro
=== Hello World
  #codly(number-format: numbering.with("1"))
```rust
fn main() {
  println!("Hello World!");
}
```

== Rust Web Backend Frameworks
- Famous choices: Actix Web, Rocket, Warp, Axum, Rouille, Tide, ...
- #text(blue.lighten(20%), link("https://www.rustfinity.com/blog/best-rust-web-frameworks")[Framework Comparison ])
- For benchmark results, see the #text(blue.lighten(20%), link("https://www.techempower.com/benchmarks/#hw=ph&test=fortune&section=data-r22&l=yyku7z-cn3")[Tech Empower Web Framework Benchmarks])


== ToDo Example
=== Initialize project
#codly(number-format: none)
```shell
cargo init todos
cd todos
```

=== Install dependencies
```shell
cargo add axum
cargo add tokio --features full
cargo add serde --features derive
cargo add uuid --features v4 --features serde
cargo add serde_json
```

== ToDo Example
#set text(size: 17pt)
=== Static Axum Server
#codly(number-format: numbering.with("1"))
```rust
use axum::{response::IntoResponse, routing::get, Router};

#[tokio::main]
async fn main() {
    let app = Router::new().route("/todos", get(list_todos));
    println!("Server running on http://127.0.0.1:3000");
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
```

== ToDo Example
#set text(size: 17pt)
#codly(header: [*Static Axum Server*], highlights: (
  (line: 1, fill: green),
  (line: 3, fill: blue),
))
```rust
use axum::{response::IntoResponse, routing::get, Router};

#[tokio::main]
async fn main() {
    let app = Router::new().route("/todos", get(list_todos));
    println!("Server running on http://127.0.0.1:3000");
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
```

== ToDo Example
#set text(size: 17pt)
#codly(header: [*Static Axum Server*], highlights: (
  (line: 7, start:5, fill: yellow),
  (line: 8, start:5, fill: yellow),
))
```rust
use axum::{response::IntoResponse, routing::get, Router};

#[tokio::main]
async fn main() {
    let app = Router::new().route("/todos", get(list_todos));
    println!("Server running on http://127.0.0.1:3000");
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
```

== ToDo Example
#set text(size: 17pt)
#codly(header: [*Static Axum Server*], highlights: (
  (line: 5, start:35, end: 42, fill: green),
  (line: 5, start:45, end: 47, fill: blue),
  (line: 5, start: 49, end: 58, fill: fuchsia),
))
```rust
use axum::{response::IntoResponse, routing::get, Router};

#[tokio::main]
async fn main() {
    let app = Router::new().route("/todos", get(list_todos));
    println!("Server running on http://127.0.0.1:3000");
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
```

== ToDo Example
#set text(size: 20pt)
#codly(header: [*handler function to list Todos*], highlights: (
  (line: 1, start: 10, end: 19, fill: fuchsia),
  (line: 1, start: 26, end: 42, fill: yellow),
))
```rust
async fn list_todos() -> impl IntoResponse {
    // Just return a static string for now
    return "Todos";
}
```

== ToDo Example
#set text(size: 20pt)
#codly(header: [*Add a TodoItem type / struct*], highlights: (
  (line: 4, fill: green),
  (line: 5, fill: blue),
  (line: 6, start: 5, fill: yellow),
  (line: 7, start: 5, fill: yellow),
  (line: 8, start: 5, fill: yellow),
))
```rust
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Serialize, Deserialize, Clone)]
struct TodoItem {
    id: Uuid,
    title: String,
    completed: bool,
}
```

== ToDo Example
#set text(size: 20pt)
#codly(header: [*Return static TodoItem as JSON*], highlights: (
(line: 3, start: 26, end: 44, fill: green),
(line: 9, start: 12, end: 27, fill: green),
))
```rust
use axum::Json;

async fn list_todos() -> Json<Vec<TodoItem>> {
    let todo = TodoItem {
        id: Uuid::new_v4(),
        title: "First Todo".into(),
        completed: false,
    };
    return Json(vec![todo]);
}
```

== ToDo Example
#set text(size: 20pt)
#codly(header: [*Add shared state*], highlights: (
  (line: 5, start: 5, fill: green),
))
```rust
use tokio::sync::RwLock;

#[derive(Default)]
struct AppState {
    todos: RwLock<Vec<TodoItem>>,
}
```

== ToDo Example
#set text(size: 20pt)
#codly(header: [*Add shared state*], highlights: (
  (line: 5, start: 5, fill: green),
  (line: 8, start: 9, fill: green),
))
```rust
use std::sync::Arc;

#[tokio::main]
async fn main() {
    let state = Arc::new(AppState::default());
    let app = Router::new()
        .route("/todos", get(list_todos))
        .with_state(state);
    ...
    axum::serve(listener, app).await.unwrap();
}
```

== ToDo Example
#set text(size: 17pt)
#codly(header: [*Use AppState in list handler*], highlights: (
  (line: 3, start: 21, end: 54, fill: green),
  (line: 4, start: 17, end: 34, fill: green),
))
```rust
use axum::extract::State;

async fn list_todos(State(state): State<Arc<AppState>>) -> Json<Vec<TodoItem>> {
    let todos = state.todos.read().await.clone();
    return Json(todos);
}
```

== ToDo Example
#set text(size: 20pt)
#codly(header: [*Add `POST /todos`*], highlights: (
  (line: 7, start: 41, end: 58, fill: green),
))
```rust
use std::sync::Arc;

#[tokio::main]
async fn main() {
    let state = Arc::new(AppState::default());
    let app = Router::new()
        .route("/todos", get(list_todos).post(create_todo))
        .with_state(state);
    ...
    axum::serve(listener, app).await.unwrap();
}
```

== ToDo Example
#set text(size: 17pt)
#codly(header: [*Add a request type for TodoItem*], highlights: (
  (line: 2, start: 8, end: 28, fill: fuchsia),
))
```rust
#[derive(Serialize, Deserialize, Clone)]
struct TodoItemCreateRequest {
    title: String,
    completed: bool,
}
```

== ToDo Example
#set text(size: 16pt)
#codly(header: [*Add `create_todo` handler function*], highlights: (
  (line: 2, start: 11, end: 15, fill: blue),
  (line: 2, start: 19, end: 38, fill: blue),
  (line: 3, start: 10, end: 16, fill: fuchsia),
  (line: 3, start: 25, end: 45, fill: fuchsia),
  (line: 4, start: 6, end: 19, fill: green),
  (line: 5, start: 21, end: 39, fill: blue),
  (line: 5, start: 5, end: 17, fill: yellow),
  (line: 8, start: 16, end: 28, fill: fuchsia),
  (line: 9, start: 20, end: 36, fill: fuchsia),
  (line: 11, start: 5, fill: yellow),
  (line: 12, start: 5, fill: green),
))
```rust
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
    Json(todo)
}
```

== ToDo Example
#set text(size: 20pt)
#codly(header: [*Add `DELETE /todo/{id}`*], highlights: (
  (line: 8, start: 9, end: 50, fill: green),
))
```rust
use axum::routing::delete;

#[tokio::main]
async fn main() {
    let state = Arc::new(AppState::default());
    let app = Router::new()
        .route("/todos", get(list_todos).post(create_todo))
        .route("/todos/{id}", delete(delete_todo))
        .with_state(state);
    ...
    axum::serve(listener, app).await.unwrap();
}
```


== ToDo Example
#set text(size: 15pt)
#codly(header: [*Add `DELETE /todo/{id}`*], highlights: (
  (line: 4, start: 10, end: 11, fill: fuchsia),
  (line: 5, start: 11, end: 15, fill: blue),
  (line: 5, start: 19, end: 38, fill: blue),
  (line: 6, start: 6, end: 15, fill: green),
  (line: 7, start: 21, end: 39, fill: blue),
  (line: 7, start: 5, end: 17, fill: yellow),
  (line: 8, start: 24, end: 35, fill: yellow),
  (line: 8, start: 64, end: 65, fill: fuchsia),
  (line: 9, start: 9, end: 26, fill: yellow),
  (line: 10, start: 9, end: 30, fill: green),
  (line: 12, start: 9, end: 29, fill: green),
))
```rust
use axum::{extract::Path, http::StatusCode};

async fn delete_todo(
    Path(id): Path<Uuid>,
    State(state): State<Arc<AppState>>
) -> StatusCode {
    let mut todos = state.todos.write().await;
    if let Some(pos) = todos.iter().position(|todo| todo.id == id) {
        todos.remove(pos);
        StatusCode::NO_CONTENT
    } else {
        StatusCode::NOT_FOUND
    }
}
```

== ToDo Example
=== Building a release version
#codly(number-format: none)
```shell
$> cargo build --release

$> ls -lah ./target/release/todos
-rwxr-xr-x@ 1 tim  staff   1.8M Jan 11 00:33 ./target/release/todos*
```



== Additional Notes
- Weekly newsletter: "This week in Rust"
- Wide Editor support: (RustRover, VSCode, Emacs, Vim, Zed, ...)
- Deep Dives: Crust of Rust
- Books: Which ones?
// TODO: compare cargo,axum,crate etc with equivalents in JS/PHP world