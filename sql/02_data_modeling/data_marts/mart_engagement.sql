DROP TABLE IF EXISTS mart_engagement;

CREATE TABLE mart_engagement (
    device_type String DEFAULT '',
    content_type String DEFAULT '',
    genre_primary String DEFAULT '',
    subscription_plan String DEFAULT '',
    sessions UInt64,
    users UInt64,
    avg_watch_duration Nullable(Float64),
    completed_90_sessions UInt64,
    completed_80_sessions UInt64,
    completion_rate_90 Nullable(Float64),
    completion_rate_80 Nullable(Float64)
)
ENGINE = MergeTree()
ORDER BY (device_type, content_type, genre_primary, subscription_plan);

INSERT INTO mart_engagement
SELECT
    coalesce(wh.device_type, '') AS device_type,
    coalesce(m.content_type, '') AS content_type,
    coalesce(m.genre_primary, '') AS genre_primary,
    coalesce(u.subscription_plan, '') AS subscription_plan,

    count() AS sessions,
    countDistinct(wh.user_id) AS users,
    round(avg(wh.watch_duration_minutes), 2) AS avg_watch_duration,

    countIf(wh.is_completed_90) AS completed_90_sessions,
    countIf(wh.is_completed_80) AS completed_80_sessions,

    round(countIf(wh.is_completed_90) / count(), 4) AS completion_rate_90,
    round(countIf(wh.is_completed_80) / count(), 4) AS completion_rate_80

FROM v_watch_history_clean AS wh
LEFT JOIN v_movies_clean AS m ON wh.movie_id = m.movie_id
LEFT JOIN v_users_clean AS u ON wh.user_id = u.user_id
GROUP BY
    device_type,
    content_type,
    genre_primary,
    subscription_plan;