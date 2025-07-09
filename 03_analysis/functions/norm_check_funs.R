# Function for testing normality of data 

## Testing normality on the metrics
library(dplyr)
library(ggpubr)
library(ggplot2)

norm_check_means <- function(df, df_name = NULL) {
  
  if (is.null(df_name)) {
    df_name <- "DataFrame"
  }
  
  df <- df %>%
    select(-any_of(c("delta_wrlg", "delta_clusters", "sd_raw", "sd_wrlg", "sd_clusters")))
  
  raw_col <- grep("_raw$", names(df), value = TRUE)
  wrlg_col <- grep("_wrlg$", names(df), value = TRUE)
  clusters_col <- grep("_clusters$", names(df), value = TRUE)
  
  if(length(raw_col) != 1 || length(wrlg_col) != 1 || length(clusters_col) != 1) {
    stop("Dataframe must have exactly one column each matching '_raw', '_wrlg', and '_clusters'")
  }
  
  df_renamed <- df %>%
    rename(
      col_raw = all_of(raw_col),
      col_wrlg = all_of(wrlg_col),
      col_clusters = all_of(clusters_col)
    ) %>%
    mutate(
      col_raw = as.numeric(col_raw),
      col_wrlg = as.numeric(col_wrlg),
      col_clusters = as.numeric(col_clusters)
    )
  
  p1 <- ggpubr::ggqqplot(df_renamed$col_raw) + theme(aspect.ratio = 1)
  p2 <- ggpubr::ggqqplot(df_renamed$col_wrlg) + theme(aspect.ratio = 1)
  p3 <- ggpubr::ggqqplot(df_renamed$col_clusters) + theme(aspect.ratio = 1)
  
  ptot <- ggpubr::ggarrange(p1, p2, p3, nrow = 1)
  annotated_plot <- ggpubr::annotate_figure(ptot, top = ggpubr::text_grob(
    paste0("Normality check: ", df_name, " - raw, wrlg, clusters")
  ))
  
  shapiro_raw <- shapiro.test(df_renamed$col_raw)
  shapiro_wrlg <- shapiro.test(df_renamed$col_wrlg)
  shapiro_clusters <- shapiro.test(df_renamed$col_clusters)
  
  cat("\n---- Shapiro-Wilk Test: ", df_name, " ----\n")
  cat("raw:      W = ", round(shapiro_raw$statistic, 4), ", p-value = ", round(shapiro_raw$p.value, 4), "\n")
  cat("wrlg:     W = ", round(shapiro_wrlg$statistic, 4), ", p-value = ", round(shapiro_wrlg$p.value, 4), "\n")
  cat("clusters: W = ", round(shapiro_clusters$statistic, 4), ", p-value = ", round(shapiro_clusters$p.value, 4), "\n")
  
  return(annotated_plot)
}
