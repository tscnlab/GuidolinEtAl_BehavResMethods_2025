# First, we write two functions to format time in desirable way (hms class, HH:MM:SS)

## Helper function to round hms
round_hms <- function(x) {
  hms::as_hms(round(as.numeric(x)))  # Round numeric seconds and return as hms
}

## Function to format the time 
style_time <- function(x){
  x %>%
    as.numeric() %>%
    hms::as_hms() %>%
    round_hms()
}

# We need one more function to format time so that it displayed as HH:MM and that handles negative time differences
format_time <- function(x) {
  # Apply the formatting to each element of x
  sapply(x, function(x_value) {
    is_negative <- x_value < 0
    # Use the absolute value for formatting the time
    x_value <- abs(x_value)
    # Format the time in HH:MM
    hours <- floor(x_value / 3600)
    minutes <- floor((x_value %% 3600) / 60)
    # Create formatted time
    formatted_time <- paste0(sprintf("%02d", hours), ":", sprintf("%02d", minutes))
    # If the value was negative, add the negative sign back
    if (is_negative) {
      formatted_time <- paste0("-", formatted_time)
    }
    return(formatted_time)
  })
}

# Function used to calculate timing metrics across three datasets
# Takes three datasets (raw, wrlg, clusters) where non-wear has been calculated differently, and a metric that has to be calculated
# The output is a df for which, for each input df (i.e. non-wear dfs), mean value of timing for each Id across 6 full days of stud participantion, and a sd indicating variability across the 6 days, are shown 

calculate_metric <- function(raw_df, wrlg_df, clusters_df, metric) {
  # Ensure the metric column is dynamically selected
  
  # Raw df
  metric_raw <- raw_df %>%
    select(Id, all_of(metric)) %>%
    group_by(Id) %>%
    summarize(
      mean_time = style_time(mean(as.numeric(.data[[metric]]), na.rm = TRUE)), # Calculate mean and convert back to hms
      sd_time = style_time(sd(as.numeric(.data[[metric]]), na.rm = TRUE))      # Calculate sd and convert back to hms
    )
  
  # Wear log df
  metric_wrlg <- wrlg_df %>%
    select(Id, all_of(metric)) %>%
    group_by(Id) %>%
    summarize(
      mean_time = style_time(mean(as.numeric(.data[[metric]]), na.rm = TRUE)), # Calculate mean and convert back to hms
      sd_time = style_time(sd(as.numeric(.data[[metric]]), na.rm = TRUE))      # Calculate sd and convert back to hms
    )
  
  # Clusters df
  metric_clusters <- clusters_df %>%
    select(Id, all_of(metric)) %>%
    group_by(Id) %>%
    summarize(
      mean_time = style_time(mean(as.numeric(.data[[metric]]), na.rm = TRUE)), # Calculate mean and convert back to hms
      sd_time = style_time(sd(as.numeric(.data[[metric]]), na.rm = TRUE))      # Calculate sd and convert back to hms
    )
  
  # Joining the dataframes
  temp_df <- full_join(metric_raw, metric_wrlg, by = "Id") %>%
    rename(mean_raw = mean_time.x,
           sd_raw = sd_time.x,
           mean_wrlg = mean_time.y,
           sd_wrlg = sd_time.y)
  
  metric_all <- full_join(temp_df, metric_clusters, by = "Id") %>%
    rename(mean_clusters = mean_time,
           sd_clusters = sd_time)
  
  # Calculating deltas 
  metric_all <- metric_all %>%
    mutate(delta_wrlg = hms::as_hms(mean_wrlg - mean_raw),
           delta_clusters = hms::as_hms(mean_clusters - mean_raw)) 
  
  return(metric_all)
}

## Function for visualising comparison of metrics across two datasets
visualize_comparison <- function(data, x_col, y_col, x_label, y_label, title) {
  
  # Get the range of the x-axis and y-axis values (numeric)
  x_range <- range(as.numeric(data[[x_col]]), na.rm = TRUE)
  y_range <- range(as.numeric(data[[y_col]]), na.rm = TRUE)
  
  # Create breaks to display only n_labels on the x-axis and y-axis
  x_breaks <- seq(from = x_range[1], to = x_range[2], length.out = 3) # choosing to only show 3 labels
  y_breaks <- seq(from = x_range[1], to = x_range[2], length.out = 3) # choosing to only show 3 labels
  
  # Plot the data
  p <- ggplot(data, aes(x = as.numeric(.data[[x_col]]), y = as.numeric(.data[[y_col]]), colour = Id)) +
    geom_jitter() +
    geom_abline(intercept = 0, slope = 1, colour = "darkgrey", linetype = "dashed") + 
    scale_y_continuous(labels = function(x) format_time(x),
                       breaks = y_breaks) +  # Use custom HH:MM formatting for y-axis
    scale_x_continuous(labels = function(x) format_time(x), # Use custom HH:MM formatting for x-axis
                       breaks = x_breaks,
                       guide = guide_axis(check.overlap = TRUE)) +  
    labs(x = x_label, y = y_label) +
    coord_fixed(ratio = 1) +
    theme_bw() +
    ggpubr::rremove("legend") +
    theme(plot.margin = unit(c(t=0,r=0.1,b=0.2,l=0), "cm"))
  
  print(p)
}

## Function for visualising histogram of deltas.

vis_deltas <- function (df, delta_col, metric_col) {
  
  # Turning df into long form to perform computations
  df_long <- df %>%
  pivot_longer(cols = c(delta_wrlg, delta_clusters),
               names_to = "metric",
               values_to = "delta")
  
  # Convert delta from difftime to numeric (in seconds)
  df_long$delta <- as.numeric(df_long$delta, units = "secs")  
  
  # Calculate x-axis limits to center around 0
  max_abs_delta <- max(abs(df_long[[delta_col]]), na.rm = TRUE)
  
  # Set the breaks to the -max_abs_delta, 0, and max_abs_delta
  x_breaks <- c(-max_abs_delta, 0, max_abs_delta)
  
  # Create histogram
  b <- ggplot(df_long, aes(x = (.data[[delta_col]]), fill = (.data[[metric_col]]))) +
  geom_histogram(position = "identity", alpha = 0.5, bins = 50) +
  labs(x = "Delta (HH:MM)", y = "Frequency") +
  scale_fill_manual(
    name = "Metric",
    values = c("#0072B2", "#D55E00"),
    labels = c("Algorithm dataset", "Wear log dataset")
  ) +
  scale_x_continuous(
    limits = c(-max_abs_delta, max_abs_delta),
    labels = function(x) format_time(x), # Apply custom HH:MM format
    breaks = x_breaks,
    guide = guide_axis(check.overlap = TRUE),
    oob= scales::oob_keep) +  # Add this to keep values at the axis limits
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5), 
        aspect.ratio = 1,
        plot.margin = unit(c(t=0,r=0.1,b=0.2,l=0), "cm")) +
    ggpubr::rremove("legend")
  
  return(b)
}

