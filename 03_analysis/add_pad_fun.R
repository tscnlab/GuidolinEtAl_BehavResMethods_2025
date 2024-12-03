# Function that adds padding to each transition state from wear to non-wear, and from now-wear to wear, according to the low illuminance detection

add_transition_pad <- function(df) {
  # Initialise a list to store the updated data frames for each Id
  updated_df_list <- list()
  
  # Loop through each unique Id
  for (id in unique(df$Id)) {
    cat("\nProcessing Id:", id, "\n")
    
    # Subset the data for the current Id
    df_id <- subset(df, Id == id)
    
    # Loop through the rows for this Id to find transitions from 1 to 0 in is_low_medi_cluster
    for (i in 2:nrow(df_id)) {
      # Check if there's a change from 1 to 0 and identify the first istance of is_low_medi_cluster = 0
      if (df_id$is_low_medi_cluster[i] == 0 && df_id$is_low_medi_cluster[i - 1] == 1) {
        cat("\nTransition detected at row:", i, 
            "\nPrevious row is_low_medi_cluster:", df_id$is_low_medi_cluster[i - 1], 
            "\nCurrent row is_low_medi_cluster:", df_id$is_low_medi_cluster[i], "\n")
        
        # If TRUE, check if the previous row has reason not corresponding to NA 
        if (!is.na(df_id$reason[i - 1]) && 
            # And that this previous row has reason == "transition state"  
            df_id$reason[i - 1] == "transition state") {
          cat("Transition state detected at row:", i - 1, "\n")
          
          # If these two criteria are fulfilled,
          # Find the start of the transition state (first "transition state" before this row) by "walking up in the df"
          # and assigning transition_start_index
          transition_start_index <- i - 1
          
          while (transition_start_index > 1 && # set a boundary for "walking up" (i.e. do not look at a row before the first one)
                 !is.na(df_id$reason[transition_start_index - 1]) && # if the previous raw has reason not NA
                 df_id$reason[transition_start_index - 1] == "transition state") { # and still reason = transition state
            
            # then, shift the transition_start_index to this previous row
            transition_start_index <- transition_start_index - 1
          }
          
          # Log rows being updated
          cat("Updating is_low_medi_cluster from row", transition_start_index, 
              "to", i - 1, "to value 0\n")
          cat("Rows before update:\n")
          print(df_id[transition_start_index:(i - 1), ]) # we print this in the console so we can cross-check that it's doing what it is supposed to
          
          # Set is_low_medi_cluster = 0 for the rows from the start of the "transition state" (transition_state_index)
          # to the row just before the detected change (i - 1)
          df_id$is_low_medi_cluster[transition_start_index:(i - 1)] <- 0
        }
      }
    
    # Detect transitions from 0 to 1 
    if (df_id$is_low_medi_cluster[i] == 1 && df_id$is_low_medi_cluster[i - 1] == 0) {
      cat("\nTransition 0 -> 1 detected at row:", i, "\n")
      
      if (!is.na(df_id$reason[i]) && # Check if this row has a reason that is not NA
          df_id$reason[i] == "transition state") { #and that it has reason = transition state
        
        # If these two criteria are fulfilled,
        # Find the end of the transition state by walking down the df 
        # and assigning transition_end_index
        transition_end_index <- i
        while (transition_end_index < nrow(df_id) &&
               !is.na(df_id$reason[transition_end_index + 1]) &&
               df_id$reason[transition_end_index + 1] == "transition state") {
          
          # shift the end of the transition_end_index to this row
          transition_end_index <- transition_end_index + 1
        }
        
        # Set is_low_medi_clusters = 0 for the rows from the start to the end of the transition period
        df_id$is_low_medi_cluster[i:transition_end_index] <- 0
      }
    }
  }
    
    # Add the updated subset for this Id to the list
    updated_df_list[[as.character(id)]] <- df_id
 }
  
  # Combine all updated Id data frames back into a single data frame
  updated_df <- do.call(rbind, updated_df_list)
  
  return(updated_df)
}
  