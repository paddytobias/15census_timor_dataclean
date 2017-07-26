# Data Processing R scriptlets for 2015 Timor-Leste Census data

*I am still refining these scripts for others to repeat my work.* 


The objective is to get the Excel data, published by the [General Directorate of Statistics](http://www.statistics.gov.tl/category/publications/census-publications/2015-census-publications/), into a state so that analysis can be conducted programmatically across all ~700 worksheets. 

The [Data folder](https://github.com/paddytobias/15census_timor_dataclean/tree/master/data) holds all 45 Excel workbooks as well as a pdf of the Preliminary Report of the 2015 Population and Housing Census.

## Scripts
The [Scripts folder](https://github.com/paddytobias/15census_timor_dataclean/tree/master/data) holds all of the scripts I have been writing.  

[Scripts_DataCleaning](https://github.com/paddytobias/15census_timor_dataclean/tree/master/Scripts/Scripts_DataCleaning) comprises five scripts used to clean and process the data, including:
* convert from .xls format into .csv format
* using the table names to name each .csv file
* removing any redundant features in the dataframes (e.g., all empty rows, two headings, all 'Totals' rows since can be computed by R, etc.)
* and insert all data tables into an SQLite database

[Scripts_DataReview](https://github.com/paddytobias/15census_timor_dataclean/tree/master/Scripts/Scripts_DataReview) holds a bunch of scripts I am currently writing to do meta-analysis over the data. One script currently being worked on is to see how each district compares to the national average, either above or below, in each relevant data-table.

## DOI
The DOI for this collection is 
[![DOI](https://zenodo.org/badge/96260480.svg)](https://zenodo.org/badge/latestdoi/96260480)
