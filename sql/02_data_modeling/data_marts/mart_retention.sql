DROP TABLE IF EXISTS mart_retention;

CREATE TABLE mart_retention (
    cohort_date Date,
    day_n UInt16,
    cohort_size UInt64,
    retained_users UInt64,
    retention_rate Float64
)
ENGINE = MergeTree()
ORDER BY (cohort_date, day_n);

INSERT INTO mart_retention
WITH
-- Все даты активности каждого пользователя (просмотр + поиск)
user_activity AS (
    SELECT user_id, watch_date AS activity_date
    FROM v_watch_history_clean
    WHERE watch_date IS NOT NULL

    UNION DISTINCT

    SELECT user_id, search_date AS activity_date
    FROM v_search_logs_clean
    WHERE search_date IS NOT NULL
),

-- Дата первой активности = когорта
user_cohorts AS (
    SELECT
        user_id,
        min(activity_date) AS cohort_date
    FROM user_activity
    GROUP BY user_id
),

-- Активность с привязкой к когорте
activity_with_cohort AS (
    SELECT
        a.user_id,
        c.cohort_date,
        a.activity_date,
        dateDiff('day', c.cohort_date, a.activity_date) AS day_n
    FROM user_activity AS a
    INNER JOIN user_cohorts AS c
    ON a.user_id = c.user_id
),

-- Размер каждой когорты
cohort_sizes AS (
    SELECT
        cohort_date,
        countDistinct(user_id) AS cohort_size
    FROM user_cohorts
    GROUP BY cohort_date
),

-- Сколько пользователей когорты были активны на день N
retained AS (
    SELECT
        cohort_date,
        day_n,
        countDistinct(user_id) AS retained_users
    FROM activity_with_cohort
    WHERE day_n IN (0, 1, 7, 14, 30)
    GROUP BY cohort_date, day_n
)

SELECT
    r.cohort_date,
    r.day_n,
    cs.cohort_size,
    r.retained_users,
    round(r.retained_users / cs.cohort_size, 4) AS retention_rate
FROM retained AS r
INNER JOIN cohort_sizes AS cs
ON r.cohort_date = cs.cohort_date
ORDER BY r.cohort_date, r.day_n;
