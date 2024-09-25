# Main function to generate PRC metrics for specific parameters
generate_prc_medi <- function(dataset, low_medi_var, min_length, max_interrupt, medi_threshold) {
  medi_clusters <- dataset %>%
    ungroup() %>%
    filter(!State == "sleep") %>%
    mutate(low_medi = !!sym(low_medi_var) < medi_threshold) %>%
    nest_by(Id) %>%
    mutate(
      data = list(
        data_find_clusters(
          data, 
          low_medi, 
          min_length = min_length, 
          max_interrupt = max_interrupt, 
          cluster_name = "low_medi_cluster"
        )
      )
    ) %>%
    unnest(cols = data) %>%
    ungroup()
  
  mediclusters_clean <- medi_clusters %>%
    select(Id, Datetime, State, is_low_medi_cluster) %>%
    mutate(
      State = case_when(
        State == "on" ~ 1, 
        State == "off" ~ 0),
      is_low_medi_cluster = case_when(
        is_low_medi_cluster == TRUE ~ 0,
        is_low_medi_cluster == FALSE ~ 1
      )) 
  
  #We want to build a precision recall curve for our classifier algorithm, which, based o our "Ground truth", i.e. the wear log state values (on = 1 and off = 1), classifies the performance of our algorithm for detecting non-wear as follows:
  #1) State = 0, cluster = 0 -> true positive
  #2) State = 0, cluster = 1 -> false negative
  #3) State = 1, cluster = 1 -> false positive
  #4) State = 1, cluster = 0 -> true negative
  
  mediclusters_clean <- mediclusters_clean %>%
    mutate(classification = case_when(
      State == 0 & is_low_medi_cluster == 0 ~ "TP",
      State == 0 & is_low_medi_cluster == 1 ~ "FN",
      State == 1 & is_low_medi_cluster == 0 ~ "FP",
      State == 1 & is_low_medi_cluster == 1 ~ "TN",
      .default = NA_character_))
  
  prc_medi <- mediclusters_clean %>%
    group_by(classification) %>% #!! if you want to visualise individual PRC, then you have to group_by(Id, classification). Else, only group_by(classification)
    summarise(count = n()) %>%
    pivot_wider(names_from = classification, values_from = count, values_fill = list(count=0)) %>%
    mutate(TPR = TP/(TP+FN), #true positive rate
           FPR = FP/(FP+TN), #false positive rate
           PPV = TP/(TP+FP), #positive predictive value
           NPV = TN/(FN+TN), #negative predictive value
           threshold = threshold)  #adding manually which threshold I am considering here 
  
  #Add the result to the list
  prc_medi_list[[as.character(threshold)]] <- prc_medi
}
