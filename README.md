# Data and code for the research paper "Population-level gut microbiome variations and their impact on COVID-19 severity", published in Frontiers in Cellular and Infection Microbiology.

To read the paper, please use this link: https://www.frontiersin.org/articles/10.3389/fcimb.2022.963338/full

If you want to reference the paper or any of the code used herein, please cite as:
Lymberopoulos E, Gentili GI, Budhdeo S and Sharma N (2022) COVID-19 severity is associated with population-level gut microbiome variations. _Front. Cell. Infect. Microbiol._ 12:963338. doi: 10.3389/fcimb.2022.963338

# Contents

The folder CovidR contains all the information required for the R analysis. This is grouped in subfolders: data, output and scripts_covid.

 - CovidR/data contains the two sets of data utilised for this study, Microbiome data and Covid Hospitalisation data.

  - CovidR/output contains the figures generated when running the analysis in R.

 - CovidR/scripts_covid contains the functions utilised in the Covid_microbiome.Rmd script. Each function has a separate R file and they are all grouped together to facilitate their usage in the my_scripts.R file. 

-  Covid_microbiome.Rmd is the final version of the full code utilised for the standard microbiome analysis of this study, including loading the data and functions.


The folder CovidTDA contains all the information required for the TDA analysis. This is grouped into subfolders: data and scripts, and output.
 - CovidTDA/data and scripts contains all input data, both raw and filtered, as well as the scripts used for filtering and wrangling.

 - fullTDA_cleared is the final version of the full code utilised for the TDA analysis pipeline, included in this folder.

-  CovidTDA/output contains the figures generated from the fullTDA_cleared code.
