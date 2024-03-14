### Votes ---------------------------------------
# Date: March 14, 2024
# Description: This file loads the raw oscars.csv, 
# cleans it, and then saves it as a .csv into the 
# data-clean folder. 
here:i_am("data-clean/votes.R")

### Load Libraries ------------------------------
# readr: Loads and saves data as .csv file.
# tidyr: Pivots data
# dplyr: groups, and summaries data
library(readr)
library(tidyr)
library(dplyr)

### Load Raw Data -------------------------------
# oscars: raw google forms data of oscar nominations. 
oscar_categories <- readr::read_csv("data-raw/oscars.csv")

### Clean Data -----------------------------
# 1. Extract columns representing Oscar categories
# 1. Rename the last two columns. 
# 2. Pivot table. 
# 3. Add critic column
# 4. Extract exception movies with "-" in the title
# 5. Subset the data in movieL and movieR such that 
#     the movie title is either on the left or right 
#     side of the delimiter
# 6. Separate MovieNominees into three columns for all 
#     three datasets
# 7. Combine the datasets together again.
# 8. Add colors defined by the movie.

# 1. Rename last two columns
colnames(oscar_categories)[24] <- "Alias"
colnames(oscar_categories)[25] <- "Seen"

# 2. Pivot table. 
oscar_votes <- oscar_categories %>%
  pivot_longer(cols = -c(Alias, Seen), 
               names_to = "Category", 
               values_to = "MovieNominee") %>%
  select(Alias, Category, MovieNominee, Seen)

# 2. Add critic column
oscar_votes <- oscar_votes %>%
  mutate(Critic = ifelse(grepl("NA - Critics' Pick", Seen), 
                         "True", "False"))

# 3. Extract exception movies with "-" in the title
exceptional_movies <- c("Mission: Impossible - Dead Reckoning Part One")

# 4. Subset the data in movieL and movieR such that 
#     the movie title is either on the left or right 
#     side of the delimiter
movieL <- subset(oscar_votes, 
                 Category == "Costume Design" | 
                   Category == "Film Editing" |
                   Category == "International Feature Film" |
                   Category == "Music (Original Score)")
movieR <- filter(oscar_votes, 
                 Category != "Costume Design" & 
                   Category != "Film Editing" &
                   Category != "International Feature Film" &
                   Category != "Music (Original Score)" & 
                   MovieNominee != exceptional_movies)

# 5. Separate MovieNominees into three columns for all 
#     three datasets
movieL_sep <- separate(movieL,
                       MovieNominee,
                       into = c("Movie", "Nominee"),
                       sep = " - ",
                       remove = FALSE,
                       fill = "right")
movieR_sep <- separate(movieR,
                       MovieNominee,
                       into = c("Nominee", "Movie"),
                       sep = " - ",
                       remove = FALSE,
                       fill = "left")
exceptional_movies_data <- oscar_votes %>%
  filter(MovieNominee == exceptional_movies) %>%
  mutate(MovieNominee = exceptional_movies,
         Movie = MovieNominee, 
         Nominee = NA)

# 6. Combine the datasets together again.
votes_combined <- rbind(movieL_sep, movieR_sep, exceptional_movies_data)

# 7. Add colors. 
votes_colors <- votes_combined |>
  mutate(
    color = case_when(
      Movie == "20 Days In Mariupol" ~ "#766c6cff",
      Movie == "American Fiction" ~ "#607292ff",
      Movie == "American Symphony" ~ "#6c4121ff",
      Movie == "Anatomy of a Fall" ~ "#384377ff",
      Movie == "Barbie" ~ "#EF4397",
      Movie == "Bobi Wine: The People's President" ~ "#cc5443ff",
      Movie == "El Conde" ~ "#f490c2ff",
      Movie == "Elemental" ~ "#7e6caeff",
      Movie == "Flamin' Hot" ~ "#ef3c0bff",
      Movie == "Four Daughters" ~ "#053a49ff",
      Movie == "Godzilla Minus One" ~ "#a09e9eff",
      Movie == "Golda" ~ "#e2cc4cff",
      Movie == "Guardian's of the Galaxy Vol. 3" ~ "#58259dff",
      Movie == "Indiana Jones and the Dial of Destiny" ~ "#f1940bff",
      Movie == "Invincible" ~ "#30c3e7ff",
      Movie == "Io Capitano" ~ "#ce8e68ff",
      Movie == "Island In Between" ~ "#785f42ff",
      Movie == "Killers of the Flower Moon" ~ "#833014ff",
      Movie == "Knight of Fortune" ~ "#345759ff",
      Movie == "Letter to a Pig" ~ "#c28a7dff",
      Movie == "May December" ~ "#f93b42ff",
      Movie == "Maestro" ~ "#ffee02",
      Movie == "Mission: Impossible - Dead Reckoning Part One" ~ "#3c4870ff",
      Movie == "NǍI NAI & WÀI PÓ" ~ "#8e212dff",
      Movie == "Napoleon" ~ "#91897cff",
      Movie == "Nimona" ~ "#f153f1ff",
      Movie == "Ninety-Five Senses" ~ "#85be87ff",
      Movie == "Nyad" ~ "#2c788aff",
      Movie == "Oppenheimer" ~ "#3e3222ff",
      Movie == "Our Uniform" ~ "#4b6999ff",
      Movie == "Pachyderme" ~ "#5f6542ff",
      Movie == "Past Lives" ~ "#656d5cff",
      Movie == "Perfect Days" ~ "#a3cba2ff",
      Movie == "Poor Things" ~ "#83b2cbff",
      Movie == "Red, White and Blue" ~ "#384272ff",
      Movie == "Robot Dreams" ~ "#c6a8a9ff",
      Movie == "Rustin" ~ "#a22127ff",
      Movie == "Society of the Snow" ~ "#c8d9cfff",
      Movie == "Spider-Man: Across the Spider-verse" ~ "#444b9fff",
      Movie == "The ABCs of Book Banning" ~ "#1392a9ff",
      Movie == "The After" ~ "#6f6c8fff",
      Movie == "The Barber of Little Rock" ~ "#69534cff",
      Movie == "The Boy And The Heron" ~ "#3c5b67ff",
      Movie == "The Color Purple" ~ "#7a0e84ff",
      Movie == "The Creator" ~ "#6b7b92ff",
      Movie == "The Eternal Memory" ~ "#90adb4ff",
      Movie == "The Holdovers" ~ "#c22b07",
      Movie == "The Last Repair Shop" ~ "#f6c040ff",
      Movie == "The Teacher's Lounge" ~ "#016484ff",
      Movie == "The Wonderful Story of Henry Sugar" ~ "#0386a3ff",
      Movie == "The Zone of Interest" ~ "#31743eff",
      Movie == "To Kill A Tiger" ~ "#88580dff",
      Movie == "War is Over! Inspired by the Music of John and Yoko" ~ "#844619ff",
      TRUE ~ "black"
    )
  )

### Save Data ---------------------------------
readr::write_csv(
  votes_colors, 
  file = "data-clean/votes.csv")

# Thank you!
