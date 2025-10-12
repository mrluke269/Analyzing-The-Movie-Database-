# Data Dictionary

This document provides a comprehensive overview of the data model, including all tables, columns, and their relationships.

## 📊 Star Schema Overview

This project implements a **star schema** design pattern optimized for analytical queries. The central fact table (`fct_movies`) contains measurable events (movie releases) and is surrounded by dimension tables that provide descriptive attributes.

## 🎯 Data Lineage

```
Raw Data (Snowflake)
    │
    ├─ raw_movies        → stg_movies__raw_movies    → [Intermediate Bridges] → Dimensions + Facts
    │                                                 ↓
    └─ raw_credit        → stg_movies__raw_credit    → dim_actor, dim_crews
```

---

## 📁 Staging Layer

### stg_movies__raw_movies

**Purpose**: Cleaned and type-cast movie data from the raw source.

**Grain**: One row per movie

| Column | Type | Description | Tests |
|--------|------|-------------|-------|
| id | string | Unique movie identifier | unique, not_null |
| title | string | Official release title | not_null |
| original_title | string | Original title before translation | - |
| release_date | date | Theatrical release date | - |
| budget | number | Production budget in USD | - |
| revenue | number | Total worldwide box office revenue in USD | - |
| runtime | number | Duration in minutes | range: 0-1000 |
| popularity | number | TMDb popularity score | - |
| vote_average | number | Average user rating (0-10 scale) | range: 0-10 |
| vote_count | number | Number of user votes | >= 0 |
| status | string | Movie status | values: 'Rumored', 'Post Production', 'Released' |
| original_language | string | ISO 639-1 language code | not_null |
| tagline | string | Movie tagline | - |
| overview | string | Plot summary | - |
| homepage | string | Official movie website URL | - |
| genres | variant (JSON) | Array of genre objects (id, name) | not_null |
| keywords | variant (JSON) | Array of keyword objects (id, name) | not_null |
| production_companies | variant (JSON) | Array of company objects (id, name) | not_null |
| production_countries | variant (JSON) | Array of country objects (iso_3166_1, name) | not_null |
| spoken_languages | variant (JSON) | Array of language objects (iso_639_1, name) | not_null |

**Known Data Quality Issues**:
- Popularity scores change daily; not suitable for historical comparisons
- Budget and revenue may be 0 when unknown

---

### stg_movies__raw_credit

**Purpose**: Cleaned cast and crew data from the raw credit source.

**Grain**: One row per movie

| Column | Type | Description | Tests |
|--------|------|-------------|-------|
| movie_id | string | Movie identifier (FK to movies) | - |
| title | string | Movie title | - |
| cast_json | variant (JSON) | Array of cast member objects | - |
| crew_json | variant (JSON) | Array of crew member objects | - |

---

## 🔗 Intermediate Layer - Bridge Tables

Bridge tables handle many-to-many relationships between movies and various attributes.

### movie_actor_bridge

**Purpose**: Links movies to actors

**Grain**: One row per movie-actor pair

| Column | Type | Description |
|--------|------|-------------|
| movie_id | string | Movie identifier (FK) |
| actor_id | string | Actor identifier (FK) |

---

### movie_crew_bridge

**Purpose**: Links movies to crew members

**Grain**: One row per movie-crew member pair

| Column | Type | Description |
|--------|------|-------------|
| movie_id | string | Movie identifier (FK) |
| crew_id | string | Crew member identifier (FK) |
| job | string | Job title (e.g., 'Director', 'Writer') |

---

### movie_genre_bridge

**Purpose**: Links movies to genres

**Grain**: One row per movie-genre pair

| Column | Type | Description |
|--------|------|-------------|
| movie_id | string | Movie identifier (FK) |
| genre_id | string | Genre identifier (FK) |

---

### movie_company_bridge

**Purpose**: Links movies to production companies

**Grain**: One row per movie-company pair

| Column | Type | Description |
|--------|------|-------------|
| movie_id | string | Movie identifier (FK) |
| company_id | string | Company identifier (FK) |

---

### movie_country_bridge

