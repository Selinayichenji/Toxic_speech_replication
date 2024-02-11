#### Preamble ####
# Purpose: Simulate 
# Author: Yichen Ji, Shuhan Yang, Xiaoxu Liu
# Date: 11 February 2023
# Contact: yic.ji@mail.utoronto.ca, xiaoxu.liu@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download packages tidyvese and testthat
# Any other information needed? No.

#### Workspace setup ####
library(tidyverse)
library(testthat)
#### Simulate data ####
set.seed(02)

Gender <- sample(x = c("Female", "Male", "Others"), 
                 size = 100, replace = TRUE, 
                 prob = c(0.518, 0.478, 0.004))

Treatment <- sample(x = c("uncivil", "intolerant", "threatening"), 
                 size = 100, replace = TRUE, 
                 prob = c(0.6, 0.3, 0.1))

Handle <- sample(x = c("Leave it, do nothing", "Place a warning label on the post",
                       "Reduce how many people can see the post",
                       "Permanently remove the post", "Suspend the person’s account"), 
                 size = 100, replace = TRUE, 
                 prob = c(0.5,0.2,0.15,0.1,0.05))

Race <- sample(x = c("White", "Black", "Hispanic","Others"), 
                 size = 100, replace = TRUE, 
                 prob = c(0.7, 0.1, 0.1, 0.1))

Education <- sample(x = c("High school graduate", "College", "Postgraduate"),
                    size = 100, replace = TRUE,
                    prob = c(0.4,0.5,0.1))

simulate_data <- tibble(Treatment,Handle,Gender,Race,Education)

#Tests

test_that("Handle categories are correct", {expect_equal(length(unique(simulate_data$Handle)), 5)})

test_that("No missing values are present", {expect_true(all(complete.cases(simulate_data)))})

test_that("Columns have the correct data types", {
  expect_is(simulate_data$Treatment, "character")
  expect_is(simulate_data$Handle, "character")
  expect_is(simulate_data$Gender, "character")
  expect_is(simulate_data$Race, "character")
  expect_is(simulate_data$Education, "character")
})



