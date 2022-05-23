library("ggplot2")
library("tidyverse")


white <- read.csv("white_alone_formatted.csv", stringsAsFactors = FALSE)
latino <- read.csv("latino_alone_formatted.csv", stringsAsFactors = FALSE)
black <- read.csv("black_alone_formatted.csv", stringsAsFactors = FALSE)

Plot <- ggplot(white, aes(y=Votes, x=Race)) +
  geom_bar(position="dodge", stat = "identity")

Plot





