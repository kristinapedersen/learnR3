library(here)
#> here() starts at /builds/rostools/r-cubed-intermediate

#download data
mmash_link <- "https://physionet.org/static/published-projects/mmash/multilevel-monitoring-of-activity-and-sleep-in-healthy-people-1.0.0.zip"
download.file(mmash_link, destfile = here("data-raw/mmash-data.zip"))

#Unzip downloaded data file
unzip(here("data-raw/mmash-data.zip"),
      exdir = here("data-raw"),
      junkpaths = TRUE)

unzip(here("data-raw/MMASH.zip"),
      exdir = here("data-raw"))

#Remove and tidy up files
library(fs)
fs::dir_tree("~/OneDrive - Region Hovedstaden/R programming/LearnR3", recurse = 1)

file_delete(here(c("data-raw/MMASH.zip",
                   "data-raw/SHA256SUMS.txt",
                   "data-raw/LICENSE.txt")))

file_move(here("data-raw/DataPaper"), here("data-raw/mmash"))

#Import datasets
user_info_df <- import_multiple_files("user_info.csv",
                                      import_user_info)

saliva_data_df <- import_multiple_files("saliva.csv",
                                        import_saliva_data)

rr_df <- import_multiple_files("RR.csv",
                               import_RR_data())

Actigraph_df <- import_multiple_files("Actigraph.csv",
                                      import_Actigraph_data)

# Split and summarise data
summarised_Actigraph_df <- Actigraph_df %>%
    group_by(file_path_id, day, steps) %>%
    summarise(across(hr,
                     list(Mean = mean,
                          SD = sd), na.rm = TRUE)) %>%
    ungroup()

# Split and summarise data
summarised_rr_df <- rr_df %>%
    group_by(day, file_path_id) %>%
    summarise(across(ibi_s,
                     list(Mean = mean,
                          SD = sd), na.rm = TRUE)) %>%
    ungroup()
