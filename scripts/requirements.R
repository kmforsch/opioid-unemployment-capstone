# scripts/requirements.R

packages <- c(
  "tidyverse",      # loads dplyr, ggplot2, stringr, readr, tidyr, purrr, etc.
  "broom",          # model tidying
  "janitor",        # clean_names()
  "lubridate",      # date parsing
  "sf",             # spatial data
  "rnaturalearth",  # ne_states()
  "rmarkdown",      # knitting
  "knitr"           # chunk options
)


# Install any missing packages
installed <- rownames(installed.packages())
to_install <- packages[!packages %in% installed]
if (length(to_install) > 0) {
  install.packages(to_install)
}

#Load them all
lapply(packages, library, character.only = TRUE)
