# N Sharma 10/9/20
# This script loads and then generates the dataframe required later on. 

# loads the Burden of Disease data and relabels straight away. 

mnd.daly <- as.data.frame(read_csv(data_daly, col_names = TRUE))%>%
  rename_all( tolower)  %>%
  dplyr::rename("DALY"="val") %>%
  dplyr::select(location, DALY, year,age)

mnd.prev <- as.data.frame(read_csv(data_prev,col_names = TRUE)) %>%
  rename_all( tolower)  %>%
  dplyr::rename("Prevalence"="val") %>%
  dplyr::select(location, Prevalence, year,age)
  
mnd.inc <- as.data.frame(read_csv(data_incid,col_names = TRUE)) %>%
  rename_all( tolower)  %>%
  dplyr::rename("Incidence"="val") %>%
  dplyr::select(location, Incidence, year,age)

# Join them altogether 
mnd.gbd <- left_join(mnd.daly, mnd.prev) %>%
  left_join(.,mnd.inc ) %>%
  dplyr::select(location, Incidence,DALY,Prevalence, year, age)

mnd.gbd$age <- as.factor(mnd.gbd$age )

mnd.gbd$iso3c.location <- countrycode(mnd.gbd$location, origin ='country.name', destination ="iso3c" )

# defines each group and converts into full names for later one
curat2atlas.scand <- c("NOR","SWE","FIN")
curat2atlas.ce <- c("DNK","DEU","NLD","AUT","LUX") # note that we've added Lux and Aut which arent present in the Atlas data
curat2atlas.se <- c("ITA","ESP","FRA")
curat2atlas.us <- c("USA")
curat2atlas.uk <- c("GBR")

atlas.scand <- c("Norway","Sweden","Finland")
atlas.ce <- c("Denmark","Netherlands","Germany", "Belgium","Luxembourg","Austria") # note that we've added Lux and Aut which arent present in the Atlas data
atlas.se <- c("Italy","Spain","France", "Serbia")
atlas.us <- c("United States")
atlas.uk <- c("United Kingdom", "Ireland")

# Countries in the Curated dataset
curatcountry.list <- c("NOR","SWE","FIN","DNK","DEU","NLD","ITA","ESP","FRA","USA","GBR","AUT","LUX")

# We include all the countries that appear in either dataset for the overall table. Curated doesnt have "Serbia", "Belgium", "Ireland"
included.country <- c("Netherlands", "Denmark", "Germany", "Finland", "France", "Italy", "Norway", "Spain", "Sweden", "United Kingdom", "United States","Serbia", "Belgium", "Ireland","Austria","Luxembourg")

######################### covert to country codes
curat2atlas.scand.iso3c <- countrycode(curat2atlas.scand, origin = "iso3c" , destination ='country.name')
curat2atlas.ce.iso3c <- countrycode(curat2atlas.ce, origin = "iso3c" , destination ='country.name')
curat2atlas.se.iso3c <- countrycode(curat2atlas.se, origin = "iso3c" , destination ='country.name')
curat2atlas.us.iso3c <- countrycode(curat2atlas.us, origin = "iso3c" , destination ='country.name')
curat2atlas.uk.iso3c <- countrycode(curat2atlas.uk, origin = "iso3c" , destination ='country.name')

# selecting only curated countries
curatcountry <- get_variable(curat.pseq, "country" )

############### CODE IS USEFUL FOR CHECKING WHICH COUNTRIES ARE INCLUDED
# table(curatcountry)
# temp <- as.data.frame(curatcountry)
# library(countrycode)
# temp$iso3c.location <- countrycode(temp$curatcountry , origin = 'iso3c', destination = "country.name")
# table(temp$iso3c.location)
###############

# this line postively selects these factors while preserving the length
curatcountry <- factor(curatcountry, levels = curatcountry.list )
sample_data(curat.pseq)$curatcountry = curatcountry

# GLOBAL BURDEN OF DISEASE DATA
# creates subset of data inclduing the DALYS for the all  countries 
mnd.gbd.sub <-  subset(mnd.gbd, location %in% included.country)
# gets location, collapses them and then turn into a factor.
mnd.gbd.sub$Region <- mnd.gbd.sub$location %>%
  fct_collapse(Scandinavia = atlas.scand ,CentralEurope = atlas.ce, SouthEurope = atlas.se, US = atlas.us, UKIE = atlas.uk) %>%
  factor(levels = (c('Scandinavia', 'CentralEurope',"SouthEurope" , "US", "UKIE")))