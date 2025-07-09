## Function used for bootstrapping
bootstrap_differences <- function(n, metric.v1, metric.v2) {
  
  1:n |> purrr::map(\(x) {
    # Calculate the pairwise differences
    differences <- (metric.v1 - metric.v2)
    # Resample differences with replacement
    differences <- sample(differences, 
                          replace = TRUE, 
                          size = length(differences))
    # Mean difference for this bootstrap
    difference <- mean(differences, na.rm = TRUE)
    # Standard deviation of the differences
    spread <- sd(differences, na.rm = TRUE)
    # Calculate the effect size of the difference - this is basically Cohen's d for each bootstrap iteration
    scaled_difference <- difference / spread
    
    return(scaled_difference)
  }) |> purrr::list_c()
}

