# Function for testing normality 

norm_check <- function (df) {
  
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
  annotated_plot <- ggpubr::annotate_figure(ptot, top = text_grob(paste0("Normality check: ", deparse(substitute(df)), " - raw, wrlg, clusters")))
  
  return(annotated_plot)
  
}
