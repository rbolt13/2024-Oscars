### ui_seen_statistics.R -----------------------------------
# Date: March 18, 2024
# Description: This file contains the UI 
# definition for the "Seen Statistics" tab.

# Define UI for the Seen Statistics tab
ui_seen_statistics <- function() {
  # Define a tab panel for the "Seen Statistics" section
  tabPanel("Seen Statistics",
           mainPanel(
             h4("Statistics on Movies Seens"),
             h5("Movies Seen Most"),
             tableOutput("movies_seen_most_table"),
             h5("People Who Have Seen the Most Oscar Nominated Movies"),
             tableOutput("people_seen_most_table"),
             h5("Unique Movies (Seen by only 1 Person)"),
             tableOutput("unique_movie_table")
           )
  )
}