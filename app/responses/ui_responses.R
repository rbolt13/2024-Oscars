### ui_responses.R -----------------------------------
# Date: March 18, 2024
# Description: This file contains the UI 
# definition for the "Responses" tab.

# Load Data
votes <- readr::read_csv("data-clean/votes.csv")

# Define UI for the Responses tab
ui_responses <- function(){
  # Define a tab panel for the "Responses" section
  tabPanel("Responses",
           sidebarLayout(
             sidebarPanel(
               selectInput("category", 
                           "Select Category", 
                           choices = c("All", unique(votes$Category))),  
               checkboxInput("include_critics", 
                             "Include Critics' Data", 
                             value = TRUE),
               selectInput("alias", 
                           "Select Alias", 
                           choices = c("",
                                       "All", 
                                       sort(unique(votes$Alias), 
                                            na.last = TRUE)))
             ),
             mainPanel(
               plotOutput("barplot"),
               tableOutput("vote_table")
             )
           )
  )
}