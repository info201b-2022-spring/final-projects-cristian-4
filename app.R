#title: "Voting Registration App"
#authors: Cristian Martinez, Hritika Singh, Sarah Buch, Silpa Ajjarapu,

#Load libraries and Shiny installation

library(fmsb)
library(shiny)
library(dplyr)
library(ggplot2)

#Introduction Page

introdocution_page <- tabPanel(
  "Introduction",
  titlePanel("Introduction")
)

##Add intro

#1st Interactive Page 
analysis_page <- tabPanel(
  "Interactive Page",
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

#Second Interactive Page
interactive_page <- tabPanel(
  "Voting Registration based on Age",
  titlePanel("Voting Registration of Every Race Based on Age"),
  sidebarLayout(
    sidebarPanel(
      h3("Ages"),
      selectInput(
        inputId = "Age Groups", label = h3("Filter by Age Group"),
        choices = c("18 to 24 years", "25 to 44 years", "45 to 64", "65-74 years", "75 years and over", "Total 18 years and over")
      )
    ),
    mainPanel(
      plotOutput(outputId = "age_plot", brush = "plot_brush")
    )
  )
)

#Third Interactive Page
  ui <- navbarPage(
    title = "Voting Registration Based on Race",
    summary_page,
    analysis_page,
    # chart_page,
  )
  
# chart_page <- tabPanel(
#   "Bar chart", 
# titlePanel("Reported Voting for Each Race Grouped by Sex"),
# sidebarLayout(
#   sidebarPanel(
#     h3("Age Groups"),
#     selectInput(inputId = "select", label = h5("Select an Age Group"),
#         choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3), 
#         selected = 1)
#     ),
#   mainPanel(
#     plotOutput(outputId = "bar"),
#     
#    ),
#   )
# )

#Summary Page 

summary_page <- tabPanel(
  "Summary Takeaway",
  titlePanel("Summary Takeaway for Scatterplot")
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
    nearPoints(filter_df, coordinfo = input$plot_click, xvar = "Total_Citizen_Population", yvar = "ReportedVoted")
  })
}

#function that makes the shiny app
shinyApp(ui = ui, server = server)
