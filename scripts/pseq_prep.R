# N Sharma 10/9/20
# This script loads and then generates the dataframe required later on. 
# It uses the classification from the main script. 
# The output is; curat.combined.agestd & atlas.curat.combined.agestd
# curat.pseq & atlas.pseq that contains curat2atlas.mnd.class,curat.mnd.class &  atlas.mnd.class


# Cleaning up the Taxa
taxa_names(curat.pseq) <- str_remove(taxa_names(curat.pseq), "s__")
taxa_names(curat.pseq) <- str_replace(taxa_names(curat.pseq), "_", " ")
taxa_names(atlas.pseq) <- str_remove(taxa_names(atlas.pseq), " et rel.")
taxa_names(atlas.pseq) <- str_remove(taxa_names(atlas.pseq), " at rel.")


# CURATED DATA SET
# grabs the nationality from phyloseq
curat.mnd.class <- get_variable(curat.pseq, "country" )
curat.mnd.class <- fct_collapse(curat.mnd.class, LOW = curat.low , HIGH = curat.high)
# reorder
curat.mnd.class <- factor(curat.mnd.class, levels = (c("LOW", "HIGH")))
# creates a CURATE MND CLASS in the phyloseq 
sample_data(curat.pseq)$curat.mnd.class = curat.mnd.class

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

# convert it to align with the same name as the other data set
country <- get_variable(atlas.pseq, "nationality" )
sample_data(atlas.pseq)$country = country

# doing the same for the ATLAS group
atlas.mnd.class <- get_variable(atlas.pseq, "nationality" )
atlas.mnd.class <- fct_collapse(atlas.mnd.class, LOW = atlas.low, HIGH = atlas.high )
atlas.mnd.class <- factor(atlas.mnd.class, levels = c("LOW", "HIGH"))
sample_data(atlas.pseq)$atlas.mnd.class = atlas.mnd.class

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


atlascountry <- as.data.frame(table(get_variable(atlas.pseq, "country")))
curat2atlas <- as.data.frame(table(get_variable(curat.pseq, "curat2atlas")))
curatcountry <- as.data.frame(table(get_variable(curat.pseq, "curatcountry")))


#mnd.prev.sub$iso3c.location <- countrycode(mnd.prev.sub$location , origin = 'country.name', destination = "iso3c")

####### this labels the curated countries with the atlas labels as well. Important that it uses the ...iso3... codes  mnd.gbd.sub
#curatcountry$location <- countrycode(curatcountry$Var1 , origin = "iso3c", destination = 'country.name' )
curatcountry <- curatcountry %>% dplyr::rename(curat.label = Var1 )
curatcountry$atlas.label <- curatcountry$Freq
curatcountry$atlas.label[curatcountry$curat.label %in% curat2atlas.scand.iso3c] <- "Scandinavia"
curatcountry$atlas.label[curatcountry$curat.label %in% curat2atlas.ce.iso3c] <- "CentralEurope"
curatcountry$atlas.label[curatcountry$curat.label %in% curat2atlas.se.iso3c] <- "SouthEurope"
curatcountry$atlas.label[curatcountry$curat.label %in% curat2atlas.uk.iso3c] <- "UKIE"
curatcountry$atlas.label[curatcountry$curat.label %in% curat2atlas.us.iso3c] <- "US"
# Difficult here is Aut and LUX.
curatcountry$atlas.label[curatcountry$curat.label =="AUT"] <- "CentralEurope"
curatcountry$atlas.label[curatcountry$curat.label =="LUX"] <- "CentralEurope"
names(curatcountry)[1] <- "curat.label"
#############################

#####################
# important to subset the data else it adds all of the ages up together
a <- aggregate(DALY~Region+year, subset(mnd.gbd.sub, age == gbd.age), mean)
b <- aggregate(Incidence~Region+year, subset(mnd.gbd.sub, age == gbd.age), mean)
c <- aggregate(Prevalence~Region+year, subset(mnd.gbd.sub, age == gbd.age), mean)

mnd.gbd.gg <- left_join(a, b) %>%
  left_join(.,c ) 

#this add the number of microbiome for each group
# renames the columns so that they match
atlascountry <- atlascountry %>% dplyr::rename(atlas.freq = Freq, Region = Var1 )
mnd.gbd.gg <- left_join(mnd.gbd.gg, atlascountry)

curat2atlas <- curat2atlas %>% dplyr::rename(Region = Var1,curat.atlas.freq = Freq )
mnd.gbd.gg <- left_join(mnd.gbd.gg, curat2atlas)
#####################
atlas.curat.combined.agestd <- mnd.gbd.gg

###### add the frequency to the GBD data
curatcountry$atlas.label <- NULL
# renames them so that the column match
mnd.gbd.sub$curat.label <- mnd.gbd.sub$iso3c.location
curat.combined <- left_join(mnd.gbd.sub, curatcountry)
# adds the Atlas samples numbers 

curat.combined <- left_join(curat.combined, curat2atlas)
# only select the age std data
curat.combined.agestd <- subset(curat.combined, age==gbd.age)

# OUTPUT ; curat.combined.agestd & atlas.curat.combined.agestd
