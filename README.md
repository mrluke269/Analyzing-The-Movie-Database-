# Analyzing The Movie Database

A dbt (data build tool) project that transforms raw movie data from The Movie Database (TMDb) into a dimensional star schema for analytics and reporting.

## 📋 Project Overview

This project uses dbt to create a robust data transformation pipeline that converts raw movie and credit data into an analytical-ready star schema. The data model enables efficient analysis of movie performance, cast/crew contributions, genre trends, and production company insights.

### Key Features

- **Star Schema Design**: Optimized dimensional model for analytical queries
- **Data Quality Tests**: Comprehensive testing on staging and mart layers
- **Modular Structure**: Clean separation of staging, intermediate, and mart layers
- **Documentation**: Extensive model and column-level documentation
- **Metrics Layer**: Pre-built analytical models for common use cases

## 🏗️ Project Structure

```
models/
├── staging/               # Raw data cleaning and type casting
│   ├── _src_movies.yml   # Source definitions
│   ├── stg_movies__raw_movies.sql
│   └── stg_movies__raw_credit.sql
│
├── intermediate/         # Business logic and transformations
│   └── bridges/         # Many-to-many relationship tables
│       ├── movie_actor_bridge.sql
│       ├── movie_company_bridge.sql
│       ├── movie_country_bridge.sql
│       ├── movie_crew_bridge.sql
│       ├── movie_genre_bridge.sql
│       ├── movie_key_bridge.sql
│       └── movie_language_bridge.sql
│
└── marts/               # Analytics-ready models
    ├── dimensions/      # Dimension tables
    │   ├── dim_actor.sql
    │   ├── dim_company.sql
    │   ├── dim_countries.sql
    │   ├── dim_crews.sql
    │   ├── dim_genres.sql
    │   ├── dim_keywords.sql
    │   └── dim_languages.sql
    │
    ├── fact/           # Fact tables
    │   └── fct_movies.sql
    │
    └── metrics/        # Pre-aggregated analytical models
        ├── revenue_by_actor.sql
        └── revenue_by_genre.sql
```

## 📊 Data Model

### Star Schema

The project implements a **star schema** with `fct_movies` as the central fact table, surrounded by dimension tables:

**Fact Table:**
- `fct_movies` - Core movie metrics (revenue, budget, ratings, etc.)

**Dimension Tables:**
- `dim_actor` - Actor information
- `dim_crews` - Crew member information (directors, writers, etc.)
- `dim_genres` - Movie genres
- `dim_company` - Production companies
- `dim_countries` - Production countries
- `dim_languages` - Spoken languages
- `dim_keywords` - Movie keywords/themes

**Bridge Tables:**
- Handle many-to-many relationships between facts and dimensions
- Enable proper star schema design while maintaining data integrity

### Data Flow

```
Raw Sources (Snowflake)
    ↓
Staging Layer (Type casting, basic cleaning)
    ↓
Intermediate Layer (JSON flattening, bridge tables)
    ↓
Marts Layer (Fact tables, dimensions, metrics)
```

## 🚀 Getting Started

### Prerequisites

- [dbt Core](https://docs.getdbt.com/docs/core/installation) >= 1.0.0 or [dbt Cloud](https://www.getdbt.com/product/dbt-cloud/)
- Snowflake account with access to TMDb raw data
- Python >= 3.7

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mrluke269/Analyzing-The-Movie-Database-.git
   cd Analyzing-The-Movie-Database-
   ```

2. **Install dbt dependencies:**
   ```bash
   dbt deps
   ```

3. **Configure your profile:**
   
   Create/update `~/.dbt/profiles.yml`:
   ```yaml
   default:
     target: dev
     outputs:
       dev:
         type: snowflake
         account: your_account
         user: your_username
         password: your_password
         role: your_role
         database: your_database
         warehouse: your_warehouse
         schema: your_schema
         threads: 4
   ```

4. **Test your connection:**
   ```bash
   dbt debug
   ```

### Running the Project

1. **Build all models:**
   ```bash
   dbt build
   ```

2. **Run specific layers:**
   ```bash
   # Run only staging models
   dbt run --select staging

   # Run only marts
   dbt run --select marts

   # Run a specific model and its dependencies
   dbt run --select +fct_movies
   ```

3. **Test data quality:**
   ```bash
   dbt test
   ```

4. **Generate documentation:**
   ```bash
   dbt docs generate
   dbt docs serve
   ```

## 📈 Usage Examples

### Analyzing Revenue by Genre

```sql
SELECT *
FROM {{ ref('revenue_by_genre') }}
ORDER BY total_revenue DESC
LIMIT 10;
```

### Analyzing Top Actors by Revenue

```sql
SELECT *
FROM {{ ref('revenue_by_actor') }}
ORDER BY total_revenue DESC
LIMIT 20;
```

### Custom Analysis: Movies by Multiple Dimensions

```sql
SELECT 
    f.title,
    f.revenue,
    f.budget,
    g.genre_name,
    a.actor_name,
    c.company_name
FROM {{ ref('fct_movies') }} f
JOIN {{ ref('movie_genre_bridge') }} gb ON f.movie_id = gb.movie_id
JOIN {{ ref('dim_genres') }} g ON gb.genre_id = g.genre_id
JOIN {{ ref('movie_actor_bridge') }} ab ON f.movie_id = ab.movie_id
JOIN {{ ref('dim_actor') }} a ON ab.actor_id = a.actor_id
JOIN {{ ref('movie_company_bridge') }} cb ON f.movie_id = cb.movie_id
JOIN {{ ref('dim_company') }} c ON cb.company_id = c.company_id
WHERE f.revenue > 100000000
ORDER BY f.revenue DESC;
```

## 🔧 Development Workflow

### Adding New Models

1. Create the SQL file in the appropriate directory
2. Add documentation in the corresponding YAML file
3. Run and test the model:
   ```bash
   dbt run --select your_model_name
   dbt test --select your_model_name
   ```
4. Update documentation:
   ```bash
   dbt docs generate
   ```

### Model Naming Conventions

- **Staging**: `stg_<source>__<table>`
- **Intermediate**: Descriptive names (e.g., `movie_genre_bridge`)
- **Dimensions**: `dim_<entity>`
- **Facts**: `fct_<entity>`
- **Metrics**: Descriptive names (e.g., `revenue_by_genre`)

## 📦 Dependencies

This project uses the following dbt packages:

- **dbt-labs/codegen** (0.13.1) - Code generation utilities
- **dbt-labs/dbt_utils** (1.3.1) - General utility macros
- **calogica/dbt_expectations** (0.10.3) - Advanced data quality tests

Install dependencies with:
```bash
dbt deps
```

## 🧪 Testing

The project includes comprehensive data quality tests:

- **Schema tests**: Uniqueness, not-null, relationships
- **Advanced tests**: Value ranges, accepted values
- **Custom tests**: Business logic validation

Run all tests:
```bash
dbt test
```

## 📚 Additional Resources

- [dbt Documentation](https://docs.getdbt.com/)
- [The Movie Database (TMDb) API](https://www.themoviedb.org/documentation/api)
- [Star Schema Design](https://en.wikipedia.org/wiki/Star_schema)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is open source and available under the MIT License.

## 👤 Author

**mrluke269**

---

*Built with ❤️ using dbt*
