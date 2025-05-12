# Opioid vs.Unemployment Analysis

This project explores how annual unemployment rates relate to opioid‐related hospitalization rates across nine Canadian provinces between 2016 and 2024.

##Data Sources

**Opioid hospitalizations:**
Substance-related Overdose and Mortality Surveillance Task Group on behalf of the Council of Chief Medical Officers of Health.[Opioid and Stimulant related Harms in Canada.](https://health-infobase.canada.ca/substance-related-harms/opioids-stimulants/) Ottawa: Public Health Agency of Canada; March
 Date accessed: May 2025
 
**Unemployment rates:**
Statistics Canada. Table 14-10-0287-03  [Labour force characteristics by province, monthly, seasonally adjusted] (https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1410028703)
DOI: [https://doi.org/10.25318/1410028701-eng] (https://doi.org/10.25318/1410028701-eng)
  Date accessed: May 2025
  
## Project Structure
data/unemployment_clean.csv
data/substance_harms.csv
scripts/cleandata.R
scripts/checks.R
scripts/requirements.R
plots/provincial_slopes.png
plots/overdose_time_series.png
plots/overdose_scatterpoint.png
plots/choropleth_map.png
README.md
capstone_analysis.Rmd

## How to reproduce
rmarkdown::render("capstone_analysis.Rmd")