library(googledrive)
library(googlesheets4)
library(readxl)
library(dplyr)

# auth with both drive and sheets

# read sheets within your personal drive

chicken_gs <- drive_upload(
    drive_example("chicken.csv"),
    "chicken",
    type = "spreadsheet"
)
chicken_gs

drive_download(chicken_gs, "local_chicken.csv", "csv", overwrite = TRUE)

# ?
drive_download("chicken", "local_chicken.csv", "csv", overwrite = TRUE)

# read public sheet not in your drive
# possible without auth with your personal user but with token, not covered today

gapminder_gs <- sheets_example("gapminder")
gapminder_gs
sheets_get(gapminder_gs)
sheets_read(gapminder_gs, "Asia")

drive_download(gapminder_gs, "local_gapminder.xlsx", type = "xlsx", overwrite = TRUE)
# silently only first sheet
drive_download(gapminder_gs, "local_gapminder_sheet.csv", type = "csv", overwrite = TRUE)

# loop through google sheets worksheets

sheets_sheets(gapminder_gs)
gapminder_df <- purrr::map_df(
    sheets_sheets(gapminder_gs),
    ~sheets_read(gapminder_gs, .x)
)

# different ways to identify a google sheet

# ??? not working ATM
drive_get(path = "chicken")

# working
drive_get(id = "1U6Cf_qEOhiR9AZqTqS3mbMF3zt2db48ZP5v3rkrAEJY")
drive_get(id = "https://docs.google.com/spreadsheets/d/1U6Cf_qEOhiR9AZqTqS3mbMF3zt2db48ZP5v3rkrAEJY/edit#gid=780868077")
drive_find("chick")
sheets_get("1U6Cf_qEOhiR9AZqTqS3mbMF3zt2db48ZP5v3rkrAEJY")
sheets_find("chick")

# create new sheet and manage permissions

chicken_shared_gs <- drive_upload(
    drive_example("chicken.csv"),
    "chicken_shared",
    type = "spreadsheet"
)

drive_reveal(chicken_shared_gs, "permissions")$permissions_resource
drive_share(
    chicken_shared_gs,
    role = "reader", type = "anyone"
)

drive_reveal(chicken_shared_gs, "permissions")$permissions_resource

drive_trash(chicken_shared_gs)

# read cell formatting

#' color coded data
#' formula
#' data validaton


# motivating example: read complex xlsx

#' - contains summary tables
#' - multiple header rows
#' - excel data format

# loop through worksheets of excel

read_excel("local_gapminder.xlsx")
read_excel("local_gapminder.xlsx", sheet = "Asia")
purrr::map_df(
    excel_sheets("local_gapminder.xlsx"),
    ~read_excel("local_gapminder.xlsx", sheet = .x)
)
