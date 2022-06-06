#title: "Voting Registration App"
#authors: Cristian Martinez, Hritika Singh, Sarah Buch, Silpa Ajjarapu,

#Load libraries and Shiny installation

library(fmsb)
library(shiny)
library(dplyr)
library(ggplot2)

#Set up UI

ui <- navbarPage(
  title = "Voting Registration Based on Race",
  introduction_page,
  analysis_page,
  interactive_page,
  summary_page,
  
#Introduction Page

introduction_page <- tabPanel(
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
        inputId = "age_groups", label = h3("Filter by Age Group"),
        choices = df$Age_and_Sex)
    ),
    mainPanel(
      plotOutput(outputId = "age_plot", brush = "plot_brush")
    )
  )
)


#Third Interactive Page
 
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
  titlePanel("Summary Takeaway for Scatterplot"),
  titlePanel("Summary Takeaway for Bar Graph.")
  p("When looking specifically at the breakdown of voting registration in all three races 
    based on age groups, it is evident those aged between 18 to 64 years old are the most consistent 
    in registering. This could be becasue these individuals are further educated about the current 
    political climate, have access to information and news, or have access to voting. Although, it 
    is important to note that most of those who responded as 'not registered' in each race was between
    the 18 to 25 year old group. For example, 19.6% of the White population, 21.7% of the Black population
    and 26.3% of the Latino population aged between 18 to 25 years old was reported as not registered.
    This is peculiar to me as I would believe that especially in the last few years with the 
    increase in the Black Lives Matter movement, there would be more 18 to 25 year olds registering to 
    vote as this age group is the backbone for majority of the political activisim everyone sees 
    today.")
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
  output$age_plot <- renderPlot({
    registration_bar <- ggplot(chart_df, aes(y=Registered, x=Race)) +
      geom_bar(stat = "identity", fill=rgb(0.1,0.4,0.5,0.7) ) +
      ylim(0, 150000)
    
    print(registration_bar + labs(
      title = "Voter Registration Across Race",
      y = "Voter Registration (in Thousands)", x = "Race"
    ))
  })
}


#Function that Makes the Shiny App
shinyApp(ui = ui, server = server)
