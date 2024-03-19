### Votes ---------------------------------------
# Date: March 10, 2024
# Description: This file loads the raw oscars.csv, 
# cleans it, and then saves it as a .csv into the 
# data-clean folder. 
here:i_am("data-clean/votes.R")

### Load Libraries ------------------------------
# dplyr: Clean data.
# readr: Load and save data.
library(dplyr)
library(readr)

### Load Data -------------------------------
votes <- readr::read_csv("data-clean/votes.csv")

### Clean Data -----------------------------
# Filter out rows with "Seen" as "NA - Critics' Pick"
votes_filtered <- votes |>
  dplyr::filter(Seen != "NA - Critics' Pick")

# Remove unnecessary columns
votes <- votes_filtered |>
  dplyr::select(-Category, -MovieNominee, -Nominee, -Critic, -color, -Movie) %>%
  dplyr::distinct(Alias, .keep_all = TRUE)  # Keep unique alias with all columns

# Split the "Seen" column into separate movies
votes$Seen <- base::strsplit(votes$Seen, ", ")

# Create a list of unique movies
all_movies <- base::unique(unlist(votes$Seen))

# Create a matrix or data frame to store the results
result_df <- base::matrix(0, nrow = nrow(votes), ncol = length(all_movies), dimnames = list(NULL, all_movies))

# Populate the matrix with 1s and 0s
for (i in 1:nrow(votes)) {
  result_df[i, votes$Seen[[i]]] <- 1
}

# Convert the matrix to a data frame and add the Alias column
results <- base::data.frame(Alias = votes$Alias, result_df)

# Replace dots with spaces in column names
base::colnames(results) <- gsub("\\.", " ", colnames(results))

# Calculate total movies seen by each alias
results$total_movies_seen <- base::rowSums(results[, -1])

### Save Data ---------------------------------
readr::write_csv(
  results, 
  file = "data-clean/results.csv")