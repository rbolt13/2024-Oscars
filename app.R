# Load Libraries
library(shiny)
library(ggplot2)
library(readr)
library(dplyr)
library(tidyr)  
library(scales)
library(markdown)

# Load Data
votes <- readr::read_csv("data-clean/votes.csv")

# Oscar Winners Data
oscar_winners <- c("tanner")

# Define UI
ui <- fluidPage(
  titlePanel("2024 Oscar Prediction Challenge"),
  tabsetPanel(
    tabPanel("About", 
             uiOutput("about_content")
    ),
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
                             choices = c("All", 
                                         sort(unique(votes$Alias), 
                                              na.last = TRUE)))
               ),
               mainPanel(
                 plotOutput("barplot"),
                 tableOutput("vote_table")
               )
             )
    ),
    tabPanel("Comparison", 
             sidebarLayout(
               sidebarPanel(
                 selectInput("category_comp", 
                             "Select Category", 
                             choices = unique(votes$Category)),
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
    ),
    tabPanel("Stats"),
    tabPanel("Leaderboard",
             sidebarLayout(
               sidebarPanel(
                 # checkboxInput("include_critics_leaderboard",
                 #               "Include Critics' Data",
                 #               value = TRUE)
               ),
               mainPanel(
                 h4("Coming on March 11th, 2024!")
                 # tableOutput("leaderboard_table")
               )
             )
    ),
  )
)

# Define server logic
server <- function(input, output) {
  # (1) About Page: Render the about page content
  output$about_content <- renderUI({
    about_content <- markdown::markdownToHTML("about.md")
    HTML(about_content)
  })
  
  # (2) Responses Page: 
  # Filtered data based on user inputs
  filtered_data <- reactive({
    data <- votes
    
    # Filter by selected category
    if (input$category != "All") {
      data <- data[data$Category == input$category, ]
    }
    
    # Filter by whether to include critics' data
    if (!input$include_critics | input$include_critics == FALSE) {
      data <- data[data$Critic == "FALSE", ]
    }
    
    # Filter by selected alias
    if (input$alias != "All") {
      data <- data[data$Alias == input$alias, ]
    }
    
    # Arrange data by Alias and then Category
    data <- dplyr::arrange(data, Alias, Category)
    
    data
  })
  
  # Render the bar plot for Responses tab
  output$barplot <- renderPlot({
    # Dynamically adjust x-axis label
    x_label <- ifelse(input$category == "All", "Movie", "MovieNominee")
    
    ggplot(filtered_data(), aes_string(x = x_label, fill = 'color')) +
      geom_bar() +
      labs(title = paste("Votes for Each Movie in", input$category),
           x = x_label,
           y = "Votes") + 
      scale_fill_identity() +
      scale_y_continuous(breaks = pretty_breaks()) +
      theme_light() +
      theme(
        axis.text.x = element_text(
          angle = 35,
          hjust = 1
        ))
  })
  
  # Render the table for Responses tab
  output$vote_table <- renderTable({
    # Create Movie and Nominee columns
    vote_data <- filtered_data()
    vote_data <- vote_data[, c("Alias", "Category", "MovieNominee", "Seen")]
    vote_data
  })
  
  # (3) Comparison table
  output$comparison_table <- renderTable({
    # Filtered data for comparison
    comparison_data <- votes
    
    # Filter by selected category
    comparison_data <- comparison_data[comparison_data$Category == input$category_comp, ]
    
    # Filter by selected aliases
    comparison_data <- comparison_data[comparison_data$Alias %in% c(input$alias1, input$alias2), ]
    
    # Select relevant columns for comparison
    comparison_data <- comparison_data[, c("Alias", "MovieNominee")]
    
    # Pivot the data to create the desired table structure
    comparison_data <- pivot_wider(data = comparison_data, 
                                   names_from = Alias, 
                                   values_from = MovieNominee)
    
    comparison_data
  })
  
  # (4) Leaderboard: 
  leaderboard <- reactive({
    # Filtered data for calculating scores
    data <- filtered_data()
    
    # Get the list of all aliases except "Oscar Winners"
    aliases <- unique(data$Alias[data$Alias != oscar_winners])
    
    # Remove critics' aliases if checkbox is unchecked
    if (!input$include_critics_leaderboard | input$include_critics_leaderboard == FALSE) {
      data <- data[data$Critic == "FALSE", ]
      aliases <- unique(data$Alias[data$Alias != oscar_winners])
    }
    
    # Initialize leaderboard data frame
    leaderboard_df <- data.frame(Alias = aliases, Score = 0)
    
    # Get the data for "Oscar Winners"
    oscars_data <- data[data$Alias == oscar_winners, ]
    
    # Iterate over each alias
    for (alias in aliases) {
      # Get the subset of data for the current alias
      alias_data <- data[data$Alias == alias, ]
      
      # Check if the alias's prediction matches "Oscar Winners"
      for (i in 1:nrow(alias_data)) {
        if (alias_data[i, "MovieNominee"] %in% oscars_data$MovieNominee) {
          leaderboard_df[leaderboard_df$Alias == alias, "Score"] <- 
            leaderboard_df[leaderboard_df$Alias == alias, "Score"] + 1
        }
      }
    }
    
    # Order the leaderboard by score
    leaderboard_df <- leaderboard_df[order(leaderboard_df$Score, decreasing = TRUE), ]
    
    leaderboard_df
  })
  
  # Render the leaderboard table
  output$leaderboard_table <- renderTable({
    leaderboard()
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
