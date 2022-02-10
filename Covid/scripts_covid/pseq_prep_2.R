pseq_prep_2 <- function(atlas.pseq,curat.pseq,mypseq) {

  
  atlascountry <- as.data.frame(table(get_variable(mypseq[["atlas.recode.country.pseq"]], "country")))
  curat2atlas <- as.data.frame(table(get_variable( mypseq[["curat.recode.country.pseq"]], "curat2atlas")))
  curatcountry <- as.data.frame(table(get_variable( mypseq[["curat.recode.country.pseq"]], "curatcountry")))

  
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
  
  mydata <- list("atlas.curat.combined.agestd" = atlas.curat.combined.agestd, 
                 "curat.combined.agestd" = curat.combined.agestd,
                 "curat.combined" = curat.combined)
  return(mydata)

}