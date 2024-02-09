#### Preamble ####
# Purpose: Downloads and saves the data from Harvard Dataverse
# Author: Yichen Ji, Shuhan Yang, Xiaoxv Liu
# Date: 05 February 2023
# Contact: yic.ji@mail.utoronto.ca
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
#install.packages("rvest")
library(rvest)
library(httr)

#### Download data ####
download_url_billion <- "https://dataverse.harvard.edu/api/access/datafile/7513335"
download_url_lgbtq <- "https://dataverse.harvard.edu/api/access/datafile/7513334"
download_url_patisans <- "https://dataverse.harvard.edu/api/access/datafile/7513334"

destfile <- "/Users/selinaji/Desktop/paper2/billionaires.RData"

GET(download_url, write_disk(destfile, overwrite = TRUE))



#### Save data ####
# change the_raw_data to whatever name you assigned when you downloaded it.
write_csv(the_raw_data, "inputs/data/raw_data.csv") 
