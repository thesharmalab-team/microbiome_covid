# N Sharma 10/9/20
# This script loads and then generates the dataframe required later on. 

# loads the Burden of Disease data and relabels straight away. 

pd.daly <- as.data.frame(read_csv(data_daly, col_names = TRUE))%>%
  rename_all( tolower)  %>%
  dplyr::rename("DALY"="val") %>%
  dplyr::select(location, DALY, year,age)

pd.prev <- as.data.frame(read_csv(data_prev,col_names = TRUE)) %>%
  rename_all( tolower)  %>%
  dplyr::rename("Prevalence"="val") %>%
  dplyr::select(location, Prevalence, year,age)

pd.inc <- as.data.frame(read_csv(data_incid,col_names = TRUE)) %>%
  rename_all( tolower)  %>%
  dplyr::rename("Incidence"="val") %>%
  dplyr::select(location, Incidence, year,age)

# Join them altogether 
pd.gbd <- left_join(pd.daly, pd.prev) %>%
  left_join(.,mnd.inc ) %>%
  dplyr::select(location, Incidence,DALY,Prevalence, year, age)

pd.gbd$age <- as.factor(pd.gbd$age )

pd.gbd$iso3c.location <- countrycode(pd.gbd$location, origin ='country.name', destination ="iso3c" )

# Countries in the Oral MGnify dataset
oral_country.list <- c("Japan", "Taiwan")

############### CODE IS USEFUL FOR CHECKING WHICH COUNTRIES ARE INCLUDED
# table(curatcountry)
# temp <- as.data.frame(curatcountry)
# library(countrycode)
# temp$iso3c.location <- countrycode(temp$curatcountry , origin = 'iso3c', destination = "country.name")
# table(temp$iso3c.location)
###############

# this line postively selects these factors while preserving the length
oral_country <- factor(oral_country, levels = oral_country.list )
sample_data(oral.pseq)$oral_country = oral_country

# GLOBAL BURDEN OF DISEASE DATA
# creates subset of data inclduing the DALYS for the all  countries 
pd.gbd.sub <-  subset(pd.gbd, location %in% oral_country.list)