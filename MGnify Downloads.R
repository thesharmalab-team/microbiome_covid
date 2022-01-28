# install all packages at once

#install.packages( c( "httr", "jsonlite", "xml2", "BiocManager", "devtools" ) );
#BiocManager::install("biomformat")
#BiocManager::install("phyloseq")
#load packages 
#require("httr");
#require("jsonlite");
#require("xml2");
## get associated runs
#https://www.ebi.ac.uk/metagenomics/analyses/MGYA00185663#download

#Beady Allen made a code to download taxonomic data from MGnify
#devtools::install_github("beadyallen/MGnifyR")


UK <- "MGYS00002587"
Japan <- "MGYS00002355"
Phil <- "MGYS00003487" #Philippines, but that's long to write
Taiwan <- "MGYS00002173"
USA <- "MGYS00002360"
Italy <- "MGYS00002186"
China <- "MGYS00002277" #need to subset healthy controls
Austria <- "MGYS00002273"
Switz <- "MGYS00002359"
Brazil <- "MGYS00002224" #need to subset healthy controls

#Extra US data
#US_CA <- "MGYS00002675"
#US_DC <- "MGYS00002267"

run_ID <- list("MGYS00002587", "MGYS00002267", "MGYS00002355", "MGYS00003487","MGYS00002173", "MGYS00002360","MGYS00002186", "MGYS00002277", "MGYS00002273", "MGYS00002675", "MGYS00002359", "MGYS00002224")

#Set up the MGnify client instance
mgclnt <- mgnify_client(usecache = T, cache_dir = '/tmp/MGnify_cache')

get_data <- function(country){
  accession_list <- mgnify_analyses_from_studies(mgclnt, country, usecache = T)
  #Download all associated study/sample and analysis metadata
  meta_dataframe <- mgnify_get_analyses_metadata(mgclnt, accession_list, usecache = T )
  #Convert analyses outputs to a single `phyloseq` object
  psobj <- mgnify_get_analyses_phyloseq(mgclnt, meta_dataframe$analysis_accession, usecache = T)
  return(psobj)
}

Taiwan_psobj <- get_data(Taiwan)
Japan_psobj <- get_data(Japan)

sample_data(Taiwan_psobj)$country <- "Taiwan"
sample_data(Japan_psobj)$country <- "Japan"

sample_data(Taiwan_psobj)$PD_prevalence <- "high"
sample_data(Japan_psobj)$PD_prevalence <- "low"

global_psobj <- merge_phyloseq(Taiwan_psobj, Japan_psobj)
save(global_psobj, file = "global_psobj.RData")

#Arizona_psobj <- subset_samples(USA_psobj, sample_latitude == "35.2014")
#China_healthy <- subset_samples(China_psobj, sample_sample-desc == "Healthy control")

#Brazil_healthy <- prune_samples(healthy_list, Brazil_psobj)
#healthy_list <- list(2,5,6,11,14,23,35,37,38,40,48,50,53,54,64,66,77,81,86,92,93)

#sample_data(USA_psobj)$country <- "United States"

#USA_test <- subset_samples(USA_psobj)

#get_complete_dataset <- function(countries){
#  for (n in countries){
#    data <- get_data(n)
#    merge_phyloseq(n)
#  }
#  return complete_dataset
#}


#test3 <- sapply(run_IDs, get_gmrepro) 





#Retrieve Interpro assignment counts for these analyses
#ip_df <- mgnify_get_analyses_results(mgclnt, meta_dataframe$analysis_accession, retrievelist = c("interpro-identifiers"), usecache = T)
