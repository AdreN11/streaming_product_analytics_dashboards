CREATE OR REPLACE VIEW v_search_logs_clean AS
SELECT
    search_id,
    user_id,
    search_query,
    search_date,
    results_returned,
    clicked_result_position,
    device_type,
    search_duration_seconds,
    had_typo,
    used_filters,
    location_country

FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY search_id ORDER BY search_date) AS rn
    FROM search_logs
)
WHERE rn = 1;