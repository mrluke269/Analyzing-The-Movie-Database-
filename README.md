# Movie Database Analytics Pipeline

**Transforming raw movie data into analytics-ready dimensional models using dbt**

[![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)](https://www.getdbt.com/)
[![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)](https://www.snowflake.com/)

---

## Table of Contents
- [Project Overview](#project-overview)
- [Business Problem](#business-problem)
- [Technical Architecture](#technical-architecture)
- [Skills Demonstrated](#skills-demonstrated)
- [Data Model](#data-model)
- [Key Challenges Solved](#key-challenges-solved)
- [Project Structure](#project-structure)
- [How to Run](#how-to-run)
- [Sample Queries](#sample-queries)
- [Future Enhancements](#future-enhancements)

---

## Project Overview

This project demonstrates end-to-end analytics engineering by transforming raw movie database data into a production-ready **star schema** data warehouse. The pipeline processes semi-structured JSON data, handles complex many-to-many relationships, and creates dimensional models optimized for analytical queries.

**What This Project Does:**
- Extracts and stages raw movie and credit data from The Movie Database (TMDB)
- Flattens nested JSON structures containing cast, crew, genres, and production details
- Builds a comprehensive dimensional model following **Kimball methodology**
- Implements bridge tables to properly handle many-to-many relationships
- Creates analytics-ready fact and dimension tables for business intelligence

---

## Business Problem

Movie studios, streaming platforms, and entertainment analysts need to answer questions like:
- Which actors generate the highest box office revenue?
- How do different genres perform across regions and time periods?
- What production companies consistently produce profitable films?
- Which crew members (directors, writers) are associated with highly-rated movies?

**Challenge:** Raw movie data comes in semi-structured formats with nested JSON, making direct analysis difficult and inefficient.

**Solution:** This pipeline transforms complex raw data into a clean, queryable star schema that enables fast, accurate analytics.

---

## Technical Architecture

### **Data Flow**

```
Raw Data Sources (JSON/CSV)
         ↓
   Staging Layer
   - stg_movies__raw_movies
   - stg_movies__raw_credit
         ↓
 Intermediate Layer
   - Bridge Tables (7)
   - Handle many-to-many relationships
         ↓
     Mart Layer
   - Dimension Tables (7)
   - Fact Tables (1)
         ↓
  Analytics & BI Tools
```

### **Tech Stack**

| Layer | Technology |
|-------|------------|
| **Data Warehouse** | Snowflake |
| **Transformation** | dbt Core |
| **Version Control** | Git/GitHub |
| **Data Modeling** | Dimensional Modeling (Kimball) |
| **Testing** | dbt Tests |
| **Documentation** | dbt Docs |

---

## Skills Demonstrated

This project showcases proficiency in:

### **Analytics Engineering**
- ✅ **dbt Development** - Modular SQL transformations with Jinja templating
- ✅ **Dimensional Modeling** - Star schema design with fact and dimension tables
- ✅ **Data Modeling Patterns** - Bridge tables for many-to-many relationships
- ✅ **Incremental Models** - Efficient data processing strategies
- ✅ **Data Quality** - Comprehensive testing and validation

### **SQL & Data Warehousing**
- ✅ **Complex SQL** - Window functions, CTEs, lateral flattening
- ✅ **JSON Handling** - Parsing and flattening nested semi-structured data
- ✅ **Snowflake** - Platform-specific functions (`FLATTEN`, `PARSE_JSON`)
- ✅ **Performance Optimization** - Materialization strategies and indexing

### **Software Engineering**
- ✅ **Version Control** - Git workflow with 75+ commits
- ✅ **Code Organization** - Modular, maintainable project structure
- ✅ **Documentation** - Schema definitions and model descriptions
- ✅ **Testing** - Data quality tests and assertions

### **Business Analysis**
- ✅ **Requirements Translation** - Converting business questions into data models
- ✅ **Data Modeling** - Designing schemas for analytical workloads
- ✅ **Stakeholder Thinking** - Creating models for diverse data consumers

---

##  Data Model

### **Star Schema Design**

#### **Fact Table**
- `fct_movies` - Core movie metrics (revenue, budget, ratings, runtime)

#### **Dimension Tables**
- `dim_actor` - Actor information and attributes
- `dim_company` - Production companies
- `dim_countries` - Country details
- `dim_crews` - Crew members (directors, writers, etc.)
- `dim_genres` - Movie genres
- `dim_keywords` - Movie keywords and tags
- `dim_languages` - Language information

#### **Bridge Tables** (Many-to-Many Resolution)
- `movie_actor_bridge` - Links movies to actors
- `movie_company_bridge` - Links movies to production companies
- `movie_country_bridge` - Links movies to countries
- `movie_crew_bridge` - Links movies to crew members
- `movie_genre_bridge` - Links movies to genres
- `movie_key_bridge` - Links movies to keywords
- `movie_language_bridge` - Links movies to languages

### **Why Bridge Tables?**

Movies have many-to-many relationships with actors, genres, companies, etc. Bridge tables:
- Maintain referential integrity
- Enable flexible querying
- Support historical tracking
- Follow dimensional modeling best practices

---

## Key Challenges Solved

### **1. Nested JSON Data Processing**
**Challenge:** Raw credit data contained deeply nested JSON arrays for cast and crew.

**Solution:** 
```sql
-- Flattening cast JSON using LATERAL FLATTEN
select
  movie_id,
  c.value:id::string as actor_id,
  c.value:name::string as actor_name,
  c.value:character::string as character_name
from raw_credit,
lateral flatten(input => parse_json(cast_json)) as c
```

**Impact:** Transformed unusable nested data into queryable relational tables.

---

### **2. Many-to-Many Relationship Handling**
**Challenge:** Single movies have multiple actors, genres, countries, etc., and vice versa.

**Solution:** Implemented bridge tables following Kimball methodology to:
- Preserve all relationships without data duplication
- Enable accurate aggregations
- Maintain query performance

**Impact:** Created a flexible model that handles complex relationships accurately.

---

### **3. Data Quality & Completeness**
**Challenge:** Discovered 4,803 movies (representing $395B in revenue) without cast data.

**Solution:** 
- Implemented data quality tests
- Added null-handling logic
- Created data quality monitoring queries
- Documented data gaps for stakeholders

**Impact:** Ensured transparency about data limitations and prevented misleading analytics.

---

## Project Structure

```
├── analyses/              # Ad-hoc analytical queries
├── macros/               # Reusable SQL macros
├── models/
│   ├── staging/          # Raw data staging models
│   │   ├── stg_movies__raw_movies.sql
│   │   └── stg_movies__raw_credit.sql
│   ├── intermediate/
│   │   └── bridges/      # Bridge tables (7 models)
│   └── mart/
│       ├── dimensions/   # Dimension tables (7 models)
│       └── fact/         # Fact tables
├── seeds/                # Static reference data
├── snapshots/            # Type 2 SCD snapshots (if applicable)
├── tests/                # Custom data tests
├── dbt_project.yml       # dbt configuration
├── packages.yml          # dbt package dependencies
└── README.md            # This file
```

---

# Generate documentation
dbt docs generate
dbt docs serve


---

## Sample Queries

### **Top 10 Actors by Total Revenue**
```sql
select 
  a.actor_name,
  count(distinct f.movie_id) as total_movies,
  sum(f.revenue) as total_revenue,
  avg(f.vote_average) as avg_rating
from fct_movies f
join movie_actor_bridge mab on f.movie_id = mab.movie_id
join dim_actor a on mab.actor_id = a.actor_id
where f.revenue > 0
group by a.actor_name
order by total_revenue desc
limit 10;
```

### **Genre Performance Analysis**
```sql
select 
  g.genre_name,
  count(distinct f.movie_id) as movie_count,
  avg(f.revenue) as avg_revenue,
  avg(f.vote_average) as avg_rating,
  sum(f.revenue - f.budget) as total_profit
from fct_movies f
join movie_genre_bridge mgb on f.movie_id = mgb.movie_id
join dim_genres g on mgb.genre_id = g.genre_id
where f.revenue > 0 and f.budget > 0
group by g.genre_name
order by total_profit desc;
```

### **Production Company Success Metrics**
```sql
select 
  c.company_name,
  count(distinct f.movie_id) as total_movies,
  sum(f.revenue) / 1000000 as total_revenue_millions,
  avg(f.vote_average) as avg_rating,
  sum(case when f.revenue > f.budget then 1 else 0 end) * 100.0 / 
    count(*) as profit_rate_pct
from fct_movies f
join movie_company_bridge mcb on f.movie_id = mcb.movie_id
join dim_company c on mcb.company_id = c.company_id
group by c.company_name
having count(distinct f.movie_id) >= 10
order by total_revenue_millions desc
limit 20;
```

---

## Key Metrics

- **75+ Git Commits** - Iterative development with version control
- **17 Models** - Staging, intermediate, and mart layers
- **7 Bridge Tables** - Proper many-to-many relationship handling
- **Star Schema** - Production-ready dimensional model
- **Comprehensive Testing** - Data quality validation throughout

---

## Connect

**Project by:** Luke Mai (mrluke269)

I'm actively seeking **Analytics Engineering** and **Data Engineering** opportunities where I can apply these skills to solve real business problems.

**What I Bring:**
- Strong SQL and data modeling skills
- Experience with modern data stack (dbt, Snowflake)
- Understanding of dimensional modeling best practices
- Ability to translate business requirements into data solutions
- Software engineering mindset (version control, testing, documentation)

---

This project is available for educational and portfolio purposes.

---

**⭐ If you found this project interesting, please star the repository!**
