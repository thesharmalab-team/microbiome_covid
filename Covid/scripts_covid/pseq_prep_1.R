pseq_prep_1 <- function(curat.pseq,mypseq) {
 
  # This script loads and then generates the dataframe required later on. 
  # It uses the classification from the main script. 
  # The output is; curat.combined
  # curat.pseq that contains curat.covid.class 
  
  # INPUTs
  # curat.pseq
  
  # OUTPUTS
  # curat.pseq
  # curat.combined
  
  
  # Cleaning up the Taxa
  message("Cleaning up the taxa")
  taxa_names(curat.pseq) <- str_remove(taxa_names(curat.pseq), "s__")
  taxa_names(curat.pseq) <- str_replace(taxa_names(curat.pseq), "_", " ")
  
  
  # CURATED DATA SET
  message("Working on the Curat data ")
  # grabs the nationality from phyloseq
  curat.covid.class <- get_variable(curat.pseq, "country" )
  curat.covid.class <- fct_collapse(curat.covid.class, LOW = curat.low , HIGH = curat.high)
  # reorder
  curat.covid.class <- factor(curat.covid.class, levels = (c("LOW", "HIGH")))
  # creates a CURATE COVID CLASS in the phyloseq 
  sample_data(curat.pseq)$curat.covid.class = curat.covid.class
  message("Writing the countries into the Curat data")
  
  # dropping the other countries
  country <- get_variable(curat.pseq, "country" )
  country <- droplevels(factor(country), curat.drop) 
  sample_data(curat.pseq)$country = country
  
  # expected output
  #curat.covid.class
  
  # table(get_variable(curat.pseq, "curat.covid.class"))
  # table(get_variable(curat.pseq, "country"))
  # 
  # 
  
  
mypseq[["curat.recode.country.pseq"]] <- curat.pseq

message("Returning a list called mypseq \n that contains: \n curat.recode.country.pseq ")

return(mypseq)
}