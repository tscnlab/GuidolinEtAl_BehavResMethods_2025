## Overview
This repository contains data, analysis code, and figure outputs for the paper **"Collecting, detecting and handling non-wear intervals in longitudinal light exposure data"**. The pre-print of this paper can be found [here](https://www.biorxiv.org/content/10.1101/2024.12.23.627604v1). The R code in this repository is pubicly accessible under the [MIT](https://opensource.org/license/mit) license. The data is accessible under the [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) license.  

## Computing environment
Hereby is a copy of the software versions used for this project. This is the direct output of `sessionInfo()` in RStudio. 

```
R version 4.4.2 (2024-10-31 ucrt)
Platform: x86_64-w64-mingw32/x64
Running under: Windows 11 x64 (build 22631)

Matrix products: default


locale:
[1] LC_COLLATE=English_United States.utf8  LC_CTYPE=English_United States.utf8    LC_MONETARY=English_United States.utf8
[4] LC_NUMERIC=C                           LC_TIME=en_US.UTF-8                   

time zone: Europe/Berlin
tzcode source: internal

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] ggpubr_0.6.0    LightLogR_0.3.8 scales_1.3.0    here_1.0.1      hms_1.1.3       forcats_1.0.0   stringr_1.5.1   dplyr_1.1.4    
 [9] purrr_1.0.2     readr_2.1.5     tidyr_1.3.1     tibble_3.2.1    ggplot2_3.5.1   tidyverse_2.0.0 lubridate_1.9.3

loaded via a namespace (and not attached):
 [1] gtable_0.3.5         xfun_0.47            rstatix_0.7.2        lattice_0.22-6       tzdb_0.4.0           vctrs_0.6.5         
 [7] tools_4.4.2          generics_0.1.3       parallel_4.4.2       fansi_1.0.6          pkgconfig_2.0.3      ggnewscale_0.5.0    
[13] distributional_0.5.0 lifecycle_1.0.4      compiler_4.4.2       farver_2.1.2         munsell_0.5.1        carData_3.0-5       
[19] htmltools_0.5.8.1    yaml_2.3.10          pillar_1.9.0         car_3.1-2            crayon_1.5.3         abind_1.4-8         
[25] commonmark_1.9.1     tidyselect_1.2.1     digest_0.6.37        stringi_1.8.4        labeling_0.4.3       cowplot_1.1.3       
[31] rprojroot_2.0.4      fastmap_1.2.0        grid_4.4.2           colorspace_2.1-1     cli_3.6.3            magrittr_2.0.3      
[37] patchwork_1.3.0      utf8_1.2.4           broom_1.0.6          withr_3.0.1          backports_1.5.0      bit64_4.5.2         
[43] timechange_0.3.0     rmarkdown_2.28       bit_4.5.0            ggtext_0.1.2         ggsignif_0.6.4       zoo_1.8-12          
[49] evaluate_1.0.0       knitr_1.48           ggdist_3.3.2         markdown_1.13        rlang_1.1.4          gridtext_0.1.5      
[55] Rcpp_1.0.13          glue_1.7.0           xml2_1.3.6           rstudioapi_0.16.0    vroom_1.6.5          R6_2.5.1     
```
## Folder descriptions
In this paragraph, we explain the contents of each folder in this repository, including R script processing. Note that processing the data in sequential order, i.e., following the order of the folders, is necessary to replicate our results. 

### Raw data
Folder: `00_raw_data`, contains subfolders:
- `actlumus`: 26 txt files representing the timeseries output of the ActLumus light logger
- `wearlog`: 26 CSV files representing the Wear log questionnaires as downloaded by REDCap

### Data import
Folder: `01_import`, contains scripts:
- `import_LL.Rmd`: script for importing actlumus files
- `import_wearlog.Rmd`: script for importing Wear log files
- `import_bag.Rmd`: script for importing information on use of the black bag

### Data pre-processing
Folder: `02_datapreparation`, contains scripts:
- `wearlog_qualitychecks.Rmd`: script for pre-processing Wear log files, with detailed explanation of how files who failed quality checks were manually adjusted
- `wearlog_LL_fusion.Rmd`: script for merging the light logger dataset with information from the Wear log and bag use in a single data frame.

The output of running these two scripts in sequential order is a single, clean dataframe containing all information.

### Data analysis
Folder: `03_analysis`. All scripts in this folder assume that scripts in `01_import` and `02_datapreparation` have been previously run. 
This folder contains the subfolder `functions`, where all custom-made functions needed for the analysis are contained. Each function is called within individual R scripts using the `source()` function from base R.
This folder also contains all scripts used to produce results and figures presented in the paper. In order of analysis in the paper, these are:
1. `visual_insp.Rmd`: visual inspection of non-wear sources in the same plot for each participant. Contains code to generate Figure 4 of the paper.
2. `wrlg_plots.Rmd`: visualisation and descriptive statistics of the wear status based on self-reported Wear log entries (ground truth). This includes Figure 5 (A-C).
3. `button_press.Rmd`: preparation, visualisation and descriptive statistics for calculating the presence of a button press at the start and end of each non-wear interval. This script also outputs Figure 6 (A-B).
4. `algorithm_prc.Rmd`: implementation of the cluster detection algorithm for both low illuminance and low activity. This script outputs Figure 7 (A-B) and Figure 8.
5. `classification_summary.Rmd`: examination of algorithm misclassification, including visualisation of each algorithm classification as a time series against ground truth for each participant. One of these was then used to generate Figure 9. Furthermore, this script includes an analysis of algorithm performance which serves to generate Table 1. Lastly, this script contains the code to add a padding to the identified transition states.
6. `metrics_comparison.Rmd`: calculation of light exposure metrics across three datasets and visualisation of each metric. Outputs Figure 10.
7. `metrics_stats.Rmd`: 

