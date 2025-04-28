##_____________________________###
#                                #
#  Web Scrapping_Homework     #
#                                #
##_____________________________###

# Install and load the packages
# rvest for scraping and dplyr for piping

if (!require("pacman")) install.packages("pacman")

# Load contributed packages with pacman
pacman::p_load(rvest, dplyr, tidyverse)


# Problem:------------------------------
# Go to webpage https://www.american.edu/cas/mathstat/faculty/ 
# and scrape name-email-phone- of faculty/staff.
# Put all files in a csv file called "faculty.csv" and submit it to Canvas.

html<-read_html("https://www.american.edu/cas/mathstat/faculty/")
print(html)

profile_items<-html %>% 
  html_elements("article.profile-item")

names<-c()
emails<-c()
phones<-c()

for(profile_item in profile_items) {
  name<-profile_item %>% 
    html_element(".profile-name") %>% 
    html_element("span") %>% 
    html_text2()
  
  email<-profile_item %>% 
    html_element(".profile-email") %>% 
    html_element("a") %>% 
    html_attr("href")
  if(length(email)==0) {
    email<-NA
  } else{
    email<-gsub("mailto:","",email)}
  
  phone<-profile_item %>% 
    html_element(".profile-phone") %>% 
    html_element("a") %>% 
    html_attr("href")
  if(length(phone)==0) {
    phone<-NA
  } else{
    phone<-gsub("tel:","",phone)}
  
  names<-c(names,name)
  emails<-c(emails,email)
  phones<-c(phones,phone)
}

df<-tibble(name=names,
           phone=phones,
           email=emails)


setwd("~/Desktop/AU/DATA-413/DATA-613_owena-b/webscraping")
write.csv(df, "faculty.csv", row.names = FALSE)
