# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive README.md with project overview, setup instructions, and usage examples
- CONTRIBUTING.md with development guidelines and contribution process
- DATA_DICTIONARY.md with complete data model documentation
- LICENSE file (MIT)
- GitHub issue templates for bug reports and feature requests
- Pull request template for standardized PR submissions
- Proper dbt_project.yml configuration with layer-specific materializations
- .gitattributes for consistent line endings

### Changed
- Updated dbt_project.yml to remove example configuration
- Configured appropriate materializations for each model layer:
  - Staging: views
  - Intermediate: views (bridges as tables)
  - Marts: tables (metrics as views)

### Documentation
- Documented all staging models with comprehensive YAML schemas
- Added data quality tests across all layers
- Documented star schema design and relationships
- Created visual data lineage documentation
- Added common query patterns and examples

## [1.0.0] - Initial Release

### Added
- Star schema data model for movie analytics
- Staging layer with source data cleaning
- Intermediate layer with bridge tables for many-to-many relationships
- Marts layer with dimensions, facts, and analytical models
- Dimensions: actors, crews, genres, companies, countries, languages, keywords
- Fact table: movies with key financial and performance metrics
- Analytical models: revenue by genre, revenue by actor
- Data quality tests using dbt and dbt_expectations
- Integration with dbt packages: codegen, dbt_utils, dbt_expectations

---

*For detailed information about changes, see the commit history or pull requests.*
