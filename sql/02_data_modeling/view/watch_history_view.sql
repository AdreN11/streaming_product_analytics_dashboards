CREATE OR REPLACE VIEW v_watch_history_clean AS
SELECT
    session_id,
    user_id,
    movie_id,
    watch_date,
    device_type,
    location_country,
    action,
    quality,
    is_download,

    -- Числовые поля
    watch_duration_minutes,
    progress_percentage,
    user_rating,

    -- Флаги досмотра
    progress_percentage >= 90 AS is_completed_90,
    progress_percentage >= 80 AS is_completed_80,

    -- Бакеты глубины просмотра
    CASE
        WHEN progress_percentage IS NULL THEN 'unknown'
        WHEN progress_percentage < 10 THEN '0-10%'
        WHEN progress_percentage < 50 THEN '10-50%'
        WHEN progress_percentage < 80 THEN '50-80%'
        WHEN progress_percentage < 90 THEN '80-90%'
        ELSE '90%+'
    END AS progress_bucket

FROM (
    -- Дедубликация: берём одну строку на session_id
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY session_id ORDER BY watch_date) AS rn
    FROM watch_history
)
WHERE rn = 1;