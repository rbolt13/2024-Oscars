### ui_about.R -----------------------------------
# Date: March 18, 2024
# Description: This file contains the UI 
# definition for the "About" tab.

# Define UI for the About tab
ui_about <- function() {
  # Define a tab panel for the "About" section
  tabPanel("About", 
           uiOutput("about_content")
  )
}