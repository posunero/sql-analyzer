-- Query to retrieve recent high and low temperature readings for New York City
-- from the deprecated OpenWeatherMap sample data.
-- The temperatures are converted from celsius to fahrenheit.
select (V:main.temp_max - 273.15) * 1.8000 + 32.00 as temp_max_far,
      (V:main.temp_min - 273.15) * 1.8000 + 32.00 as temp_min_far,
      cast(V:time as TIMESTAMP) time,
      V:city.coord.lat lat,
      V:city.coord.lon lon,
      V
from snowflake_sample_data.weather.WEATHER_14_TOTAL
where v:city.name = 'New York'
and   v:city.country = 'US'
order by time desc
limit 10;

-- Query to compare weather forecasts to actual weather readings
-- from the deprecated OpenWeatherMap sample data.
with
forecast as
(select ow.V:time         as prediction_dt,
       ow.V:city.name    as city,
       ow.V:city.country as country,
       cast(f.value:dt   as timestamp) as forecast_dt,
       f.value:temp.max  as forecast_max_k,
       f.value:temp.min  as forecast_min_k,
       f.value           as forecast
from snowflake_sample_data.weather.daily_16_total ow, lateral FLATTEN(input => V, path => 'data') f),

actual as
(select V:main.temp_max as temp_max_k,
       V:main.temp_min as temp_min_k,
       cast(V:time as timestamp)     as time_dt,
       V:city.name     as city,
       V:city.country  as country
from snowflake_sample_data.weather.WEATHER_14_TOTAL)

select cast(forecast.prediction_dt as timestamp) prediction_dt,
      forecast.forecast_dt,
      forecast.forecast_max_k,
      forecast.forecast_min_k,
      actual.temp_max_k,
      actual.temp_min_k
from actual
left join forecast on actual.city = forecast.city and
                     actual.country = forecast.country and
                     date_trunc(day, actual.time_dt) = date_trunc(day, forecast.forecast_dt)
where actual.city = 'New York'
and   actual.country = 'US'
order by forecast_dt desc, prediction_dt desc; 