pseq_prep_1 <- function(atlas.pseq,curat.pseq,mypseq) {
 
  # This script loads and then generates the dataframe required later on. 
  # It uses the classification from the main script. 
  # The output is; curat.combined.agestd & atlas.curat.combined.agestd
  # curat.pseq & atlas.pseq that contains curat2atlas.mnd.class,curat.mnd.class &  atlas.mnd.class
  
  # INPUTs
  # curat.pseq
  # atlas.pseq
  
  # OUTPUTS
  
  # atlas.pseq
  # atlas.curat.combined.agestd
  #"curat.pseq
  #"curat.combined.agestd
  # curat.combined
  
  
  # Cleaning up the Taxa
  message("Cleaning up the taxa")
  taxa_names(curat.pseq) <- str_remove(taxa_names(curat.pseq), "s__")
  taxa_names(curat.pseq) <- str_replace(taxa_names(curat.pseq), "_", " ")
  taxa_names(atlas.pseq) <- str_remove(taxa_names(atlas.pseq), " et rel.")
  taxa_names(atlas.pseq) <- str_remove(taxa_names(atlas.pseq), " at rel.")
  
  
  # CURATED DATA SET
  message("Working on the Curat data ")
  # grabs the nationality from phyloseq
  curat.mnd.class <- get_variable(curat.pseq, "country" )
  curat.mnd.class <- fct_collapse(curat.mnd.class, LOW = curat.low , HIGH = curat.high)
  # reorder
  curat.mnd.class <- factor(curat.mnd.class, levels = (c("LOW", "HIGH")))
  # creates a CURATE MND CLASS in the phyloseq 
  sample_data(curat.pseq)$curat.mnd.class = curat.mnd.class
  message("Writing the countries into the Curat data")
  
  # grouping curated into atlas
  curat2atlas <- get_variable(curat.pseq, "country" )
  curat2atlas <- fct_collapse(curat2atlas, Scandinavia = curat2atlas.scand ,CentralEurope = curat2atlas.ce, SouthEurope = curat2atlas.se, US = curat2atlas.us, UKIE = curat2atlas.uk)
  # this line postively selects these factors while preserving the length
  curat2atlas <- factor(curat2atlas, levels = (c("SouthEurope", "CentralEurope","Scandinavia","US","UKIE")))
  
  # dropping the other countries
  country <- get_variable(curat.pseq, "country" )
  country <- droplevels(factor(country), curat.drop) 
  sample_data(curat.pseq)$country = country
  
  # add the atlas classification to curated
  sample_data(curat.pseq)$curat2atlas = curat2atlas
  
  # this created the atlas classification for the curated
  curat2atlas.mnd.class <- fct_collapse(curat2atlas, LOW = atlas.low, HIGH = atlas.low )
  #  classification based on atlas grouping
  curat2atlas.mnd.class <- factor(curat2atlas.mnd.class, levels = c("LOW", "HIGH"))
  sample_data(curat.pseq)$curat2atlas.mnd.class = curat2atlas.mnd.class
  
  message("Working on the Atlas Data")
  # convert it to align with the same name as the other data set
  country <- get_variable(atlas.pseq, "nationality" )
  sample_data(atlas.pseq)$country = country
  
  # doing the same for the ATLAS group
  atlas.mnd.class <- get_variable(atlas.pseq, "nationality" )
  atlas.mnd.class <- fct_collapse(atlas.mnd.class, LOW = atlas.low, HIGH = atlas.high )
  atlas.mnd.class <- factor(atlas.mnd.class, levels = c("LOW", "HIGH"))
  sample_data(atlas.pseq)$atlas.mnd.class = atlas.mnd.class
  message("Writing the countries into the Atlas data")
  # expected output
  #atlas.mnd.class 
  
  #curat.mnd.class
  # curat2atlas
  
  # table(get_variable(atlas.pseq, "atlas.mnd.class"))
  # table(get_variable(curat.pseq, "curat2atlas.mnd.class"))
  # table(get_variable(curat.pseq, "curat.mnd.class"))
  # table(get_variable(curat.pseq, "curat2atlas"))
  # table(get_variable(curat.pseq, "country"))
  # table(get_variable(atlas.pseq, "country"))
  # 
  # 
  
  
mypseq[["atlas.recode.country.pseq"]] <- atlas.pseq
mypseq[["curat.recode.country.pseq"]] <- curat.pseq

message("Returning a list called mypseq \n that contains: \n atlas.recode.country.pseq \n curat.recode.country.pseq ")

return(mypseq)
}