-- В терминале ввести докер команду, войти в оболочку, создать таблицы и вставить данные.
-- docker compose exec clickhouse clickhouse-client

CREATE DATABASE IF NOT EXISTS analytics;

USE analytics;

CREATE TABLE IF NOT EXISTS users (
    user_id String,
    email String,
    first_name String,
    last_name String,
    age Nullable(Float64),
    gender String,
    country String,
    state_province String,
    city String,
    subscription_plan String,
    subscription_start_date Nullable(Date),
    is_active Bool,
    monthly_spend Nullable(Float64),
    primary_device String,
    household_size Nullable(Float64),
    created_at DateTime64(6)
)
ENGINE = MergeTree()
ORDER BY user_id;

CREATE TABLE movies (
    movie_id String,
    title String,
    content_type String,
    genre_primary String,
    genre_secondary Nullable(String),
    release_year Nullable(Int32),
    duration_minutes Nullable(Float64),
    rating Nullable(String),
    language Nullable(String),
    country_of_origin Nullable(String),
    imdb_rating Nullable(Float64),
    production_budget Nullable(Float64),
    box_office_revenue Nullable(Float64),
    number_of_seasons Nullable(Float64),
    number_of_episodes Nullable(Float64),
    is_netflix_original Nullable(Bool),
    added_to_platform Nullable(Date),
    content_warning Nullable(Bool)
)
ENGINE = MergeTree()
ORDER BY movie_id;

CREATE TABLE IF NOT EXISTS watch_history (
    session_id String,
    user_id String,
    movie_id String,
    watch_date Date,
    device_type String,
    watch_duration_minutes Nullable(Float64),
    progress_percentage Nullable(Float64),
    action String,
    quality String,
    location_country String,
    is_download Bool,
    user_rating Nullable(Int32)
)
ENGINE = MergeTree()
ORDER BY (watch_date, user_id);

CREATE TABLE IF NOT EXISTS search_logs
(
    search_id String,
    user_id String,
    search_query Nullable(String),
    search_date Nullable(Date),
    results_returned Nullable(Float64),
    clicked_result_position Nullable(Float64),
    device_type Nullable(String),
    search_duration_seconds Nullable(Float64),
    had_typo Nullable(Bool),
    used_filters Nullable(Bool),
    location_country Nullable(String)
)
ENGINE = MergeTree()
ORDER BY search_id;