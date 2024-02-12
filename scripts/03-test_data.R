#### Preamble ####
# Purpose: Test the analysis data to make sure they are quilified to process in further steps
# Author: Yichen Ji, Shuhan Yang, Xiaoxu Liu
# Date: 11 February 2023
# Contact: yic.ji@mail.utoronto.ca, xiaoxu.liu@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# Any other information needed? No.


#### Workspace setup ####
library(tidyverse)
library(testthat)

lgbtq <- read_csv("data/analysis_data/lgbtq.csv")
billion <- read_csv("data/analysis_data/billion.csv")
partisans <- read_csv("data/analysis_data/partisans.csv")

#### Test data ####
