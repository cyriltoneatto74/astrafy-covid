{{
  config(
    materialized='view',
    schema='ds_nyt_covid'
  )
}}

WITH tmp_us_states AS (
    SELECT
        *
        ,LAG(tpuss.confirmed_cases) OVER (PARTITION BY tpuss.state_fips_code ORDER BY tpuss.state_fips_code, date ASC) AS lag_confirmed_cases
        ,LAG(tpuss.deaths) OVER (PARTITION BY tpuss.state_fips_code ORDER BY tpuss.state_fips_code, date ASC) AS lag_deaths
        ,CASE EXTRACT(YEAR FROM tpuss.date)
            WHEN 2020 THEN sp.pop2020
            WHEN 2021 THEN sp.pop2020
            WHEN 2022 THEN sp.pop2022
            WHEN 2023 THEN sp.pop2023
        END AS year_population
    FROM {{ source('covid19_nyt', 'us_states') }} tpuss
    LEFT JOIN {{ source('ds_public_data', 'us_states_population') }} sp ON sp.fips = SAFE_CAST(tpuss.state_fips_code AS INT64) 
)

SELECT
  -- Primary key
  uss.date 
  ,uss.state_fips_code
  -- Global infos --
  ,uss.state_name
  ,uss.confirmed_cases
  ,uss.deaths
  ,IF(uss.confirmed_cases >= uss.lag_confirmed_cases, uss.confirmed_cases - uss.lag_confirmed_cases, 0)  AS new_confirmed_cases
  ,IF(uss.deaths >= uss.lag_deaths, uss.deaths - uss.lag_deaths, 0)  AS new_deaths
  -- Vaccination infos
  ,sv.daily_vaccinations
  -- Population infos
  ,uss.year_population
  ,SUM(uss.year_population) OVER (PARTITION BY uss.date) AS year_population_as
  -- Geo infos
  ,gs.geo_id 
  ,ST_SIMPLIFY(gs.state_geom, 10000) AS state_geom
FROM tmp_us_states uss
LEFT JOIN {{ source('geo_us_boundaries', 'states') }} gs ON gs.state_fips_code = uss.state_fips_code 
LEFT JOIN {{ source('ds_public_data', 'us_states_vaccinations') }} sv ON sv.date = uss.date AND sv.location = uss.state_name