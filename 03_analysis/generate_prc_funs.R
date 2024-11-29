# Main function to generate PRC metrics for specific parameters
generate_prc <- function(dataset, low_var, min_length, max_interrupt, threshold) {
  
  #Create a dynamic column names based on the variable from which we want to detect clusters
  low_var_name <- paste0("low_", tolower(low_var))  # e.g., "low_medi" or "low_pim"
  cluster_name <- paste0(low_var_name, "_cluster")  # Expected column name to pass in data_find_clusters()
  cluster_column <- paste0("is_", cluster_name)
  
  clusters <- dataset %>%
    ungroup() %>%
    #Dinamically set the "low variable" flag, so that it can be either low_pim or low_medi
    mutate(!!sym(low_var_name) := !!sym(low_var) < threshold) %>%
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
  
  clusters_clean <- clusters %>%
    select(Id, Datetime, State, !!sym(cluster_column), MEDI) %>%
    mutate(
      State = case_when(
        State == "on" ~ 1, 
        State == "off" ~ 0,
        is.na(State) ~ NA_real_), # keep sleep states as NA,
      !!sym(cluster_column) := case_when(
        !!sym(cluster_column) == TRUE ~ 0,
        !!sym(cluster_column) == FALSE ~ 1
      )) 
  
  #We want to build a precision recall curve for our classifier algorithm, which, based o our "Ground truth", i.e. the wear log state values (on = 1 and off = 0), classifies the performance of our algorithm for detecting non-wear as follows:
  #1) State = 0, cluster = 0 -> true positive
  #2) State = 0, cluster = 1 -> false negative
  #3) State = 1, cluster = 1 -> false positive
  #4) State = 1, cluster = 0 -> true negative
  
  clusters_clean_2 <- clusters_clean %>%
    mutate(classification = case_when(
      State == 0 & !!sym(cluster_column) == 0 ~ "TP",
      State == 0 & !!sym(cluster_column) == 1 ~ "FN",
      State == 1 & !!sym(cluster_column) == 0 ~ "FP",
      State == 1 & !!sym(cluster_column) == 1 ~ "TN",
      .default = NA_character_))
  
  prc <- clusters_clean_2 %>%
    group_by(classification) %>% #!! if you want to visualise individual PRC, then you have to group_by(Id, classification). Else, only group_by(classification)
    summarise(count = n()) %>%
    pivot_wider(names_from = classification, values_from = count, values_fill = list(count=0)) %>%
    mutate(TPR = TP/(TP+FN), #true positive rate
           FPR = FP/(FP+TN), #false positive rate
           PPV = TP/(TP+FP), #positive predictive value
           NPV = TN/(FN+TN)) #negative predictive value  
  
  return(prc)
}


