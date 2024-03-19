### ui_leaderboard.R -----------------------------------
# Date: March 18, 2024
# Description: This file contains the UI 
# definition for the "Leaderboard" tab.

# Define UI for the Leaderboard tab
ui_leaderboard <- function() {
  # Define a tab panel for the "Leaderboard" section
  tabPanel("Leaderboard",
           sidebarLayout(
             sidebarPanel(
               checkboxInput("include_critics_leaderboard",
                             "Include Critics' Data",
                             value = TRUE)
             ),
             mainPanel(
               # h4("Coming on March 11th, 2024!")
               tableOutput("leaderboard_table")
             )
           )
  )
}