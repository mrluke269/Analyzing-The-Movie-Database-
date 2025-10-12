# Analyzing-The-Movie-Database-
Using dbt to transform raw data from the movie database into a star schema model.

## Project Structure

This dbt project follows a layered approach to data transformation:

### Staging (`models/staging/`)
- **Purpose**: Source data transformations and cleaning
- **Materialization**: View (for lightweight queries)
- **Models**: 
  - `stg_movies__raw_movies` - Raw movie data
  - `stg_movies__raw_credit` - Raw credit/cast data

### Intermediate (`models/intermediate/`)
Dimensional model components organized into subdirectories:

#### Dimensions (`models/intermediate/dimensions/`)
- **Purpose**: Dimensional tables for the star schema
- **Materialization**: Table
- **Models**: `dim_actor`, `dim_genres`, `dim_company`, `dim_countries`, `dim_languages`, `dim_keywords`, `dim_crews`

#### Bridges (`models/intermediate/bridges/`)
- **Purpose**: Bridge tables for many-to-many relationships
- **Materialization**: Table
- **Models**: `movie_actor_bridge`, `movie_genre_bridge`, `movie_company_bridge`, `movie_country_bridge`, `movie_language_bridge`, `movie_key_bridge`, `movie_crew_bridge`

#### Fact (`models/intermediate/fact/`)
- **Purpose**: Fact tables containing measurable events
- **Materialization**: Table
- **Models**: `fct_movies`

### Marts (`models/marts/`)
- **Purpose**: Final analytics-ready tables optimized for specific business questions
- **Materialization**: Table (for performance)
- **Models**:
  - `revenue_by_actor` - Revenue and performance metrics aggregated by actor
  - `revenue_by_genre` - Revenue and performance metrics aggregated by genre

## Configuration

The project uses `dbt_project.yml` to configure materialization strategies:
- **Staging models**: Materialized as views for lightweight transformations
- **Intermediate models**: Materialized as tables for better query performance
- **Mart models**: Materialized as tables for optimal analytics performance

## Running the Project

To run the dbt models:
```bash
dbt run
```

To run tests:
```bash
dbt test
```

To build all models and run tests:
```bash
dbt build
```
