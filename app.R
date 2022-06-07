#title: "Voting Registration App"
#authors: Cristian Martinez, Hritika Singh, Sarah Buch, Silpa Ajjarapu,

#Load libraries and Shiny installation

library(fmsb)
library(shiny)
library(dplyr)
library(ggplot2)


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

narrow_down <- merged_df[c(8:12, 14:18, 26:30, 32:36, 44:48, 50:54), ]

filter_df <- both_sex_df
filter_out <- filter(both_sex_df, !Age_and_Sex == "BOTH_SEX_Total")


#Introduction Page

introduction_page <- tabPanel(
  "Introduction",
  titlePanel("Introductory Page"),
  p("This project takes a deeper look into voter registration data surrounding the November 2020 United States presidential election. The data 
utilized for this project was gathered from the U.S. Census Bureau. Specifically, this project will look at voter registration data and its 
correlation with race. Each dataset is categorized into three groups: Black, Latinx, and white. Each dataset is formatted by age group, gender, 
and overall statistics. This project mainly utilizes the comprehensive data gathered for each race. For our domain of interest, we chose voter 
registration data because our group became intrigued by the obvious disparities within each race group. Unfortunately, voter registration in the
United States can directly correlate with an individual's race. Voter registration laws are often changed in order to make it more difficult for
minority groups to vote and many choose to not even register because voting booths are not very accessible. Voting booths are often placed two towns 
over from communities whose populations are made up of mainly minority groups, making it extremely difficult for people of color to vote as well as 
those in low-income areas. For these reasons, our group chose to gain a deeper understanding of this unfair correlation. Each interactive page within
this project seeks to answer one of our three questions."),
  titlePanel("Questions answered by Data"),
  p("These three questions are the following: 
      How does voting registration in each race differ by age groups?
      How does the number of people who voted compare to the total citizen population based on race?
      What did voting look like demographically, specifically with age and sex groups, in the 2020 election?")
  )

##Add intro

#1st Interactive Page 
analysis_page <- tabPanel(
  "Interactive Page 1",
  titlePanel("Reported Voted vs. Total Citizen Population Based on Race"),
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
  "Interactive Page 2",
  titlePanel("Voting Registration of Each Race Based on Age"),
  sidebarLayout(
    sidebarPanel(
      h3("Ages"),
      selectInput(
        inputId = "age_groups", label = h3("Filter by Age Group"),
        choices = filter_out$Age_and_Sex)
    ),
    mainPanel(
      plotOutput(outputId = "age_plot", brush = "plot_brush"),
      plotOutput(outputId = "secondary_age")
    )
  )
)


#Third Interactive Page

chart_page <- tabPanel(
  "Interactive Page 3",
titlePanel("Reported Voting Grouped by Sex"),
sidebarLayout(
  sidebarPanel(
    h3("Age Groups"),
    selectInput(inputId = "select", label = h5("Select an Age Group"),
        choices = narrow_down$Age_and_Sex)
    ),
  mainPanel(
    plotOutput(outputId = "bar"),
    plotOutput(outputId = "secondary_bar")

   ),
  )
)

#Summary Page 

summary_page <- tabPanel(
  "Summary Takeaway",
  titlePanel("Summary Takeaways for Interactive Page 1"),
  p("Through my analysis of the number of individuals who reported voting vs. the total citizen population, I found that among the 
races I analyzed, the white race group was a clear outlier. The white group represented all three of the outliers on the graph. When looking at the
total citizen population, the white race group was higher than the other race groups in this category and also in the reported voted category. This
tells us that the white race group has a both a higher citizen population and reported voting. With my interactivity feature, as I use the slider 
to lower the population number, there is a trend among the black and latino groups. Both groups are similar on citizen population in relation to the 
reported voted, and represent the points on the graph that are closer to the 0, meaning a lower reported voted and citizen population. Through my analysis,
I have concluded that the citizen population and reported voted have a direct, positive relationship (the higher the citizen population, the higher the
reported voted). Similarly, I have concluded that the white citizen population in relation to reported voted is greatly higher than that of the black
and latino race groups."),
  titlePanel("Summary Takeaways for Interactive Page 2"),
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
    today."),
  titlePanel("Summary Takeaways for Interactive Page 3"),
  p("I looked at Reported Voting across race grouped by sex. One takeaway that I had was the increased number of white voting. There was a very big increase/difference 
  in the number of white voting compared to Latino/Hispanic and Black votes. The drastic increase made me question the methods that the data was collected because I 
  did not feel that that difference was representative of the whole nation. I felt that maybe certain areas were not reached out to or responded in time. Another 
  trend that I noticed was that when looking at the totals, in all three races, the female vote was slightly higher than the male vote. I am unsure exactly what 
  conclusions if any could be drawn from this, but the fact that it was the same trend across all three races was interesting to me.")
)

ui <- navbarPage(
  title = "Voting Registration and Reported Voting Based on Race, Age Groups, and Sex",
  introduction_page,
  analysis_page,
  interactive_page,
  chart_page,
  summary_page
)


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
  # output$specifics <- renderTable({
  #   nearPoints(filter_df, coordinfo = input$plot_click, xvar = "Total_Citizen_Population", yvar = "ReportedVoted")
  # })
  
  #creates interactive bar chart; shows sections of the stacked bar chart based
  #on the user selection
  responsive <- reactive({
    req(input$age_groups)
    place_holder <- filter_out %>% filter(Age_and_Sex %in% input$age_groups)
  })
  
  output$age_plot <- renderPlot({
    registration_bar <- ggplot(responsive(), aes(fill=Age_and_Sex, y=Registered, x=Race)) +
      geom_bar(position = "stack", stat = "identity") +
      ylim(0, 150000)
    
    
    print(registration_bar + labs(
      title = "Voter Registration Across Race",
      y = "Voter Registration (in Thousands)", x = "Race"
    ))
  })
  
  #renders static bar chart with all of the age groups stacked together to show the "total"
  output$secondary_age <- renderPlot({
    registration_bar <- ggplot(filter_out,  aes(fill=Age_and_Sex, y=Registered, x=Race)) +
      geom_bar(position = "stack", stat = "identity") +
      ylim(0, 150000)
    
    
    print(registration_bar + labs(
      title = "Voter Registration Across Race",
      y = "Voter Registration (in Thousands)", x = "Race"
    ))
  })
  
  #renders interactive grouped bar chart
  interactivity <- reactive({
    req(input$select)
    hold_place <- narrow_down %>% filter(Age_and_Sex %in% input$select)
  })
  
  output$bar <- renderPlot({
    grouped_bar <- ggplot(interactivity(), aes(fill=Age_and_Sex, y=ReportedVoted, x=Race)) +
      geom_bar(position = "dodge", stat = "identity")

    print(grouped_bar + labs(
      title = "Reported Voting Across Race (X-axis scales with selected input*)",
      fill = "Sex",
      y= "Reported Voting (in Thousands)", x = "Race"))
  })
  
  #renders static grouped bar to show male and female totals
  output$secondary_bar <- renderPlot({
    grouped_bar <- ggplot(barchart_df, aes(fill=Age_and_Sex, y=ReportedVoted, x=Race)) +
          geom_bar(position = "dodge", stat = "identity")

        print(grouped_bar + labs(
          title = "Reported Voting Across Race",
          fill = "Sex",
          y= "Reported Voting (in Thousands)", x = "Race"))
  })
  
}

#Function that Makes the Shiny App
shinyApp(ui = ui, server = server)
