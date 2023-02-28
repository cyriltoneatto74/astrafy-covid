# Astrafy Covid Model:

This model is based on several sources:
- The New York Times US Coronavirus Database: https://github.com/nytimes/covid-19-data
- US Vaccinations: https://github.com/owid/covid-19-data/tree/master/public/data/vaccinations/
- US Population: https://worldpopulationreview.com/states
- States Boundaries: Bigquery Public Data

Using this model, we aim to gain insights into the global state of COVID-19, explore correlations between cases, deaths, and vaccinations, and identify patterns.

We took "us_states" table from the New York Time because is the only one with data till in 2023.
The model could be improved with more reliable and detailed data, such as population data at a daily or monthly level of granularity. 
Additionally, there are some missing data points, such as the 2021 population figures.
It could be also interesting to improve the model and analysis with a forecast on the next 14 days or 28 days.

To access the Looker Studio dashboard for this model, please visit: https://lookerstudio.google.com/reporting/9bfbc430-c68d-404e-9b95-78c5ca570e51/page/BChGD