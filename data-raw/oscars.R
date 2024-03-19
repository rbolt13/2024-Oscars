### Oscars Data (Raw) -----------------------------
# Date: March 14, 2024
# Description: This file loads the raw google forms 
# survey data, removes the first two columns for 
# privacy, and lastly saves it as a .csv file into 
# the data-raw folder.
here::i_am("data-raw/oscars.R")

### Load Libraries ------------------------------
# googlesheets4: Read data from a google sheet URL. 
# readr: Save data as .csv file. 
library(googlesheets4)
library(readr)

### Get Data -----------------------------
# Call (and authentication) Data
oscars_full <- googlesheets4::read_sheet(
  "https://docs.google.com/spreadsheets/d/1uLKydUeW7y21hV5J1hqm84FmC4ADTJlllpX6sh0dl0M/edit?resourcekey#gid=60952515",
  sheet = "2024",
  na= "NA")

# Remove unnecessary columns
oscars <- oscars_full[,3:27]

### Save as .csv File -------------------------
readr::write_csv(
  oscars, 
  file = "data-raw/oscars.csv")