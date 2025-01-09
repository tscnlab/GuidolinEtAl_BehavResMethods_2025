## Overview
This repository contains data, analysis code, and figure outputs for the paper **Collecting, detecting and handling non-wear intervals in longitudinal light exposure data**. The pre-print of this paper can be found [here](https://www.biorxiv.org/content/10.1101/2024.12.23.627604v1). The R code in this repository is pubicly accessible under the [MIT](https://opensource.org/license/mit) license (see `LICENSE.md` file). The data is accessible under the [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) license.  

## Dataset description
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
