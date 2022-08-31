# microbiome_covid
Data and code for the manuscript "Population-level gut microbiome variations and their impact on COVID-19 severity", to be submitted to Frontiers in Cellular and Infection Microbiology.

CovidR contains all the information require for the R analysis. This is grouped in subfolders: data, output and scripts_covid.

/data contains the two sets of data utilised for this study, Microbiome data and Covid Hospitalisation data.

/output contains the figures generated when running the analysis in R.

/scripts_covid contains the functions utilised in the Covid_microbiome.Rmd script. Each function has a separate R file and they are all grouped together to facilitate their usage in the my_scripts.R file. 

Covid_microbiome.Rmd is the final version of the full code utilised for the analysis of this study, including loading the data and functions.
