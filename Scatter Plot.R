library("ggplot2")
library("tidyverse")


white <- read.csv("white_alone_formatted.csv", stringsAsFactors = FALSE)
latino <- read.csv("latino_alone_formatted.csv", stringsAsFactors = FALSE)
black <- read.csv("black_alone_formatted.csv", stringsAsFactors = FALSE)

#removing NA rows from "latino" dataset
latino <- latino[-c(19:39), ]

#adding a "Race" column for each dataset
white$Race <- "White"
latino$Race <- "Latino"
black$Race <- "Black"

#Cleaning up columns names to be able to merge all three of the new datasets together
white <- white %>% 
  rename(Age_and_Sex = White.Alone)

latino <- latino %>% 
  rename(Age_and_Sex = Hispanic.or.Latino.Alone)

black <- black %>% 
  rename(Age_and_Sex = Black.Alone)


lw_df <- rbind(white, latino)
merged_df <- rbind(lw_df, black)

#filter down the merged_df to only have the "both_sex" values to use in plot
both_sex_df <- merged_df[c(1:6, 19:24, 37:42), ]

#Creating a scatter plot that compares the number of people who Reported Voted and 
#the Total Citizen Population across races
VotingPlot <- ggplot(both_sex_df, aes(x=Total_Citizen_Population, y=ReportedVoted, colour = Race)) +
  geom_point()

print(VotingPlot + labs(
  title = "Total Citizen Population and Reported Voting",
  y= "Reported Voting", x = "Citizen Population (in Thousands)"
))









