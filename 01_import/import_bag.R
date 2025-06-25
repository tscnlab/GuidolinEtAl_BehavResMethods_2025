## ----setup, include=FALSE-----------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ----pressure, echo=FALSE-----------------------------------------------------------------------------------------
#First, turn it into a dataframe

wearlog_df <- lapply(
  wearlogfiles, 
  function(x) read.csv(x, stringsAsFactors = FALSE, sep = ";")
  ) %>% 
  list_c()

#Filter the columns of interest
wearlog_bag <- wearlog_df %>%
  select("record_id", "wearlog_off", "wearlog_past_off", "wearlog_bag", "wearlog_past_bag")

#This leads to a lot of NA values in the dataframe: when wearlog_bag has value, wearlog_past_bag is NA and viceversa. We want to delete rows where these values are both NA, as they are not useful for us right now. 
wearlog_bag_clean <- wearlog_bag %>%
    rowwise()%>%
    filter(xor(!is.na(wearlog_bag), !is.na(wearlog_past_bag)))


#Combine the information from the retrospectively logged events and events logged "in real time"
wearlog_bag_clean <- wearlog_bag_clean %>%
                    mutate(timestamp_combined = case_match(wearlog_off,
                                                           NA ~ wearlog_past_off, #if wearlog_off is NA, wearlog_past_off is taken
                                                           "" ~ wearlog_past_off, #if wearlog_off is empty, wearlog_past_off is taken
                                                           .default = wearlog_off),
                           bag_combined = case_match(wearlog_bag,
                                                     NA ~ wearlog_past_bag, #if wearlog_bag is NA, wearlog_past_bag is taken
                                                     .default = wearlog_bag))%>%
                    select(record_id, timestamp_combined, bag_combined) #select columns of interest


