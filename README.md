# COVID-19 Data Analysis - SQL Queries

This repository contains SQL queries designed to perform data analysis on COVID-19 statistics. The project aims to explore and process data related to COVID-19 deaths, cases, population statistics, and trends over time, categorized by location (countries and continents). 

The analysis includes both basic data summarization and more advanced querying techniques such as aggregations, ranking, and trend analysis.

## Project Structure

This project is organized into two main SQL files, each focused on different aspects of the COVID-19 dataset:

1. **covid_deaths_analysis.sql**  
   - Focuses on basic statistical analysis of COVID-19 cases and deaths.
   - Queries in this file summarize population data, infection rates, and death rates across different locations (countries/continents).
   - It includes basic calculations, aggregations, and filtering based on various date ranges and locations.

2. **advanced_covid_analysis.sql**  
   - Contains advanced SQL queries that perform more in-depth analysis.
   - Includes window functions, ranking, and trend analysis for identifying the highest infection and death rates across locations.
   - Uses complex joins and subqueries to analyze trends in new cases and deaths, and calculate percentages for infection rates.

## Key Features

- **Data Summarization**: Basic queries to summarize key statistics such as total cases, total deaths, population, and infection/death rates.
- **Advanced Analysis**: Includes complex queries using window functions for ranking and calculating averages, as well as handling missing or incomplete data.
- **Trend Analysis**: Analyzing trends over time, such as peak infection rates and deaths on specific dates.
- **Data Integrity Checks**: Identifying and handling rows with missing or null values in key columns like `new_cases`, `new_deaths`, `total_cases`, and `population`.

## Prerequisites

To run the queries in this repository, ensure that you have the following:

- A working SQL database (e.g., MySQL, PostgreSQL).
- A COVID-19 dataset with relevant columns, such as:
  - `location` (Country/Region)
  - `date` (Date of the report)
  - `new_cases` (Number of new cases reported on a particular day)
  - `new_deaths` (Number of new deaths reported on a particular day)
  - `total_cases` (Total cases reported to date)
  - `total_deaths` (Total deaths reported to date)
  - `population` (Population of the location)

