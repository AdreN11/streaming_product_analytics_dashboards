CREATE OR REPLACE VIEW v_users_clean AS
SELECT
    user_id,
    email,
    first_name,
    last_name,
    age,
    gender,
    country,
    state_province,
    city,
    subscription_plan,
    subscription_start_date,
    is_active,
    monthly_spend,
    primary_device,
    household_size,
    created_at,

    -- Возрастные группы
    CASE
        WHEN age IS NULL THEN 'unknown'
        WHEN age < 18 THEN 'under_18'
        WHEN age < 25 THEN '18-24'
        WHEN age < 35 THEN '25-34'
        WHEN age < 45 THEN '35-44'
        WHEN age < 55 THEN '45-54'
        WHEN age < 65 THEN '55-64'
        ELSE '65+'
    END AS age_group,

    -- Удобный флаг наличия тарифа
    subscription_plan IS NOT NULL AND subscription_plan != '' AS has_subscription_plan

FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at) AS rn
    FROM users
)
WHERE rn = 1;