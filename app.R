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

analysis_page <- tabPanel(
  "Analysis",
#this is where the filtering stuff goes
  )

ui <- navbarPage(
  title = "Voting Registration Based on Race",
  summary_page,
  analysis_page  
)

#load in the data
white <- read.csv("white_alone_formatted.csv", stringsAsFactors = FALSE)
latino <- read.csv("latino_alone_formatted.csv", stringsAsFactors = FALSE)
black <- read.csv("black_alone_formatted.csv", stringsAsFactors = FALSE)

latino <- latino[-c(19:39), ]

white$Race <- "White"
latino$Race <- "Latino"
black$Race <- "Black"

white <- white %>% 
  rename(Age_and_Sex = White.Alone)

latino <- latino %>% 
  rename(Age_and_Sex = Hispanic.or.Latino.Alone)

black <- black %>% 
  rename(Age_and_Sex = Black.Alone)

lw_df <- rbind(white, latino)
merged_df <- rbind(lw_df, black)

both_sex_df <- merged_df[c(1:6, 19:24, 37:42), ]

filter_df <- both_sex_df

#set up the UI
ui <- fluidPage(
  titlePanel("Reported Voted vs. Total Citizen Population based on Race"),
  sidebarLayout(
    sidebarPanel(
      h5("Controls"),
      sliderInput(
        inputId = "population",
        label = "Filter by max population number:",
        min = 0,
        max = 182000,
        value = 182000
        )
    ),
    mainPanel(
      plotOutput(outputId = "scatter", click = "plot_click"),
      tableOutput(outputId = "specifics")
    ),
  )
)

#server logic
server <- function(input, output){
  output$scatter <- renderPlot({
    filter_df <- filter(both_sex_df, Total_Citizen_Population <= input$population)
  VotingPlot <- ggplot(filter_df, aes(x=Total_Citizen_Population, y=ReportedVoted, colour = Race)) +
      geom_point()
 
  print(VotingPlot + labs(
    title = "Total Citizen Population and Reported Voting",
    y= "Reported Voting", x = "Citizen Population (in Thousands)"
    ))  
  })
  output$specifics <- renderTable({
    nearPoints(filter_df, input$plot_click, xvar = "Total_Citizen_Population", yvar = "ReportedVoted")
  })
}

#function that makes the shiny app
shinyApp(ui = ui, server = server)
