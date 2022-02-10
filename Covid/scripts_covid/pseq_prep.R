# N Sharma 10/9/20
# This script loads and then generates the dataframe required later on. 
# It uses the classification from the main script. 
# The output is; curat.combined.agestd 
# curat.pseq that contains curat.covid.class


# Cleaning up the Taxa
taxa_names(curat.pseq) <- str_remove(taxa_names(curat.pseq), "s__")
taxa_names(curat.pseq) <- str_replace(taxa_names(curat.pseq), "_", " ")

# CURATED DATA SET
# grabs the nationality from phyloseq
curat.covid.class <- get_variable(curat.pseq, "country" )
curat.covid.class <- fct_collapse(curat.covid.class, LOW = curat.low , HIGH = curat.high)
# reorder
curat.covid.class <- factor(curat.covid.class, levels = (c("LOW", "HIGH")))
# creates a CURATE COVID CLASS in the phyloseq 
sample_data(curat.pseq)$curat.covid.class = curat.covid.class

# expected output
#curat.covid.class 

# table(get_variable(curat.pseq, "curat.covid.class"))
# table(get_variable(curat.pseq, "country"))
# 
# 

curatcountry <- as.data.frame(table(get_variable(curat.pseq, "curatcountry")))

#############################

#this add the number of microbiome for each group
# renames the columns so that they match
curatcountry <- curatcountry %>% dplyr::rename(curat.freq = Freq, country = Var1 )
curat.freq <- curatcountry$curat.freq
covid.owid <- cbind(covid.owid, curat.freq)

#####################
curat.combined <- covid.owid

###### add the frequency to the OWID data
#curatcountry$atlas.label <- NULL
# renames them so that the column match
#mnd.gbd.sub$curat.label <- mnd.gbd.sub$iso3c.location
#curat.combined <- left_join(mnd.gbd.sub, curatcountry)

# OUTPUT ; curat.combined
