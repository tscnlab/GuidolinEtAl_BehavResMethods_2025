## ----setup, include=FALSE-----------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## -----------------------------------------------------------------------------------------------------------------------------------------
filepath <- here::here("00_raw_data", "wearlog")

# Get the files names from directory
wearlogfiles = list.files(filepath, pattern="*.csv", full.names = TRUE)



## ----pressure, echo=FALSE-----------------------------------------------------------------------------------------------------------------
wearlog_entries_raw <- 
  #filenames:
  wearlogfiles %>% 
  #import_Statechanges from LightLogR to create states based on timestamps
  LightLogR::import_Statechanges(
    sep = ";", dec = ",", Datetime.format = "dmyHM", tz = "Europe/Berlin", 
    Id.colname = record_id,
    State.colnames = 
      c("wearlog_on", "wearlog_off", "wearlog_past_on", "wearlog_past_off", "wearlog_bed", "wearlog_past_sleep"),
    State.encoding = 
      c("1", "0", "1", "0", "2", "2") #off coded as 0, on coded as 1, sleep coded as 2
    ) 



## -----------------------------------------------------------------------------------------------------------------------------------------
wearlog_past <- wearlogfiles %>%
  #import_Statechanges from LightLogR to create states based on timestamps
  LightLogR::import_Statechanges(
    sep = ";", dec = ",", Datetime.format = "dmyHM", tz = "Europe/Berlin", 
    Id.colname = record_id,
    State.colnames = 
      c("wearlog_on",
        "wearlog_off",
        "wearlog_past_on",
        "wearlog_past_off",
        "wearlog_bed",
        "wearlog_past_sleep"),
    State.encoding = 
      c("present",
        "present",
        "past",
        "past",
        "present",
        "past")
    ) 

wearlog_past$State <- as.factor(wearlog_past$State)

wearlog_past_summary <- wearlog_past %>%
  group_by(State) %>%
  summarise(n=n())


