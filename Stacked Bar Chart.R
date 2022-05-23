library("ggplot2")
library("tidyverse")


w_df <- read.csv("white_alone_formatted.csv", stringsAsFactors = FALSE)
l_df <- read.csv("latino_alone_formatted.csv", stringsAsFactors = FALSE)
b_df <- read.csv("black_alone_formatted.csv", stringsAsFactors = FALSE)

Chart <- ggplot(white, aes(y=Votes, x=Race)) +
  geom_bar(position="Stack", stat = "identity")

Chart