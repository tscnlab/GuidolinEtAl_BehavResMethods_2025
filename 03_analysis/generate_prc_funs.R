# Main function to generate PRC metrics for specific parameters
generate_prc_medi <- function(dataset, low_var, min_length, max_interrupt, medi_threshold) {
  
  #Create a dynamic column names based on the variable from which we want to detect clusters
  low_var_name <- paste0("low_", tolower(low_var))
  cluster_name <- paste0(low_var_name, "_cluster")
  
  medi_clusters <- dataset %>%
    ungroup() %>%
    mutate(State = if_else(State == "sleep", NA_character_, State)) %>% #converting all sleep values to NAs, since we do not want to use these for our classification 
    #Dinamically set the "low variable" flag, so that it can be either low_pim or low_medi
    mutate(!!sym(low_var_name) := !!sym(low_var) < medi_threshold) %>%
    nest_by(Id) %>%
    mutate(
      data = list(
        data_find_clusters(
          data, 
          !!sym(low_var_name), 
          min_length = min_length, 
          max_interrupt = max_interrupt, 
          cluster_name = cluster_name
        )
      )
    ) %>%
    unnest(cols = data) %>%
    ungroup()
  
  mediclusters_clean <- medi_clusters %>%
    select(Id, Datetime, State, !!sym(cluster_name)) %>%
    mutate(
      State = case_when(
        State == "on" ~ 1, 
        State == "off" ~ 0,
        is.na(State) ~ NA_real_), # keep sleep states as NA,
      !!sym(cluster_name) := case_when(
        !!sym(cluster_name) == TRUE ~ 0,
        !!sym(cluster_name) == FALSE ~ 1
      )) 
  
  #We want to build a precision recall curve for our classifier algorithm, which, based o our "Ground truth", i.e. the wear log state values (on = 1 and off = 1), classifies the performance of our algorithm for detecting non-wear as follows:
  #1) State = 0, cluster = 0 -> true positive
  #2) State = 0, cluster = 1 -> false negative
  #3) State = 1, cluster = 1 -> false positive
  #4) State = 1, cluster = 0 -> true negative
  
  mediclusters_clean <- mediclusters_clean %>%
    mutate(classification = case_when(
      State == 0 & !!sym(cluster_name) == 0 ~ "TP",
      State == 0 & !!sym(cluster_name) == 1 ~ "FN",
      State == 1 & !!sym(cluster_name) == 0 ~ "FP",
      State == 1 & !!sym(cluster_name) == 1 ~ "TN",
      .default = NA_character_))
  
  prc_medi <- mediclusters_clean %>%
    group_by(classification) %>% #!! if you want to visualise individual PRC, then you have to group_by(Id, classification). Else, only group_by(classification)
    summarise(count = n()) %>%
    pivot_wider(names_from = classification, values_from = count, values_fill = list(count=0)) %>%
    mutate(TPR = TP/(TP+FN), #true positive rate
           FPR = FP/(FP+TN), #false positive rate
           PPV = TP/(TP+FP), #positive predictive value
           NPV = TN/(FN+TN)) #negative predictive value  
  
  return(prc_medi)
}
