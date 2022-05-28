library("tidyverse")
library("ggplot2")

white_df <- read.csv("white_alone_formatted.csv", stringsAsFactors = FALSE)
latino_df <- read.csv("latino_alone_formatted.csv", stringsAsFactors = FALSE)
black_df <- read.csv("black_alone_formatted.csv", stringsAsFactors = FALSE)

#remove NA rows
latino_df <- latino_df[-c(19:39), ]

#Add "Race" Column
white_df$Race <- "White"
latino_df$Race <- "Latino"
black_df$Race <- "Black"

#Rename columns for all 3 to Age_and_Sex
white_df <- white_df %>% 
  rename(Age_and_Sex = White.Alone)

latino_df <- latino_df %>% 
  rename(Age_and_Sex = Hispanic.or.Latino.Alone)

black_df <- black_df %>% 
  rename(Age_and_Sex = Black.Alone)

#merge
w_l <- rbind(white_df, latino_df)
three_df <- rbind(w_l, black_df)

#select only the "BOTH_SEX_Total" rows
chart_df <- three_df[c(1, 19, 37), ]

#create barchart
registration_bar <- ggplot(chart_df, aes(y=Registered, x=Race)) +
  geom_bar(stat = "identity", fill=rgb(0.1,0.4,0.5,0.7) ) +
  ylim(0, 150000)

print(registration_bar + labs(
  title = "Voter Registration Across Race",
  y = "Voter Registration (in Thousands)", x = "Race"
))

