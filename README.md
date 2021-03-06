# 2015 Timor-Leste Census data: Data Processing and Analysis in R scripts


The objective is to get the Excel data, published by the [General Directorate of Statistics](http://www.statistics.gov.tl/category/publications/census-publications/2015-census-publications/), into a tidy state so that meta-analyses can be conducted programmatically across all 700-800 worksheets. 

You can download this repository and run the commands (described below) to reproduce the file and image outputs. 

## Data
The [Data folder](https://github.com/paddytobias/15census_timor_dataclean/tree/master/data) holds all 45 Excel workbooks as well as a pdf of the Preliminary Report of the 2015 Population and Housing Census.

## Scripts

The [Scripts folder](https://github.com/paddytobias/15census_timor_dataclean/tree/master/Scripts) holds all of the scripts I have been writing to process and analyse.

### Data Cleaning
[Scripts_DataCleaning](https://github.com/paddytobias/15census_timor_dataclean/tree/master/Scripts/Scripts_DataCleaning) comprises five scripts used to clean and process the data, including:
* convert from .xls format into .csv format
* using the table names to name each .csv file
* removing any redundant features in the dataframes (e.g., all empty rows, two headings, all 'Totals' rows since can be computed by R, all commas in numbers with 4 or more characters, etc.)
* and insert all data tables into an SQLite database

### Data Review
*These scripts must be run after the DataCleaning scripts because they rely on the data being processed and “clean”.* 

[Scripts_DataReview](https://github.com/paddytobias/15census_timor_dataclean/tree/master/Scripts/Scripts_DataReview) holds a bunch of scripts I am currently writing to do meta-analysis over the data. 

DataReview is now including one script ([DistrictReview_allDistricts](https://github.com/paddytobias/15census_timor_dataclean/blob/master/Scripts/Scripts_DataReview/DistrictReview_allDistricts.R)) to create a table for each district that compares its totals to the national average and separately counts the number of times this is above or below. These numbers are only collected on relevant census data-tables; all other data-tables are given NAs. The plan is to then remove all NA rows from these tables and then cbind district tables together to get a national overview of the district breakdown of average comparisons. The script also outputs these district comparions to the national average for each census data-tables.


## Processing the data yourself

The prerequisite for running these scripts is the [latest download of R](https://cran.r-project.org/mirrors.html).

Then you will need to download this Git repository. After you have done this, run the scripts with the following commands:

### Data Cleaning: 
1. Extract all 800 worksheets from the 46 census workbooks

`Rscript Scripts/Scripts_DataCleaning/1.ConvertingXLStoCSV.R`

2. Rename the filenames of worksheets with table names of each

`Rscript Scripts/Scripts_DataCleaning/2.RenameOldtoNew.R`

3. Collapse the headers into one row

`Rscript Scripts/Scripts_DataCleaning/3.collapseHeader.R`

`Rscript Scripts/Scripts_DataCleaning/4.finalCollapse.R`

4. Do a final clean

`Rscript Scripts/Scripts_DataCleaning/5.finalClean.R`

### Reviewing the data:
 
5. Review all districts by how they compare to the national average for each table variable (where relevant). Upon running this you will get a folder for each district holding the mean comparison results for all tables that the district appears in. The folders will also include a `Review<<district name>>.csv` file that gives an overview of the district’s performance. Find out more by running this:

`Rscript Scripts/Scripts_DataReview/1.DistrictReview_allDistricts.R`


6. Aggregates all of the totals for each district in terms of how many times in the census data it was above and below the national average, and how many times it was the national minimum and national maximum. This script outputs a file called “master_dataReview.csv” in the folder “data/data_Review/“. It relies on the previous script to be run (i.e., 1.DistrictReview_allDistricts.R).

`Rscript Scripts/Scripts_DataReview/2.aggregateTotals.R`

### National graphs of the data:

Once you have run through the scripts above, the follow graphing scripts can be run. 

* A script for polygon graphs of the “master_dataReview.csv” so you can see the national overview and how each district compares per variable. Output can be found in “data/graphs/nationalResults”.

`Rscript Scripts/Scripts_Graphing/Polygons_comparingtoNationalResults.R`

* A script that will do a check on which data tables have only district data in it (i.e., just the 13 districts, no subdistrict data) (output of this is found in "data/data_check”). It then creates polygon graphs for national overview per variable of the relevant data tables. Output can be found in “data/graphs/districtOnly/“. There should be 60 graphs found here.

`Rscript Scripts/Scripts_Graphing/Polygons_districtOnly.R`


## How to reference this work

Please feel free to use these scripts for your own work, but if you do, please cite the origin using the reference below and the DOI for this collection:

Tobias P, 2017, “2015 Timor-Leste Census data: Data Processing and Analysis in R scriptlets”, GitHub, [https://github.com/paddytobias/15census_timor_dataclean](https://github.com/paddytobias/15census_timor_dataclean), 
[![DOI](https://zenodo.org/badge/96260480.svg)](https://zenodo.org/badge/latestdoi/96260480)


