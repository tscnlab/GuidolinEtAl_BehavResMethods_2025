<img src="https://github.com/tscnlab/Templates/blob/main/logo/logo_with_text-01.png" width="400"/>

## Overview
This repository contains data, analysis code, and figure outputs for the paper **"Collecting, detecting and handling non-wear intervals in longitudinal light exposure data"**. The pre-print of this paper can be found [here](https://www.biorxiv.org/content/10.1101/2024.12.23.627604v1). The R code in this repository is publicly accessible under the [MIT](https://opensource.org/license/mit) license (see `LICENSE.md` file). The data is accessible under the [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) license.  

## Computing environment
Hereby is a copy of the software versions used for this project. This is the direct output of `sessionInfo()` in RStudio. 

```
R version 4.4.2 (2024-10-31 ucrt)
Platform: x86_64-w64-mingw32/x64
Running under: Windows 10 x64 (build 19045)

Matrix products: default


locale:
[1] LC_COLLATE=German_Germany.utf8  LC_CTYPE=German_Germany.utf8    LC_MONETARY=German_Germany.utf8 LC_NUMERIC=C                   
[5] LC_TIME=German_Germany.utf8    

time zone: Europe/Berlin
tzcode source: internal

attached base packages:
[1] stats     graphics  grDevices datasets  utils     methods   base     

other attached packages:
 [1] chromote_0.4.0  gt_0.11.1       janitor_2.2.1   cowplot_1.1.3   patchwork_1.3.0 ggdist_3.3.2    knitr_1.49      ggpubr_0.6.0   
 [9] LightLogR_0.3.8 scales_1.3.0    here_1.0.1      hms_1.1.3       lubridate_1.9.4 forcats_1.0.0   stringr_1.5.1   dplyr_1.1.4    
[17] purrr_1.0.2     readr_2.1.5     tidyr_1.3.1     tibble_3.2.1    ggplot2_3.5.1   tidyverse_2.0.0

loaded via a namespace (and not attached):
 [1] gridExtra_2.3        rlang_1.1.5          magrittr_2.0.3       snakecase_0.11.1     compiler_4.4.2       systemfonts_1.2.1   
 [7] vctrs_0.6.5          pkgconfig_2.0.3      crayon_1.5.3         fastmap_1.2.0        backports_1.5.0      labeling_0.4.3      
[13] promises_1.3.2       rmarkdown_2.29       markdown_1.13        tzdb_0.4.0           ps_1.8.1             ragg_1.3.3          
[19] bit_4.5.0.1          xfun_0.50            jsonlite_1.8.9       later_1.4.1          broom_1.0.7          parallel_4.4.2      
[25] R6_2.5.1             stringi_1.8.4        car_3.1-3            Rcpp_1.0.14          zoo_1.8-12           httpuv_1.6.15       
[31] timechange_0.3.0     tidyselect_1.2.1     rstudioapi_0.17.1    abind_1.4-8          yaml_2.3.10          ggtext_0.1.2        
[37] miniUI_0.1.1.1       websocket_1.4.2      processx_3.8.5       lattice_0.22-6       shiny_1.10.0         withr_3.0.2         
[43] evaluate_1.0.3       xml2_1.3.6           pillar_1.10.1        carData_3.0-5        renv_1.0.11          distributional_0.5.0
[49] generics_0.1.3       vroom_1.6.5          rprojroot_2.0.4      munsell_0.5.1        commonmark_1.9.2     xtable_1.8-4        
[55] glue_1.8.0           tools_4.4.2          webshot2_0.1.1       ggnewscale_0.5.0     data.table_1.16.4    ggsignif_0.6.4      
[61] fs_1.6.5             grid_4.4.2           colorspace_2.1-1     Formula_1.2-5        cli_3.6.3            textshaping_1.0.0   
[67] gtable_0.3.6         ggsci_3.2.0          rstatix_0.7.2        sass_0.4.9           digest_0.6.37        farver_2.1.2        
[73] htmltools_0.5.8.1    lifecycle_1.0.4      mime_0.12            gridtext_0.1.5       ggExtra_0.10.1       bit64_4.6.0-1        
```
## Folder descriptions
In this paragraph, we explain the contents of each folder in this repository, including R script processing. Note that scripts depend on data and folders in the same directory structure as provided in this repository. Hence, processing the data in sequential order, and using the same folder structure, is necessary to replicate these results. 

### Raw data
Folder: `00_raw_data`, contains subfolders:
- `actlumus`: 26 txt files representing the time series output of the ActLumus light logger
- `wearlog`: 26 CSV files representing the Wear log questionnaires as downloaded by REDCap

### Data import
Folder: `01_import`, contains scripts:
- `initialise_env.Rmd`: script that downloads all necessary package versions to ensure computational reproducibility
- `master_script_import.Rmd`: master script that runs `import_LL.Rmd`(importing actlumus files), `import_wearlog.Rmd` (importing Wear log files), and `import_bag.Rmd`(importing information on use of the black bag) in sequential order, and stores their outputs in the global environment

### Data pre-processing
Folder: `02_datapreparation`, contains scripts:
- `wearlog_qualitychecks.Rmd`: script for pre-processing Wear log files, including quality checks, with detailed explanation of how files that failed quality checks were manually adjusted
- `wearlog_LL_fusion.Rmd`: script for merging the light logger dataset with information from the Wear log and bag use in a single data frame.

The output of running these two scripts in sequential order is a single, clean data frame containing all information.

### Data analysis
Folder: `03_analysis`. All scripts in this folder assume that scripts in `01_import` and `02_datapreparation` have been previously run. 
Note that various scripts in the `03_analysis` folder require a chrome or chromium browser installed on the system, as this is required to use `gt_save()` to save a table.  After a fresh install of the browser, restarting the system is suggested. The browser is used in a headless mode by the {webshot2} package through the {chromote} package, and without chrome the scripts `classification_summary.Rmd` and `metric_stats.Rmd` will stop with an error. 

This folder comprises the subfolder `functions`, containing all custom-made functions needed for the analysis. Each function is called within individual R scripts using the `source()` function from base R.
This folder also contains all scripts used to produce results and figures presented in the paper. In order of analysis in the paper, these are:
1. `visual_insp.Rmd`: visual inspection of non-wear sources in the same plot for each participant. Contains code to generate Figure 4 of the paper.
2. `wrlg_plots.Rmd`: visualisation and descriptive statistics of the wear status based on self-reported Wear log entries (ground truth). This includes Figure 5 (A-C).
3. `button_press.Rmd`: preparation, visualisation and descriptive statistics for calculating the presence of a button press at the start and end of each non-wear interval. This script also outputs Figure 6 (A-B).
4. `algorithm_prc.Rmd`: implementation of the cluster detection algorithm for low illuminance and for low activity. This script outputs Figure 7 (A-B) and Figure 8.
5. `classification_summary.Rmd`: examination of algorithm misclassification, including visualisation of each algorithm classification as a time series against ground truth for each participant. One of these (PID 201) was then used to generate Figure 9, which was finalised using symbols in PowerPoint. Furthermore, this script includes an algorithm performance analysis that generates Table 1. Lastly, this script contains the code to add a pad to the identified transition states.
6. `metrics_comparison.Rmd`: calculation of light exposure metrics across three datasets and visualisation of each metric. Outputs Figure 10.
7. `metrics_stats.Rmd`: statistical analysis of differences in light exposure metrics across datasets. Outputs Table S1 and Table S2 (Supplementary materials).

The following scripts, also contained in the folder `03_analysis`, contain code related to the Supplementary materials:
1. `trblshoot_prc_medi.Rmd`: fine-tuning input parameters to be fed into the algorithm for detection of clusters of low illuminance. Outputs Figure S2.
2. `trblshoot_prc_pim.Rmd`: fine-tuning input parameters to be fed into the algorithm for detection of clusters of low activity. Outputs Figure S3.
3. `pim_preprocessing.Rmd`: comparison of precision recall curves for different activity-quantifying parameters (PIM, TAT and ZCM) and various options for pre-processing PIM values. Outputs Figure S4 and Figure S5.
