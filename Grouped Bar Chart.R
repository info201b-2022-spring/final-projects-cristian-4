library("ggplot2")
library("tidyverse")

 df_w <- read.csv("white_alone_formatted.csv", stringsAsFactors = FALSE)
 df_l <- read.csv("latino_alone_formatted.csv", stringsAsFactors = FALSE)
 df_b <- read.csv("black_alone_formatted.csv", stringsAsFactors = FALSE)

 #Remove NA rows from the latino dataset
 
 df_l <- df_l[-c(19:39), ]
 
 #Add a "Race column"
 df_w$Race <- "White"
 df_l$Race <- "Latino"
 df_b$Race <- "Black"
 
 #Rename column names across all three datasets to "Age_and_Sex"
 df_w <- df_w %>% 
   rename(Age_and_Sex = White.Alone)
 
 df_l <- df_l %>% 
   rename(Age_and_Sex = Hispanic.or.Latino.Alone)
 
 df_b <- df_b %>% 
   rename(Age_and_Sex = Black.Alone)
 
 #merging datasets
 white_latino <- rbind(df_w, df_l)
 all_three_df <- rbind(white_latino, df_b)
 
 #filter down to what I need to use for the grouped bar chart
 
 barchart_df <- all_three_df[c(7, 13, 25, 31, 43, 49), ]
 
 #create grouped bar chart
 grouped_bar <- ggplot(barchart_df, aes(fill=Age_and_Sex, y=ReportedVoted, x=Race)) +
   geom_bar(position = "dodge", stat = "identity") 
 
 print(grouped_bar + labs(
   title = "Reported Voting Across Race",
   fill = "Sex",
   y= "Reported Voting (in Thousands)", x = "Race"))
 
