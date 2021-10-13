library(here)
library(fs)
library(tidyverse)
library(vroom)
source(here("R/functions.R"))

#> here() starts at /builds/rostools/r-cubed-intermediate

#download data
# mmash_link <- "https://physionet.org/static/published-projects/mmash/multilevel-monitoring-of-activity-and-sleep-in-healthy-people-1.0.0.zip"
# download.file(mmash_link, destfile = here("data-raw/mmash-data.zip"))

#Unzip downloaded data file
# unzip(here("data-raw/mmash-data.zip"),
#       exdir = here("data-raw"),
#       junkpaths = TRUE)
#
# unzip(here("data-raw/MMASH.zip"),
#       exdir = here("data-raw"))

#Remove and tidy up files
# fs::dir_tree("~/OneDrive - Region Hovedstaden/R programming/LearnR3", recurse = 1)
#
# file_delete(here(c("data-raw/MMASH.zip",
#                    "data-raw/SHA256SUMS.txt",
#                    "data-raw/LICENSE.txt")))
#
# file_move(here("data-raw/DataPaper"), here("data-raw/mmash"))

#Import datasets
user_info_df <- import_multiple_files("user_info.csv",
                                      import_user_info)

saliva_data_df <- import_multiple_files("saliva.csv",
                                        import_saliva_data)

rr_df <- import_multiple_files("RR.csv",
                               import_RR_data)

Actigraph_df <- import_multiple_files("Actigraph.csv",
                                      import_Actigraph_data)

# Split and summarise data
summarised_Actigraph_df <- Actigraph_df %>%
  group_by(user_id, day) %>%
  summarise(across(hr,
                   list(Mean = mean,
                        SD = sd), na.rm = TRUE)) %>%
  ungroup()

# Split and summarise data
summarised_rr_df <- rr_df %>%
  group_by(day, user_id) %>%
  summarise(across(ibi_s,
                   list(Mean = mean,
                        SD = sd), na.rm = TRUE)) %>%
  ungroup()

#Generating column in the saliva data by day
saliva_with_data_df <- saliva_data_df %>%
  mutate(day = case_when(samples == "before sleep" ~ 1,
                         samples == "wake up" ~ 2,
                         TRUE ~ NA_real_))

#merging all the data
mmash <- reduce(
  list(
    user_info_df,
    saliva_with_data_df,
    summarised_rr_df,
    summarised_Actigraph_df
  ),
  full_join
)

#writing the data
usethis::use_data(mmash, overwrite = TRUE)

#save in csv
vroom_write(mmash, here("data/mmash.csv"))
