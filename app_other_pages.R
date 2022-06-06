#title: "Voting Registration App"
#authors: Cristian Martinez, Hritika Singh, Sarah Buch, Silpa Ajjarapu,

#Load libraries and Shiny installation

library(fmsb)
library(shiny)
library(dplyr)
library(ggplot2)

#Set up UI

# ui <- navbarPage(
#   title = "Voting Registration Based on Race",
#   introduction_page,
#   analysis_page,
#   interactive_page,
#   summary_page,
# )

#Introduction Page

introduction_page <- tabPanel(
  "Introduction",
  titlePanel("Introduction"),
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
        inputId = "age_groups", label = h3("Filter by Age Group"),
        choices = both_sex_df$Age_and_Sex)
    ),
    mainPanel(
      plotOutput(outputId = "age_plot", brush = "plot_brush")
    )
  )
)


#Third Interactive Page

chart_page <- tabPanel(
  "Bar chart",
titlePanel("Reported Voting for Each Race Grouped by Sex"),
sidebarLayout(
  sidebarPanel(
    h3("Age Groups"),
    selectInput(inputId = "select", label = h5("Select an Age Group"),
        choices = both_sex_df$Age_and_Sex)
    ),
  mainPanel(
    plotOutput(outputId = "bar")

   ),
  )
)

#Summary Page 

summary_page <- tabPanel(
  "Summary Takeaway",
  titlePanel("Summary Takeaway for Scatterplot"),
  p("An interesting takeaway from this dataset is that")
)

ui <- navbarPage(
  title = "Voting Registration Based on Race",
  introduction_page,
  analysis_page,
  interactive_page,
  summary_page,
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


#Server Logic
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
  output$bar <- renderPlot({
    grouped_bar <- ggplot(barchart_df, aes(fill=Age_and_Sex, y=ReportedVoted, x=Race)) +
      geom_bar(position = "dodge", stat = "identity") 
    
    print(grouped_bar + labs(
      title = "Reported Voting Across Race",
      fill = "Sex",
      y= "Reported Voting (in Thousands)", x = "Race"))
  })
  
  output$age_plot <- renderPlot({
    filter_out <- filter(both_sex_df, !Age_and_Sex == "BOTH_SEX_Total")
    registration_bar <- ggplot(filter_out, aes(fill=Age_and_Sex, y=Registered, x=Race)) +
      geom_bar(position = "stack", stat = "identity") +
      ylim(0, 150000)
    
    
    print(registration_bar + labs(
      title = "Voter Registration Across Race",
      y = "Voter Registration (in Thousands)", x = "Race"
    ))
  })
}

#Function that Makes the Shiny App
shinyApp(ui = ui, server = server)
