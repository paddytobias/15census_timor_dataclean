# 2015 Timor-Leste Census data: Data Processing and Analysis in R scriptlets

*I am still refining these scripts for others to repeat my work.* 


The objective is to get the Excel data, published by the [General Directorate of Statistics](http://www.statistics.gov.tl/category/publications/census-publications/2015-census-publications/), into a state so that analysis can be conducted programmatically across all ~700 worksheets. 

The [Data folder](https://github.com/paddytobias/15census_timor_dataclean/tree/master/data) holds all 45 Excel workbooks as well as a pdf of the Preliminary Report of the 2015 Population and Housing Census.

## Scripts

The [Scripts folder](https://github.com/paddytobias/15census_timor_dataclean/tree/master/data) holds all of the scripts I have been writing to process and analyse.

### Data Cleaning
[Scripts_DataCleaning](https://github.com/paddytobias/15census_timor_dataclean/tree/master/Scripts/Scripts_DataCleaning) comprises five scripts used to clean and process the data, including:
* convert from .xls format into .csv format
* using the table names to name each .csv file
* removing any redundant features in the dataframes (e.g., all empty rows, two headings, all 'Totals' rows since can be computed by R, etc.)
* and insert all data tables into an SQLite database

### Data Review
*These scripts must be run after the DataCleaning scripts because they rely on the data being processed and “clean”.* 

[Scripts_DataReview](https://github.com/paddytobias/15census_timor_dataclean/tree/master/Scripts/Scripts_DataReview) holds a bunch of scripts I am currently writing to do meta-analysis over the data. 

DataReview is now including a script to create a table for each district that compares its totals to the national average and counts the number of times this is above or below, in relevant census data-table. The plan is to then remove all NA rows from these tables and then cbind district tables together to get a national overview of the district breakdown

## DOI

Please feel free to use these scripts for your own work, but if you do, please site their origin using the DOI for this collection: 
[![DOI](https://zenodo.org/badge/96260480.svg)](https://zenodo.org/badge/latestdoi/96260480)