**Purpose**: Links movies to production countries

**Grain**: One row per movie-country pair

| Column | Type | Description |
|--------|------|-------------|
| movie_id | string | Movie identifier (FK) |
| country_code | string | ISO 3166-1 country code (FK) |

---

### movie_language_bridge

**Purpose**: Links movies to spoken languages

**Grain**: One row per movie-language pair

| Column | Type | Description |
|--------|------|-------------|
| movie_id | string | Movie identifier (FK) |
| language_code | string | ISO 639-1 language code (FK) |

---

### movie_key_bridge

**Purpose**: Links movies to keywords/themes

**Grain**: One row per movie-keyword pair

| Column | Type | Description |
|--------|------|-------------|
| movie_id | string | Movie identifier (FK) |
| keyword_id | string | Keyword identifier (FK) |

---

## 📊 Marts Layer

### Fact Table

#### fct_movies

**Purpose**: Central fact table containing measurable movie metrics

**Grain**: One row per movie

| Column | Type | Description | Tests |
|--------|------|-------------|-------|
| movie_id | string | Primary key, unique movie identifier | unique, not_null, relationships |
| title | string | Movie title (denormalized for convenience) | not_null |
| release_date | date | Theatrical release date | - |
| budget | number | Production budget in USD | - |
| revenue | number | Box office revenue in USD | - |
| runtime | number | Duration in minutes | - |
| popularity | number | TMDb popularity score | - |
| vote_average | number | Average user rating (0-10) | - |
| vote_count | number | Number of votes | - |
| status | string | Movie status | values: 'Released', 'Post Production', 'Rumored' |

**Related Dimensions**:
- dim_actor (via movie_actor_bridge)
- dim_crews (via movie_crew_bridge)
- dim_genres (via movie_genre_bridge)
- dim_company (via movie_company_bridge)
- dim_countries (via movie_country_bridge)
- dim_languages (via movie_language_bridge)
- dim_keywords (via movie_key_bridge)

---

### Dimension Tables

#### dim_actor

**Purpose**: Unique list of actors with attributes

**Grain**: One row per actor

| Column | Type | Description | Tests |
|--------|------|-------------|-------|
| actor_id | string | Primary key | unique, not_null |
| actor_name | string | Actor's name | - |
| gender | integer | Gender code (0=Not set, 1=Female, 2=Male) | - |

---

#### dim_crews

**Purpose**: Unique list of crew members (directors, writers, etc.)

**Grain**: One row per crew member

| Column | Type | Description | Tests |
|--------|------|-------------|-------|
| crew_id | string | Primary key | unique, not_null |
| crew_name | string | Crew member's name | - |
| gender | integer | Gender code | - |

---

#### dim_genres

**Purpose**: Unique list of movie genres

**Grain**: One row per genre

| Column | Type | Description | Tests |
|--------|------|-------------|-------|
| genre_id | number | Primary key | unique, not_null |
| genre_name | string | Genre name (e.g., 'Action', 'Comedy') | not_null |

**Common Values**: Action, Adventure, Animation, Comedy, Crime, Documentary, Drama, Family, Fantasy, History, Horror, Music, Mystery, Romance, Science Fiction, Thriller, War, Western

---

#### dim_company

**Purpose**: Unique list of production companies

**Grain**: One row per company

| Column | Type | Description | Tests |
|--------|------|-------------|-------|
| company_id | number | Primary key | unique, not_null |
| company_name | string | Company name | not_null |

**Examples**: Warner Bros., Universal Pictures, Paramount Pictures, 20th Century Fox, Columbia Pictures

---

#### dim_countries

**Purpose**: Unique list of production countries

**Grain**: One row per country

| Column | Type | Description | Tests |
|--------|------|-------------|-------|
| country_code | string | ISO 3166-1 country code (primary key) | unique, not_null |
| country_name | string | Country name | not_null |

**Examples**: US (United States), GB (United Kingdom), FR (France), DE (Germany)

---

#### dim_languages

**Purpose**: Unique list of spoken languages

**Grain**: One row per language

