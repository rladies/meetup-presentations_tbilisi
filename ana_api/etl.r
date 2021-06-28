library(rvest)
library(tibble)
library(magrittr)
library(stringr)
library(dplyr)
library(purrr)
library(writexl)

# get all pages with ad lists
page <- read_html("https://www.hr.ge/announcements/of-vacancy")
page_hrefs <- page %>% 
  html_nodes(".pagination a") %>% 
  html_attr("href") %>% 
  unique()
urls <- paste("https://hr.ge", page_hrefs, sep = "")

# get the list of all ad urls
get_urls_hrge <- function(url){
  page <- read_html(url)
  all_urls <- page %>% html_nodes("tr") %>%  html_nodes("td") %>% 
    html_node("a") %>% html_attr("href") %>% str_subset("/announcement/") %>% 
    substr(1,19) %>% paste("https://hr.ge", ., sep = "") 
}
ad_urls <- map(urls, get_urls_hrge) %>% unlist() %>% unique()

# some udf's we will need 
months = list("იან" = "01", "თებ" = "02", "მარ" = "03", "აპრ" = "04", 
              "მაი" = "05", "ივნ" = "06", "ივლ" = "07", "აგვ" = "08", 
              "სექ" = "09", "ოქტ" = "10", "ნოე" = "11", "დეკ" = "12")
paste2 <- function(charvec, collapse = ", "){if (all(is.na(charvec))){NA} else {paste(charvec, collapse = collapse)}}


# function to scrape data from an ad page with x = ad_url. returns a dataframe
scrape_hrge <- function(x){
  ad_html <- read_html(x)
  # position title
  A <- ad_html %>% html_nodes(".anncmt-title") %>% html_text(trim = T) %>% as.data.frame(stringsAsFactors = F)
  employer <- ad_html %>% html_nodes(".anncmt-customer") 
  # employer name
  B <- employer %>% html_text(trim = T) %>% as.data.frame(stringsAsFactors = F)

  employer_url_given <- employer %>% html_node("a")
  if (is.na(employer_url_given)){
    P <- NA %>% as.data.frame(stringsAsFactors = F) 
    N <- NA	%>% as.data.frame(stringsAsFactors = F)
  } else {
    employer_url <- paste("https://hr.ge", employer_url_given %>% html_attr("href"), sep = "")
    #url for employer page on hr.ge
    P <- employer_url %>% as.data.frame(stringsAsFactors = F) 
    employer_html = read_html(employer_url)
    # description of employer from employer page on hr.ge
    N <- employer_html %>% html_node(".details") %>% html_node("p") %>% html_text(trim = TRUE) %>% 
      as.data.frame(stringsAsFactors = F)
  }
  
  
  category_text <- ad_html %>% html_nodes(".ctg-list") %>% html_text(trim = TRUE)
  if (length(category_text) != 0) {category <- category_text %>% gsub("\\s\\s+", ", ", .) %>% 
    gsub(" ,,", "", .) %>% gsub(":,", ":", .)} else {category <- NA}
  # hr.ge assigned category for the position 
  C <- category %>% as.data.frame(stringsAsFactors = F)
  
  info_rows <- ad_html %>% html_nodes("div") %>% html_nodes(".posting-details") %>% html_nodes("table") %>% html_nodes("tr")
  
  info_list <- list("თარიღები:" = NA, "მდებარეობა:"= NA, "დასაქმების ფორმა:"= NA, "ხელფასი:"= NA, "განათლება:"= NA, "გამოცდილება:"= NA, "ენები:"= NA, "ელ. ფოსტა:"= NA)
  for (row1 in info_rows) {
    name <- row1 %>% html_node("strong") %>% html_text(trim = TRUE)
    if (is.na(name)) {
      next } else {	
        text <- row1 %>% html_text(trim = TRUE) %>% strsplit(" *,*\\s\\s+") %>% extract2(1)
        info_list[[name]] <- text[2:length(text)]
      }
  }
  
  info_list[["თარიღები:"]] <- info_list[["თარიღები:"]] %>% str_split(" - ") %>% unlist
  
  # date ad was posted
  D <- as.Date(paste(substr(info_list[["თარიღები:"]][1], 1,2), months[[substr(info_list[["თარიღები:"]][1],4,6)]], "2018", sep = ""), format = '%d%m%Y') %>% as.data.frame(stringsAsFactors = F)
  # application deadline
  E <- as.Date(paste(substr(info_list[["თარიღები:"]][2], 1,2), months[[substr(info_list[["თარიღები:"]][2],4,6)]], "2018", sep = ""), format = '%d%m%Y') %>% as.data.frame(stringsAsFactors = F)
  Z <- paste2(info_list[["მდებარეობა:"]]) %>% as.data.frame(stringsAsFactors = F)
  G <- paste2(info_list[["დასაქმების ფორმა:"]]) %>% as.data.frame(stringsAsFactors = F) # სამუშაო განრიგი
  H <- paste2(info_list[["ხელფასი:"]]) %>% as.data.frame(stringsAsFactors = F)
  I <- paste2(info_list[["განათლება:"]]) %>% as.data.frame(stringsAsFactors = F)
  J <- paste2(info_list[["გამოცდილება:"]]) %>% as.data.frame(stringsAsFactors = F)
  K <- paste2(info_list[["ენები:"]]) %>% as.data.frame(stringsAsFactors = F)
  L <- paste2(info_list[["ელ. ფოსტა:"]]) %>% as.data.frame(stringsAsFactors = F)
  
  
  ad_descr <- ad_html %>% html_node(".firm-descr")
  # text from ad body 
  M <- ad_descr %>% html_text(trim = TRUE) %>% as.data.frame(stringsAsFactors = F)
  # ad url
  O <- x %>% as.data.frame(stringsAsFactors = F)
  
  ad_urls <- list()
  for (url in ad_descr %>% html_nodes("a")) {
    ad_urls <- append(ad_urls, url %>% html_attr("href"))
  }
  ad_urls <- paste(unlist(ad_urls), collapse = ", ")
  # all urls from ad body
  Q <- ad_urls %>% as.data.frame(stringsAsFactors = F)
  # ad class 
  R <- ad_html %>% html_nodes(".anncmt-title") %>% html_node('div') %>% 
    html_attr("class") %>% gsub("\\s\\s+", "", .) %>% as.data.frame(stringsAsFactors = F)
  
  df_row <- cbind(A, B, C, D, E, Z, G, H, I, J, K, L, M, N, O, P, Q, R)
  names(df_row) <- c("ვაკანსია", "დამსაქმებელი", "კატეგორია_განცხადებიდან",
                     "გამოქვეყნდა", "ბოლო_ვადა", "მდებარეობა", "სამუშაო_განრიგი", "ანაზღაურება", 
                     "განათლება", "გამოცდილება", "ენები", "ელ_ფოსტა", "ვაკანსიის_დეტალები",
                     "დამსაქმებლის_დეტალები", "ვაკანსიის_ლინკი", "დამსაქმებლის_ლინკი", 
                     "ლინკები_ვაკანსიის_დეტალებიდან","vip_exclusive_p")

  df_row <- as.tibble(df_row)
  print(x) 
  return(df_row)  
}

df <- map_df(ad_urls, scrape_hrge)


write.csv(df, file = 'scraped_data.csv')
write_xlsx(df, path = 'scraped_data.xlsx', col_names = TRUE)
