CREATE OR REPLACE VIEW v_movies_clean AS
SELECT
    movie_id,
    title,
    content_type,
    genre_primary,
    genre_secondary,
    release_year,
    duration_minutes,
    rating,
    language,
    country_of_origin,
    imdb_rating,
    is_netflix_original,
    added_to_platform,
    content_warning,
    number_of_seasons,
    number_of_episodes

FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY movie_id ORDER BY added_to_platform) AS rn
    FROM movies
)
WHERE rn = 1;