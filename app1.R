#shiny installation


#install.packages("tidyverse")
#install.packages("dplyr")
#install.packages("ggplot2")
install.packages("fmsb")
library(fmsb)
library(shiny)
library(dplyr)
library(ggplot2)

summary_page <- tabPanel(
  "Summary",
  titlePanel("Summary Takeaway for Scatterplot")
)

analysis_page <- tabPanel("Analysis")

ui <- navbarPage(
  title = "Voting Registration Based on Race",
  summary_page,
  analysis_page  
)

#load in the data
white <- read.csv("white_alone_formatted.csv", stringsAsFactors = FALSE)
latino <- read.csv("latino_alone_formatted.csv", stringsAsFactors = FALSE)
black <- read.csv("black_alone_formatted.csv", stringsAsFactors = FALSE)