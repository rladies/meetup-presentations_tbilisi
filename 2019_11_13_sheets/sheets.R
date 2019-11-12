library(googledrive)
library(googlesheets4)
library(readxl)
library(dplyr)

# auth with both drive and sheets

# test folder for today

test_gdrive_dir <- "tbilisi_meetup"
drive_mkdir(test_gdrive_dir, overwrite = TRUE)

# read and write sheets within your personal drive

# read public sheet not in your drive

drive_upload(
    drive_example("chicken.csv"),
    file.path(test_gdrive_dir, "chicken"),
    type = "spreadsheet"
)

drive_download(file.path(test_gdrive_dir, "chicken"), "local_chicken.csv", "csv", overwrite = TRUE)
drive_download(file.path(test_gdrive_dir, "chicken"), "local_chicken.xlsx", "xlsx", overwrite = TRUE)

drive_upload(
    drive_example("chicken.csv"),
    file.path(test_gdrive_dir, "chicken_shared"),
    type = "spreadsheet"
)
drive_share(
    file.path(test_gdrive_dir, "chicken_shared"),
    role = "reader", type = "anyone"
)

gapminder_gs <- sheets_example("gapminder")
sheets_get(gapminder_gs)
sheets_read(gapminder_gs, "Asia")

# different ways to identify a google sheet

drive_get(path = file.path(test_gdrive_dir, "chicken"))
drive_get(id = "1U6Cf_qEOhiR9AZqTqS3mbMF3zt2db48ZP5v3rkrAEJY")
drive_get(id = "https://docs.google.com/spreadsheets/d/1U6Cf_qEOhiR9AZqTqS3mbMF3zt2db48ZP5v3rkrAEJY/edit#gid=780868077")
drive_find("chick")
sheets_get("1U6Cf_qEOhiR9AZqTqS3mbMF3zt2db48ZP5v3rkrAEJY")
sheets_get(drive_get(path = file.path(test_gdrive_dir, "chicken")))
sheets_find("chick")

# loop through google sheets worksheets

sheets_sheets(gapminder_gs)
gapminder_df <- purrr::map_df(
    sheets_sheets(gapminder_gs),
    ~sheets_read(gapminder_gs, .x)
)

# read cell formatting

#' color coded data
#' formula
#' data validaton

# create new sheet and manage permissions

# auth in non-interactive mode

# motivating example: read complex xlsx

#' - contains summary tables
#' - multiple header rows
#' - excel data format

# loop through worksheets
