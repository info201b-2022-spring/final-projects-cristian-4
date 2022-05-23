#load in all of the datasets + packages
library("tidyverse")
library("fmsb")

white_df <- read.csv("white_alone_formatted.csv", stringsAsFactors = FALSE)
latino_df <- read.csv("latino_alone_formatted.csv", stringsAsFactors = FALSE)
black_df <- read.csv("black_alone_formatted.csv", stringsAsFactors = FALSE)


#Create a radar chart that compares age groups to the number of votes for each age group


white_subset_df <- white_df[c(2:6),]

min_df <- summarise_all(white_subset_df, min)
max_df <- summarise_all(white_subset_df, max)


white_subset_df <- do.call("rbind", list(max_df, min_df, white_subset_df))


radarchart(white_subset_df)