| Column | Type | Description | Tests |
|--------|------|-------------|-------|
| language_code | string | ISO 639-1 language code (primary key) | unique, not_null |
| language_name | string | Language name | not_null |

**Examples**: en (English), es (Spanish), fr (French), de (German)

---

#### dim_keywords

**Purpose**: Unique list of movie keywords/themes

**Grain**: One row per keyword

| Column | Type | Description | Tests |
|--------|------|-------------|-------|
| keyword_id | number | Primary key | unique, not_null |
| keyword_name | string | Keyword text | not_null |

**Purpose**: Used for thematic analysis and content categorization

---

### Metrics / Analytical Models

#### revenue_by_genre

**Purpose**: Aggregated revenue and performance metrics by genre

**Grain**: One row per genre

| Column | Type | Description |
|--------|------|-------------|
| genre_id | number | Genre identifier |
| genre_name | string | Genre name |
| total_revenue | number | Sum of all movie revenues in genre |
| total_movies | number | Count of movies in genre |
| avg_revenue_per_movie | number | Average revenue per movie |
| total_profit | number | Sum of (revenue - budget) |
| avg_rating | number | Average vote_average for genre |

**Use Cases**:
- Identify highest-grossing genres
- Compare genre performance
- Trend analysis by genre

---

#### revenue_by_actor

**Purpose**: Aggregated revenue and performance metrics by actor

**Grain**: One row per actor

| Column | Type | Description |
|--------|------|-------------|
| actor_id | string | Actor identifier |
| total_revenue | number | Sum of all movie revenues actor appeared in |
| total_movies | number | Count of movies actor appeared in |
| avg_revenue_per_movie | number | Average revenue per movie |
| total_profit | number | Sum of (revenue - budget) |
| avg_rating | number | Average vote_average for actor's movies |

**Use Cases**:
- Identify top box office performers
- Actor career analysis
- Casting decisions

---

## 🔍 Common Query Patterns

### Join Pattern: Fact to Dimension via Bridge

```sql
SELECT 
    f.title,
    d.dimension_attribute
FROM {{ ref('fct_movies') }} f
JOIN {{ ref('bridge_table') }} b 
    ON f.movie_id = b.movie_id
JOIN {{ ref('dimension_table') }} d 
    ON b.dimension_id = d.dimension_id
```

### Example: Movies with Genre and Actor

```sql
SELECT 
    f.title,
    f.revenue,
    g.genre_name,
    a.actor_name
FROM {{ ref('fct_movies') }} f
JOIN {{ ref('movie_genre_bridge') }} gb 
    ON f.movie_id = gb.movie_id
JOIN {{ ref('dim_genres') }} g 
    ON gb.genre_id = g.genre_id
JOIN {{ ref('movie_actor_bridge') }} ab 
    ON f.movie_id = ab.movie_id
JOIN {{ ref('dim_actor') }} a 
    ON ab.actor_id = a.actor_id
WHERE f.revenue > 100000000
```

---

## 📈 Data Volume Estimates

| Table | Estimated Rows | Update Frequency |
|-------|----------------|------------------|
| fct_movies | ~10,000 | Daily |
| dim_actor | ~50,000 | Weekly |
| dim_crews | ~100,000 | Weekly |
| dim_genres | ~20 | Rarely |
| dim_company | ~5,000 | Monthly |
| movie_actor_bridge | ~200,000 | Daily |
| movie_crew_bridge | ~300,000 | Daily |

---

## 🔐 Data Governance

### Sensitive Data
- No PII (Personally Identifiable Information) in this dataset
- All data is publicly available through TMDb API

### Data Retention
- Historical data maintained indefinitely
- Daily snapshots recommended for popularity scores

### Data Quality
- Automated tests run on all models
- Known issues documented in YAML meta sections

---

## 📚 Additional Resources

- [TMDb API Documentation](https://www.themoviedb.org/documentation/api)
- [Star Schema Design Principles](https://en.wikipedia.org/wiki/Star_schema)
- [dbt Best Practices](https://docs.getdbt.com/guides/best-practices)

---

*Last Updated: 2025-10-12*
