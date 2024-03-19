### ui_comparison.R -----------------------------------
# Date: March 18, 2024
# Description: This file contains the UI 
# definition for the "Comparison" tab.

# Load Data
votes <- readr::read_csv("data-clean/votes.csv")

# Define UI for the Comparison tab
ui_comparison <- function(){
  tabPanel("Comparison", 
         sidebarLayout(
           sidebarPanel(
             selectInput("category_comp", 
                         "Select Category", 
                         choices = c("All", unique(votes$Category))),
             selectInput("alias1", 
                         "Select Alias 1", 
                         choices = c("", sort(unique(votes$Alias), na.last = TRUE))),  
             selectInput("alias2", 
                         "Select Alias 2", 
                         choices = c("", sort(unique(votes$Alias), na.last = TRUE)))  
             ), 
           mainPanel(
             tableOutput("comparison_table")  
             )
           )
         )
}