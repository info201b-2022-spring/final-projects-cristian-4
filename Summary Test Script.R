install.packages("lubridate")
install.packages("tidyverse")
install.packages("dplyr")

white_df <- read.csv("WhiteVotingRegistration.csv")
black_df <- read.csv("AfricanAmericanVotingRegistration.csv")
latino_df <- read.csv("LatinoVotingRegistration.csv")

#create summary info list
summary_info <- list()


#White registration numbers
summary_data_info$num_observations <- nrow(white_df)

summary_data_info$num_features <- ncol(white_df)

summary_data_info$white_reported_registered <- white_df %>%
  filter(reportedregistered == max(reportedregistered, na.rm = T)) %>%
  select(bothsexes, reportedregistered, number)

#Black registration numbers
summary_data_info$num_observations <- nrow(black_df)

summary_data_info$num_features <- ncol(black_df)

summary_data_info$black_reported_registered <- black_df %>%
  filter(reportedregistered == max(reportedregistered, na.rm = T)) %>%
  select(bothsexes, reportedregistered, number) 

#Latino registration numbers
summary_data_info$num_observations <- nrow(latino_df)

summary_data_info$num_features <- ncol(latino_df)

summary_data_info$white_reported_registered <- latino_df %>%
  filter(reportedregistered == max(reportedregistered, na.rm = T)) %>%
  select(bothsexes, reportedregistered, number)

#number within white thats not registered
summary_data_info$total_white_not_registered <- white_df %>%
  filter(reportednotregistered == max(reportednotregistered, na.rm = T)) %>%
  select(bothsexes, reportednotregistered, number)

#number within black thats not registered
summary_data_info$total_black_not_registered <- black_df %>%
  filter(reportednotregistered == max(reportednotregistered, na.rm = T)) %>%
  select(bothsexes, reportednotregistered, number)

#number within latino thats not registered
summary_data_info$total_latino_not_registered <- latino_df %>%
  filter(reportednotregistered == max(reportednotregistered, na.rm = T)) %>%
  select(bothsexes, reportednotregistered, number)
  
