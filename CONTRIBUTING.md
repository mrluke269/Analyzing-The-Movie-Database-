# Contributing to Analyzing The Movie Database

Thank you for your interest in contributing to this project! This document provides guidelines and instructions for contributing.

## 🌟 Ways to Contribute

- Report bugs and issues
- Suggest new features or enhancements
- Improve documentation
- Add new analytical models
- Optimize existing queries
- Write tests

## 🚀 Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/Analyzing-The-Movie-Database-.git
   cd Analyzing-The-Movie-Database-
   ```
3. **Set up your development environment** (see README.md)
4. **Create a new branch** for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 📝 Development Guidelines

### Code Style

- Follow dbt best practices
- Use clear, descriptive model names
- Include comprehensive documentation in YAML files
- Add comments for complex SQL logic
- Keep SQL formatting consistent (use 4-space indentation)

### Model Naming Conventions

Follow these conventions when creating new models:

- **Staging models**: `stg_<source>__<table>`
- **Intermediate models**: Descriptive names (e.g., `movie_genre_bridge`)
- **Dimension tables**: `dim_<entity>`
- **Fact tables**: `fct_<entity>`
- **Metrics/Analysis**: Descriptive names (e.g., `revenue_by_genre`)

### File Organization

Place new models in the appropriate directory:

```
models/
├── staging/      # Source data cleaning and standardization
├── intermediate/ # Business logic transformations
└── marts/        # Analytics-ready models
    ├── dimensions/
    ├── fact/
    └── metrics/
```

### Documentation Requirements

Every new model must include:

1. **SQL file** with the model logic
2. **YAML file** with:
   - Model description
   - Column descriptions
   - Data tests
   - Meta information (grain, related tables, etc.)

Example YAML structure:

```yaml
version: 2

models:
  - name: your_model_name
    description: >
      Clear description of what this model does and why it exists.
    columns:
      - name: column_name
        description: Column description
        tests:
          - unique
          - not_null
    meta:
      grain: "One row per X"
```

### Testing

All contributions should include appropriate tests:

1. **Schema tests**: Add in YAML files
   - `unique`
   - `not_null`
   - `relationships`
   - `accepted_values`

2. **Advanced tests**: Use dbt_expectations where applicable
   - Value range checks
   - Custom business logic

Run tests before submitting:
```bash
dbt test --select your_model_name+
```

## 🔄 Pull Request Process

1. **Update documentation**: Ensure README.md and YAML docs are current
2. **Run tests**: All tests must pass
   ```bash
   dbt test
   ```
3. **Generate docs**: Update dbt documentation
   ```bash
   dbt docs generate
   ```
4. **Commit your changes** with clear, descriptive messages:
   ```bash
   git commit -m "Add revenue analysis by director model"
   ```
5. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```
6. **Create a Pull Request** on GitHub
7. **Describe your changes**: Include:
   - What problem does this solve?
   - What models/files were added/changed?
   - Any breaking changes?
   - Screenshots (if UI/visualization changes)

### Pull Request Checklist

Before submitting, ensure:

- [ ] Code follows project style guidelines
- [ ] All tests pass (`dbt test`)
- [ ] Documentation is updated (YAML files, README if needed)
- [ ] Commit messages are clear and descriptive
- [ ] No sensitive data (passwords, keys, etc.) in code
- [ ] Models run successfully (`dbt run --select your_model+`)

## 🐛 Reporting Bugs

When reporting bugs, please include:

- **Description**: Clear description of the issue
- **Steps to reproduce**: How to recreate the bug
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **dbt version**: Run `dbt --version`
- **Environment**: Snowflake version, OS, etc.
- **Error messages**: Full error output if applicable

## 💡 Suggesting Features

Feature suggestions are welcome! Please include:

- **Use case**: Why is this feature needed?
- **Proposed solution**: How should it work?
- **Alternatives considered**: Other approaches you've thought about
- **Additional context**: Examples, mockups, etc.

## 🏗️ Adding New Models

### Example: Adding a New Metric

1. **Create the SQL file**:
   ```sql
   -- models/marts/metrics/revenue_by_director.sql
   SELECT
       dc.crew_id as director_id,
       dc.crew_name as director_name,
       SUM(m.revenue) as total_revenue,
       COUNT(DISTINCT m.movie_id) as total_movies,
       AVG(m.revenue) as avg_revenue_per_movie
   FROM {{ ref('fct_movies') }} m
   JOIN {{ ref('movie_crew_bridge') }} cb 
       ON m.movie_id = cb.movie_id
   JOIN {{ ref('dim_crews') }} dc 
       ON cb.crew_id = dc.crew_id
   WHERE cb.job = 'Director'
   GROUP BY 1, 2
   ORDER BY total_revenue DESC
   ```

2. **Create the YAML file**:
   ```yaml
   # models/marts/metrics/revenue_by_director.yml
   version: 2

   models:
     - name: revenue_by_director
       description: "Aggregated revenue metrics by movie director"
       columns:
         - name: director_id
           description: "Unique identifier for the director"
           tests:
             - unique
             - not_null
         - name: director_name
           description: "Name of the director"
         - name: total_revenue
           description: "Total box office revenue across all movies"
   ```

3. **Test the model**:
   ```bash
   dbt run --select revenue_by_director
   dbt test --select revenue_by_director
   ```

4. **Update docs and submit PR**

## 📞 Getting Help

- **Questions**: Open a GitHub issue with the "question" label
- **Discussions**: Use GitHub Discussions for general topics
- **Documentation**: Check the [dbt docs](https://docs.getdbt.com/)

## 📄 License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

## 🙏 Thank You!

Your contributions help make this project better for everyone. We appreciate your time and effort!

---

*Happy contributing! 🎬*
