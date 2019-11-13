# all part of the tidyverse
library(googledrive)
library(googlesheets4)
library(readxl)
library(dplyr)

# links to slides: https://docs.google.com/presentation/d/1YlaFQI1dVZ_5fE6glzBsHc67z02G_kHhlq0WAEobsdM

# auth with both drive and sheets -----------------------

# it will work without this, but with separate tokens: error prone
drive_auth()
sheets_auth(token = drive_token())

# read sheets within your personal drive -------------------

chicken_gs <- drive_upload(
    media = drive_example("chicken.csv"),
    "chicken",
    type = "spreadsheet"
)
chicken_gs

drive_download(chicken_gs, "local_chicken.csv", "csv", overwrite = TRUE)

# ??? sometimes working, sometimes not working ATM
drive_download("chicken", "local_chicken.csv", "csv", overwrite = TRUE)

# read public sheet not in your drive ----------------------
# possible without auth with your personal user but with token, not covered today

gapminder_gs <- sheets_example("gapminder")
gapminder_gs
sheets_browse(gapminder_gs)
sheets_get(gapminder_gs)
sheets_read(gapminder_gs, "Asia")

drive_download(gapminder_gs, "local_gapminder.xlsx", type = "xlsx", overwrite = TRUE)
# silently only first sheet
drive_download(gapminder_gs, "local_gapminder_sheet.csv", type = "csv", overwrite = TRUE)

# loop through google sheets worksheets ------------------

sheets_sheets(gapminder_gs)
gapminder_df <- purrr::map_df(
    sheets_sheets(gapminder_gs),
    ~sheets_read(gapminder_gs, .x)
)

# different ways to identify a google sheet ----------------

# ??? sometimes working, sometimes not working ATM
drive_get(path = "chicken")

# working
drive_get(id = "1U6Cf_qEOhiR9AZqTqS3mbMF3zt2db48ZP5v3rkrAEJY")
drive_get(id = "https://docs.google.com/spreadsheets/d/1U6Cf_qEOhiR9AZqTqS3mbMF3zt2db48ZP5v3rkrAEJY/edit#gid=780868077")
drive_find("chick")
sheets_get("1U6Cf_qEOhiR9AZqTqS3mbMF3zt2db48ZP5v3rkrAEJY")
sheets_find("chick")


# create new sheet and manage permissions ----------------------

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

# read cell formatting ---------------------------

#' read formula
cell_info <- sheets_cells(sheets_example("formulas-and-formats"))
filter(cell_info, loc == "E3")$cell


#' read color coded data
req <- request_generate(
    "sheets.spreadsheets.get",
    list(
        spreadsheetId = sheets_example("formulas-and-formats"),
        includeGridData = TRUE
    )
)
response <- request_make(req)
content <- httr::content(response)

View(content$sheets[[1]]$data[[1]])

content$sheets[[1]]$data[[1]]$rowData[[6]]$values[[4]]$effectiveFormat$backgroundColor

# read data validation

# cell_info <- sheets_cells(chicken_gs)
# filter(cell_info, loc == "D2")$cell

req <- request_generate(
    "sheets.spreadsheets.get",
    list(
        spreadsheetId = as_id(chicken_gs),
        includeGridData = TRUE
    )
)
response <- request_make(req)
content <- httr::content(response)
content$sheets[[1]]$data[[1]]$rowData[[2]]$values[[4]]$dataValidation

# write formatting

# ? put together low level API request

drive_trash(chicken_gs)


# read with range specification

#' - contains summary tables
#' - multiple header rows
#' - excel date format

# loop through worksheets of excel -----------------------

read_excel("local_gapminder.xlsx")
read_excel("local_gapminder.xlsx", sheet = "Asia")
purrr::map_df(
    excel_sheets("local_gapminder.xlsx"),
    ~read_excel("local_gapminder.xlsx", sheet = .x)
)
