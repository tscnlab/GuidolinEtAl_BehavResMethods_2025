# Function for testing normality 

## Testing normality on the means
norm_check_means <- function (df) {
  
  df_qq <- df %>%
    mutate(mean_raw = as.numeric(mean_raw),
           mean_wrlg = as.numeric(mean_wrlg),
           mean_clusters = as.numeric(mean_clusters))
  
  p1 <- ggpubr::ggqqplot(df_qq$mean_raw) +
    theme(aspect.ratio = 1)
  p2 <- ggpubr::ggqqplot(df_qq$mean_wrlg) +
    theme(aspect.ratio = 1)
  p3 <- ggpubr::ggqqplot(df_qq$mean_clusters) +
    theme(aspect.ratio = 1)
  
  ptot <- ggpubr::ggarrange(p1,p2,p3,
                    nrow = 1) 
  annotated_plot <- ggpubr::annotate_figure(ptot, top = text_grob(paste0("Normality check means: ", deparse(substitute(df)), " - raw, wrlg, clusters")))
  
  return(annotated_plot)
  
}

## Testing normality on the deltas
norm_check_deltas <- function (df) {
  
  df_qq <- df %>%
    mutate(delta_wrlg = as.numeric(delta_wrlg),
           delta_clusters = as.numeric(delta_clusters))
  
  p1 <- ggpubr::ggqqplot(df_qq$delta_wrlg) +
    theme(aspect.ratio = 1)
  p2 <- ggpubr::ggqqplot(df_qq$delta_clusters) +
    theme(aspect.ratio = 1)
  
  ptot <- ggpubr::ggarrange(p1,p2,
                            nrow = 1) 
  annotated_plot <- ggpubr::annotate_figure(ptot, top = text_grob(paste0("Normality check deltas: ", deparse(substitute(df)), " - delta_wrlg, delta_clusters")))
  
  return(annotated_plot)
  
}
