# Tools for the COVID-19 outbreak

This repository contains a set of tools for the analysis of the COVID-19 data we have so far. It uses the dataset from John Hopkins University, found here: https://github.com/CSSEGISandData/COVID-19 as the basis for the work.

## Quick Breakdown of what is in here:

### cmd/cleanup

Go program for cleaning up the JHU dataset.

The data are in a pretty bad shape:

* CSV files contains byte-order marks. This is not useful.
* There are files with CRLF and LF endings in here, making the data set inconsistent.
* There are 3 ways of representing dates, none of which are standard.

The program runs through the lines and normalizes them. In particular, it represents time stamps as RFC3339.



