#### Preamble ####
# Purpose: Downloads and saves the data from Harvard Dataverse
# Author: Yichen Ji, Shuhan Yang, Xiaoxu Liu
# Date: 11 February 2023
# Contact: yic.ji@mail.utoronto.ca, xiaoxu.liu@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download packages "rvest" and "httr"
# Any other information needed? No.


#### Workspace setup ####
#install.packages("rvest")
library(rvest)
library(httr)

#### Download data ####
download_url_billion <- "https://dataverse.harvard.edu/api/access/datafile/7513335"
download_url_lgbtq <- "https://dataverse.harvard.edu/api/access/datafile/7513334"
download_url_partisans <- "https://dataverse.harvard.edu/api/access/datafile/7513362"

destfile_billion <- "data/raw_data/billionaire.RData"
destfile_lgbtq <- "data/raw_data/lgbtq.RData"
destfile_partisans <- "data/raw_data/partisans.RData"


#### Save data ####
# change the_raw_data to whatever name you assigned when you downloaded it.
GET(download_url_billion, write_disk(destfile_billion, overwrite = TRUE))
GET(download_url_lgbtq, write_disk(destfile_lgbtq, overwrite = TRUE))
GET(download_url_partisans, write_disk(destfile_partisans, overwrite = TRUE))

