#### Preamble ####
# Purpose: Transform the raw data into csv format and clean out useless columns
# Author: Yichen Ji, Xiaoxu Liu
# Date: 11 February 2023
# Contact: yic.ji@mail.utoronto.ca, xiaoxu.liu@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download tidyverse package
# Any other information needed? No.

#### Workspace setup ####
library(tidyverse)

#### Clean data ####
load("data/raw_data/billionaire.RData")
iit_billionaire <- iit2 
rm(iit2)
iit_billion_selected <- select(iit_billionaire, treatment, handle, gender, racecat_anes, educ)

load("data/raw_data/lgbtq.RData")
iit_lgbtq <- iit2 
rm(iit2)
iit_lgbtq_selected <- select(iit_lgbtq, treatment, handle, gender, racecat_anes, educ)

load("data/raw_data/partisans.RData")
iit_partisans <- iit2 
rm(iit2)
iit_partisans_selected <- select(iit_partisans, treatment, handle, gender, racecat_anes, educ)

#### Save data ####
write.csv(iit_lgbtq_selected, "data/analysis_data/lgbtq.csv", row.names = FALSE)
write.csv(iit_billion_selected, "data/analysis_data/billion.csv", row.names = FALSE)
write.csv(iit_partisans_selected, "data/analysis_data/partisans.csv", row.names = FALSE)

