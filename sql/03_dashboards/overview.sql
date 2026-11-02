-- Запросы для дашборда

-- Карточка: активность за последний день данных
SELECT
    dau
FROM mart_daily_activity
ORDER BY activity_date DESC
LIMIT 1;

-- Карточка: средняя активность за последнюю неделю.
SELECT
    toStartOfWeek(activity_date) AS week,
    round(avg(dau), 1) AS avg_dau
FROM mart_daily_activity
GROUP BY week
ORDER BY week DESC
LIMIT 1;

-- График(по дням) активности за последние 30 дней
SELECT
    activity_date,
    dau
FROM mart_daily_activity
ORDER BY activity_date DESC
LIMIT 30;

-- График(по месяцам) активности за все время
SELECT
    toStartOfMonth(activity_date) AS month,
    round(avg(dau), 1) AS avg_dau
FROM mart_daily_activity
GROUP BY month
ORDER BY month;

-- График(по неделям) активности за все время
SELECT
    toStartOfWeek(activity_date) AS week,
    round(avg(dau), 1) AS avg_dau
FROM mart_daily_activity
GROUP BY week
ORDER BY week;

-- Карточки: средняя просмотр за последнюю неделю и метрика досмотра 90%
SELECT
    toStartOfWeek(activity_date) AS week,
    round(avg(avg_watch_duration), 2) AS avg_watch_duration,
    round(avg(completion_rate_90), 2) AS completion_rate_90
FROM mart_daily_activity
GROUP BY week
ORDER BY week DESC
LIMIT 1;