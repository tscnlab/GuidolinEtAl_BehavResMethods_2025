## Overview
This repository contains data, analysis code, and figure outputs for the paper **"Collecting, detecting and handling non-wear intervals in longitudinal light exposure data"**. The pre-print of this paper can be found [here](https://www.biorxiv.org/content/10.1101/2024.12.23.627604v1). The R code in this repository is pubicly accessible under the [MIT](https://opensource.org/license/mit) license (see `LICENSE.md` file). The data is accessible under the [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) license.  

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
In this paragraph we explain the contents of each folder in this repository, including R script processing. Note that processing of the data in sequential order, i.e. following the order of the folders, is necessary for replication of our results. 

### Raw data
Folder: `00_raw_data`, contains subfolders:
- `actlumus`: 26 txt files representing the timeseries output of the ActLumus light logger
- `wearlog`: 26 csv files representing the Wear log questionnaires as downloaded by REDCap

### Data import
Folder: `01_import`, contains subfolders:
- `import_LL.Rmd`: script for importing actlumus files
- `import_wearlog.Rmd`: script for importing Wear log files
- `import_bag.Rmd`: script for importing information on use of the black bag

### Data pre-processing
Folder: `02_datapreparation` 

- Participants N = 26
- Duration: 7 full days (Monday to Monday)
- Wearable device: ActLumus with 10 seconds sampling period, worn centrally on non-prescription spectacles ("light glasses")

Non-wear time information is given by three sources:  
1. Wear log completed by the participant with following information: 
  - Timestamp of taking the light glasses off (current/retrospective) 
  - Timestamp of placing the light glasses back on (current/retrospective) 
  - Timestamp of taking the light glasses off before bed (current/retrospective) 
  - Use of black bag during non-wear episode (current/retrospective) 

2. Button presses done by the participant (logged by ActLumus); 

3. Light while in black bag (mEDI ≤1 lux during non-wear time) 
  - Note: this is partly related to the Wear log, as information on whether the black bag was used or not is contained in the Wear log 

Each of these three sources can be used individually to detect a non-wear period. However, the Wear log entries were monitored twice a day by the experimenter, and thus considered as the “ground truth” for non-wear detection. 

## Research question
The ovearching RQ is: What is the concordance between different sources of non-wear?
