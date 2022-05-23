install.packages("tidyverse")
install.packages("dplyr")
library(dplyr)
library(tidyverse)

white_df <- read.csv("/Users/silpaajjarapu/Documents/INFO201/final-projects-cristian-4/white_alone_formatted.csv")
black_df <- read.csv("/Users/silpaajjarapu/Documents/INFO201/final-projects-cristian-4/black_alone_formatted.csv")
latino_df <- read.csv("/Users/silpaajjarapu/Documents/INFO201/final-projects-cristian-4/latino_alone_formatted.csv")

#create summary info list
summary_info <-list()

#White citizen registration numbers
summary_info$num_observations <- nrow(white_df)

summary_info$num_features <- ncol(white_df)  

total_white_registered <- white_df[1,4]

#Black citizen registration numbers
summary_info$num_observations <- nrow(black_df)

summary_info$num_features <- ncol(black_df)

total_black_registered <- black_df[1,4]

#Latino citizen registration numbers
summary_info$num_observations <- nrow(latino_df)

summary_info$num_features <- ncol(latino_df)

total_latino_registered <- latino_df[1,4]
  
#absolute difference between black and white registered individuals

black_white_registration_difference <- abs(total_white_registered - total_black_registered)
  
#absolute difference between latino and white registered individuals

latino_white_registration_difference <- abs(total_white_registered - total_latino_registered)