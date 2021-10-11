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
fs::dir_tree("~/OneDrive - Region Hovedstaden/R programming/LearnR3/data-raw", recurse = 1)
file_delete(here(c("data-raw/MMASH.zip",
                   "data-raw/SHA256SUMS.txt",
                   "data-raw/LICENSE.txt")))
file_move(here("data-raw/DataPaper"), here("data-raw/mmash"))

