use axum::{
    async_trait,
    extract::{FromRef, FromRequestParts},
    http::{request::Parts, StatusCode},
    routing::get,
    response::IntoResponse,
    Router,
};
use sqlx::postgres::{PgPool, PgPoolOptions};
use sqlx::Row;
use serde::{Serialize};
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

use std::{net::SocketAddr, time::Duration};


#[derive(Serialize)]
pub struct Todo {
    id: i32,
    message: String,
    description: String,
}


#[tokio::main]
async fn main() {
    tracing_subscriber::registry()
        .with(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| "example_tokio_postgres=debug".into()),
        )
        .with(tracing_subscriber::fmt::layer())
        .init();

    let db_connection_str = "postgresql://rust:1111@postgres:5432/lab17".to_string();

    // setup connection pool
    let pool = PgPoolOptions::new()
        .max_connections(5)
        .connect_timeout(Duration::from_secs(3))
        .connect(&db_connection_str)
        .await
        .expect("can't connect to database");

    let app = Router::new()
        .route("/", get(home))
        .route("/rust/test", get(test))
        .route("/v1/todos/list", get(list_todos))
        .with_state(pool);

    let addr = SocketAddr::from(([0, 0, 0, 0], 3000));
    tracing::debug!("listening on {}", addr);
    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await
        .unwrap();
}

struct DatabaseConnection(sqlx::pool::PoolConnection<sqlx::Postgres>);

#[async_trait]
impl<S> FromRequestParts<S> for DatabaseConnection
where
    PgPool: FromRef<S>,
    S: Send + Sync,
{
    type Rejection = (StatusCode, String);

    async fn from_request_parts(_parts: &mut Parts, state: &S) -> Result<Self, Self::Rejection> {
        let pool = PgPool::from_ref(state);

        let conn = pool.acquire().await.map_err(internal_error)?;

        Ok(Self(conn))
    }
}

//Методы обработки запросов

async fn home(
    DatabaseConnection(_conn): DatabaseConnection,
) -> &'static str {
    "Home page"
}

async fn test(
    DatabaseConnection(_conn): DatabaseConnection,
) -> &'static str {
    "Test query. lab16"
}

async fn list_todos(
    DatabaseConnection(conn): DatabaseConnection,
) -> impl IntoResponse {
    let mut conn = conn;

    let result = sqlx::query(
        "SELECT *
         FROM todos",
    )
    .fetch_all(&mut conn)
    .await
    .unwrap();

    let mut todos:Vec<Todo> = Vec::new();

    for (_idx, row) in result.iter().enumerate() {
        let todo_item = Todo {
            id: row.get::<i32, &str>("id"),
            message: row.get::<String, &str>("message"),
            description: row.get::<String, &str>("description"),
        };
        todos.push(todo_item);
    }
    let json = serde_json::to_string(&todos).unwrap();
    (
        StatusCode::OK,
        json
    )
}

fn internal_error<E>(err: E) -> (StatusCode, String)
where
    E: std::error::Error,
{
    (StatusCode::INTERNAL_SERVER_ERROR, err.to_string())
}