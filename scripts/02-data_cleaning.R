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

### Only save useful columns ###

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
iit_partisans_selected <- select(iit_partisans, treatment, handle, gender, racecat_anes, educ, partisan)

### Rename columns ###

iit_billion_selected <- iit_billion_selected %>%
  rename(race = racecat_anes) %>%
  mutate(race = str_replace(race, "Race other/multiple", "Others")) %>%
  mutate(educ = str_replace(educ, "Postgraduate \\(e.g. Masters\\)", "Postgraduate")) %>%
  mutate(treatment = str_replace(treatment, "non-group-related control", "non-group-related"))

iit_lgbtq_selected <- iit_lgbtq_selected %>%
  rename(race = racecat_anes) %>%
  mutate(race = str_replace(race, "Race other/multiple", "Others")) %>%
  mutate(educ = str_replace(educ, "Postgraduate \\(e.g. Masters\\)", "Postgraduate")) %>%
  mutate(treatment = str_replace(treatment, "non-group-related control", "non-group-related"))

iit_partisans_selected <- iit_partisans_selected %>%
  rename(race = racecat_anes) %>%
  mutate(race = str_replace(race, "Race other/multiple", "Others"))%>%
  mutate(educ = str_replace(educ, "Postgraduate \\(e.g. Masters\\)", "Postgraduate"))


#### Save data ####
write.csv(iit_lgbtq_selected, "data/analysis_data/lgbtq.csv", row.names = FALSE)
write.csv(iit_billion_selected, "data/analysis_data/billion.csv", row.names = FALSE)
write.csv(iit_partisans_selected, "data/analysis_data/partisans.csv", row.names = FALSE)


### Calculate the percentage of different people's moderation to same treatment ###

## Target: LGBTQ ##
#gender
counts <-iit_lgbtq_selected %>%
  group_by(treatment,gender,handle) %>%
  summarise(count = n(), .groups = "drop") 

total_counts <- iit_lgbtq_selected %>%
  group_by(treatment, gender) %>%
  summarise(total = n(), .groups = "drop") %>%
  ungroup()

percentages <- counts %>%
  left_join(total_counts, by = c("treatment", "gender")) %>%
  mutate(percentage = (count / total) * 100)

result_l_gender <- percentages %>%
  filter(gender != "Other") %>% #Number of Others is too small, delete it for simplicity
  dplyr::select(treatment, gender, handle, percentage)


#race
counts_race <- iit_lgbtq_selected %>%
  filter(!is.na(race)) %>%
  group_by(treatment,race,handle) %>%
  summarise(count = n(), .groups = "drop")

total_counts_race <- iit_lgbtq_selected %>%
  filter(!is.na(race)) %>%
  group_by(treatment, race) %>%
  summarise(total = n(), .groups = "drop") %>%
  ungroup()

percentages_race <- counts_race %>%
  left_join(total_counts_race, by = c("treatment", "race")) %>%
  mutate(percentage = (count / total) * 100)

result_l_race <- percentages_race %>%
  dplyr::select(treatment, race, handle, percentage) 


#education
counts_edu <- iit_lgbtq_selected %>%
  filter(!is.na(educ)) %>%
  group_by(treatment,educ,handle) %>%
  summarise(count = n(), .groups = "drop")

total_counts_edu <- iit_lgbtq_selected %>%
  filter(!is.na(educ)) %>%
  group_by(treatment, educ) %>%
  summarise(total = n(), .groups = "drop") %>%
  ungroup()

percentages_edu <- counts_edu %>%
  left_join(total_counts_edu, by = c("treatment", "educ")) %>%
  mutate(percentage = (count / total) * 100)

result_l_edu <- percentages_edu %>%
  filter(educ %in% c("High school graduate", "College","Postgraduate"))%>%
  dplyr::select(treatment, educ, handle, percentage) 


## Target: Billionaire ##

#gender
count <- iit_billion_selected %>%
  group_by(treatment,gender,handle) %>%
  summarise(count = n(), .groups = "drop")

total_counts <- iit_billion_selected %>%
  group_by(treatment, gender)%>%
  summarise(total = n(), .groups = "drop") %>%
  ungroup()

percentages <- count %>%
  left_join(total_counts, by = c("treatment", "gender")) %>%
  mutate(percentage = (count / total) * 100)

result_b_gender <- percentages %>%
  filter(gender != "Other") %>%
  dplyr::select(treatment, gender, handle, percentage)

#race
counts_race <- iit_billion_selected %>%
  filter(!is.na(race)) %>%
  group_by(treatment,race,handle) %>%
  summarise(count = n(), .groups = "drop")

total_counts_race <- iit_billion_selected %>%
  filter(!is.na(race)) %>%
  group_by(treatment, race) %>%
  summarise(total = n(), .groups = "drop") %>%
  ungroup()

percentages_race <- counts_race %>%
  left_join(total_counts_race, by = c("treatment", "race")) %>%
  mutate(percentage = (count / total) * 100)

result_b_race <- percentages_race %>%
  dplyr::select(treatment, race, handle, percentage) 


#education
counts_edu <- iit_billion_selected %>%
  filter(!is.na(educ)) %>%
  group_by(treatment,educ,handle) %>%
  summarise(count = n(), .groups = "drop")

total_counts_edu <- iit_billion_selected %>%
  filter(!is.na(educ)) %>%
  group_by(treatment, educ) %>%
  summarise(total = n(), .groups = "drop") %>%
  ungroup()

percentages_edu <- counts_edu %>%
  left_join(total_counts_edu, by = c("treatment", "educ")) %>%
  mutate(percentage = (count / total) * 100)

result_b_edu <- percentages_edu %>%
  filter(educ %in% c("High school graduate", "College","Postgraduate"))%>%
  dplyr::select(treatment, educ, handle, percentage) 


#### Clean special character ###

result_l_gender <- result_l_gender %>%
  mutate(handle = gsub("Suspend the person’s account", "Suspend the person's account", handle))
result_l_race <- result_l_race %>%
  mutate(handle = gsub("Suspend the person’s account", "Suspend the person's account", handle))
result_l_edu <- result_l_edu %>%
  mutate(handle = gsub("Suspend the person’s account", "Suspend the person's account", handle))

result_b_gender <- result_b_gender %>%
  mutate(handle = gsub("Suspend the person’s account", "Suspend the person's account", handle))
result_b_race <- result_b_race %>%
  mutate(handle = gsub("Suspend the person’s account", "Suspend the person's account", handle))
result_b_edu <- result_b_edu %>%
  mutate(handle = gsub("Suspend the person’s account", "Suspend the person's account", handle))


#### Save data ####
write.csv(result_l_gender, "data/analysis_data/lgbtq_gender.csv", row.names = FALSE)
write.csv(result_l_race, "data/analysis_data/lgbtq_race.csv", row.names = FALSE)
write.csv(result_l_edu, "data/analysis_data/lgbtq_education.csv", row.names = FALSE)

write.csv(result_b_gender, "data/analysis_data/billion_gender.csv", row.names = FALSE)
write.csv(result_b_race, "data/analysis_data/billion_race.csv", row.names = FALSE)
write.csv(result_b_edu, "data/analysis_data/billion_education.csv", row.names = FALSE)



