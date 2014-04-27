# How to Use run_analysis.R

This R script takes raw data from the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) and generates summary statistics. The output file will be called "tidy.txt" and will be created in a subdirectory of the current working directory called "work". If the "work" directory does not exist, it will be created. If the file "work/tidy.txt" already exists, it will be overwritten.

## Repository Contents

* [README.md](README.md) - this file.
* [CodeBook.md](CodeBook.md) - a description of the output file.
* [run_analysis.R](run_analysis.R) - The R script

## Requirements

* R - This was verified with R version 3.0.3 (2014-03-06) -- "Warm Puppy" on the x86_64-apple-darwin12.5.0 (64-bit) platform.
* The [plyr](http://cran.r-project.org/web/packages/plyr/index.html) package - This was verified with version 1.8.1 of the package.

## Usage

You may run the script from the command line like this:
```sh
R --no-save < run_analysis.R
```

Alternately you may run the script from within R like this:
```R
source( 'run_analysis.R' )
```

The script will create a directory called 'work' if it does not exist. It will also download and unzip the raw data set if it is not available. Finally, the script will calculate summary statistics and write the result to 'work/tidy.txt'. More details on the output file are available in the [CodeBook](CodeBook.md).

## Notes
This was prepared by Carlos Macasaet for course project for the [Getting and Cleaning Data](https://www.coursera.org/course/getdata) course of the [Data Science specialization](https://www.coursera.org/specialization/jhudatascience/1) offered by Johns Hopkins University and Coursera.
