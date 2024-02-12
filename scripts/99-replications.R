#### Preamble ####
# Purpose: Replicate 
# Author: Yichen Ji
# Date: 11 February 2023
# Contact: yic.ji@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download tidyverse package
# Any other information needed? No.

library(dplyr)
library(tidyr)
library(ggplot2)
library(MetBrewer)
library(cowplot)

lgbtq <- read_csv(here::here("data/analysis_data/lgbtq.csv"))
partisans <- read_csv(here::here("data/analysis_data/partisans.csv"))

#Figure for LGBTQ Target
data_wide <- lgbtq %>%
  count(treatment, handle) %>%
  pivot_wider(names_from = handle, values_from = n, values_fill = list(n = 0)) %>%
  mutate(total = rowSums(across(-treatment)))

data_wide <- data_wide %>%
  mutate(across(-c(treatment, total), ~ .x / total * 100))

data_long <- data_wide %>%
  pivot_longer(-c(treatment, total), names_to = "handle", values_to = "percent") %>%
  arrange(desc(treatment))

data_long <- data_long %>%
  mutate(treatment = factor(treatment, levels = c("non-group-related","control", "uncivil", "intolerant","threatening"), 
                            labels = c("No group mentioned", "Anti-target", "Uncivil post","Intolerant post","Threatening post")))


data_long$handle <- gsub("’", "'", data_long$handle)

ggplot(data_long, aes(x = fct_rev(treatment), y = percent, fill = handle)) +
  geom_bar(stat = "identity",width = 0.5) +
  theme_bw()+
  theme(
    legend.position = "bottom",
    legend.key.size = unit(0.3, "lines"),
    axis.title.y = element_text(face = "bold")
  ) +
  scale_fill_met_d(name = "Degas", direction = -1)+
  guides(
    fill = guide_legend(title = "How should social media \ncompanies handle the post?",
                        title.position = "left",
                        ncol = 3,# Position the title at the top
                        byrow = TRUE)  # Arrange items by row
  ) +
  labs(x = "", y = "Percent", fill = "") +
  coord_flip() +
  scale_y_continuous(expand = expansion(add = c(0, 0)))



# Figures for partisans
prepare_data <- function(partisans, target_partisan) {
  partisans %>%
    filter(partisan == target_partisan | treatment == "non-group-related control") %>% 
    mutate(treatment = factor(treatment, 
                              levels = c("non-group-related control", "control", 
                                         "uncivil", "intolerant", "threatening"), 
                              labels = c("No group mentioned", "Anti-target", 
                                         "Uncivil post", "Intolerant post", "Threatening post"))) %>%
    count(treatment, handle) %>%
    pivot_wider(names_from = handle, values_from = n, values_fill = list(n = 0)) %>%
    mutate(total = rowSums(across(-treatment))) %>%
    mutate(across(-c(treatment, total), ~ .x / total * 100)) %>%
    pivot_longer(-c(treatment, total), names_to = "handle", values_to = "percent") %>%
    arrange(desc(treatment)) %>%
    mutate(handle = iconv(handle, from = "UTF-8", to = "ASCII", sub = "'")) # Convert non-ASCII characters to ASCII
}


# Function to generate plot with legend and bold title
generate_plot <- function(data_long, show_legend = FALSE) {
  p <- ggplot(data_long, aes(x = fct_rev(treatment), y = percent, fill = handle)) +
    geom_bar(stat = "identity", width = 0.5) +
    theme_bw() +
    theme(
      legend.position = "none",  # We will place the legend manually
      axis.title.x = element_blank(),
      axis.text.y = element_text(face = "bold"),
      axis.text.x = element_blank(),
      plot.margin = margin(5.5, 10, 5.5, 5.5)
    ) +
    scale_fill_met_d(name = "Degas", direction = -1) +
    labs(x = "", y = "Percent", fill = "") +
    coord_flip() +
    scale_y_continuous(expand = expansion(add = c(0, 0)))
  
  if (show_legend) {
    p <- p + theme(legend.position = "bottom") + 
      guides(
        fill = guide_legend(
          title = "How should social media companies \nhandle the post?",
          title.position = "left", 
          ncol = 3, 
          byrow = TRUE 
        )
      )
  }
  
  return(p)
}

democrats_data_long <- prepare_data(partisans, "target: democrats")
republicans_data_long <- prepare_data(partisans, "target: republicans")

# Generate plots for Democrats and Republicans without individual titles
democrats_plot <- generate_plot(democrats_data_long)
republicans_plot <- generate_plot(republicans_data_long)

# Generate a plot with a legend to extract it
legend_plot <- generate_plot(democrats_data_long, TRUE) # Title is irrelevant here

# Extract the legend from the legend plot
legend <- get_legend(legend_plot)

# Combine plots and align the labels correctly
combined_plot <- plot_grid(
  democrats_plot + theme(plot.margin = margin(10, 10, 40, 5.5)), # Increase the top margin
  republicans_plot + theme(plot.margin = margin(10, 10, 40, 5.5)),
  labels = c("Target: Democrats", "Target: Republicans"),
  label_size = 12,
  label_fontface = "bold",
  hjust = -0.5, # Adjust horizontal position of labels
  vjust = 1.5,  # Adjust vertical position of labels
  ncol = 2
)

# Place the legend below the plots
final_plot <- plot_grid(
  combined_plot,
  legend,
  ncol = 1,
  rel_heights = c(1, 0.2) # Adjust these values as needed
)

# Print the final plot
print(final_plot)






