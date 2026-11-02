-- Карточки: средний retention rate день 1, 7, 30
SELECT
    round(
        sumIf(retained_users, day_n = 1) / sumIf(cohort_size, day_n = 1),
        4
) AS day1_retention,

    round(
        sumIf(retained_users, day_n = 7) / sumIf(cohort_size, day_n = 7),
        4
    ) AS day7_retention,

    round(
        sumIf(retained_users, day_n = 30) / sumIf(cohort_size, day_n = 30),
        4
    ) AS day30_retention
FROM mart_retention;

-- Таблица retention по чекпоинтам
SELECT
    day_n,
    round(avg(retention_rate), 4) AS avg_retention_rate,
    sum(cohort_size) AS total_cohort_users,
    sum(retained_users) AS total_retained
FROM mart_retention
GROUP BY day_n
ORDER BY day_n;

-- Размеры когорт во времени
SELECT
    cohort_date,
    max(cohort_size) AS cohort_size
FROM mart_retention
GROUP BY cohort_date
ORDER BY cohort_date;