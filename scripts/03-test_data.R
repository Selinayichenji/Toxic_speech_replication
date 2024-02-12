#### Preamble ####
# Purpose: Test the analysis data to make sure they are quilified to process in further steps
# Author: Yichen Ji, Xiaoxu Liu
# Date: 11 February 2023
# Contact: yic.ji@mail.utoronto.ca, xiaoxu.liu@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# Any other information needed? No.


#### Workspace setup ####
library(tidyverse)
library(testthat)

lgbtq_educ <- read_csv("data/analysis_data/lgbtq_education.csv")
lgbtq_gender <- read_csv("data/analysis_data/lgbtq_gender.csv")
partisans <- read_csv("data/analysis_data/partisans.csv")

#### Test data ####


test_that("Column names match expected names", {
  expect_equal(names(partisans), c("treatment", "handle", "gender", "race", "educ", "partisan"))
})



expected_educ_levels <- c("High school graduate", "College", "Postgraduate")

test_that("educ column in lgbtq_educ contains only the expected levels", {
  content <- lgbtq_educ
  unique_educ_values <- unique(content$educ)
  expect_true(all(unique_educ_values %in% expected_educ_levels))
})



expected_gender_levels <- c("Male", "Female")

test_that("educ column in lgbtq_gender contains only the expected levels", {
  content <- lgbtq_gender
  unique_gender_values <- unique(content$gender)
  expect_true(all(unique_gender_values %in% expected_gender_levels))
})

