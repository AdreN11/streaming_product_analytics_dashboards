-- Вовлеченность по типу устройства
SELECT
    device_type,
    sum(sessions) AS sessions,
    round(avg(avg_watch_duration), 2) AS avg_watch_duration,
    round(avg(completion_rate_90), 2) AS completion_rate_90,
    round(avg(completion_rate_80), 2) AS completion_rate_80
FROM mart_engagement
GROUP BY device_type;

-- Вовлеченность по типу контента
SELECT
    content_type,
    sum(sessions) AS sessions,
    round(avg(avg_watch_duration), 2) AS avg_watch_duration,
    round(avg(completion_rate_90), 2) AS completion_rate_90,
    round(avg(completion_rate_80), 2) AS completion_rate_80
FROM mart_engagement
GROUP BY content_type;

-- Топ 10 по жанру
SELECT
    genre_primary,
    sum(sessions) AS sessions,
    round(avg(completion_rate_90), 2) AS completion_rate_90,
    round(avg(completion_rate_80), 2) AS completion_rate_80
FROM mart_engagement
GROUP BY genre_primary
ORDER BY sessions DESC
LIMIT 10;

-- Вовлеченность по плану подписки
SELECT
    subscription_plan,
    sum(sessions) AS sessions,
    round(avg(avg_watch_duration), 2) AS avg_watch_duration,
    round(avg(completion_rate_90), 2) AS completion_rate_90,
    round(avg(completion_rate_80), 2) AS completion_rate_80
FROM mart_engagement
GROUP BY subscription_plan;