DROP TABLE IF EXISTS mart_daily_activity;

CREATE TABLE mart_daily_activity (
    activity_date Date,
    dau UInt64,
    watch_users UInt64,
    search_users UInt64,
    watch_sessions UInt64,
    avg_watch_duration Nullable(Float64),
    completed_90_sessions UInt64,
    completed_80_sessions UInt64,
    completion_rate_90 Nullable(Float64),
    completion_rate_80 Nullable(Float64)
)
ENGINE = MergeTree()
ORDER BY activity_date;

INSERT INTO mart_daily_activity
WITH
watch_users AS (
    SELECT
        watch_date AS activity_date,
        user_id
    FROM v_watch_history_clean
    WHERE watch_date IS NOT NULL
),

search_users AS (
    SELECT
        search_date AS activity_date,
        user_id
    FROM v_search_logs_clean
    WHERE search_date IS NOT NULL
),

all_active AS (
    SELECT activity_date, user_id FROM watch_users
    UNION DISTINCT
    SELECT activity_date, user_id FROM search_users
),

dau AS (
    SELECT
        activity_date,
        countDistinct(user_id) AS active_users
    FROM all_active
    GROUP BY activity_date
),

watch_stats AS (
    SELECT
        watch_date AS activity_date,
        countDistinct(user_id) AS watch_users,

        count() AS watch_sessions,
        round(avg(watch_duration_minutes), 2) AS avg_watch_duration,

        countIf(is_completed_90) AS completed_90_sessions,
        countIf(is_completed_80) AS completed_80_sessions,

        round(countIf(is_completed_90) / count(), 4) AS completion_rate_90,
        round(countIf(is_completed_80) / count(), 4) AS completion_rate_80
    FROM v_watch_history_clean
    WHERE watch_date IS NOT NULL
    GROUP BY watch_date
),

search_stats AS (
    SELECT
        search_date AS activity_date,
        countDistinct(user_id) AS search_users
    FROM v_search_logs_clean
    WHERE search_date IS NOT NULL
    GROUP BY search_date
)

SELECT
    d.activity_date AS activity_date,
    d.active_users AS dau,

    coalesce(w.watch_users, 0) AS watch_users,
    coalesce(s.search_users, 0) AS search_users,
    coalesce(w.watch_sessions, 0) AS watch_sessions,

    w.avg_watch_duration AS avg_watch_duration,

    coalesce(w.completed_90_sessions, 0) AS completed_90_sessions,
    coalesce(w.completed_80_sessions, 0) AS completed_80_sessions,

    w.completion_rate_90 AS completion_rate_90,
    w.completion_rate_80 AS completion_rate_80
FROM dau AS d
LEFT JOIN watch_stats AS w ON d.activity_date = w.activity_date
LEFT JOIN search_stats AS s ON d.activity_date = s.activity_date;