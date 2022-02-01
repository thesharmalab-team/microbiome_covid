mydata_prep <- function(mypseq) {

  # this accepts the list from the pseq_prep_2
  message("The pseq being used are: \n curat.recode.country.pseq ")  
  curatcountry <- as.data.frame(table(get_variable( mypseq[["curat.recode.country.pseq"]], "curatcountry")))
  
  #this add the number of microbiome for each group
  # renames the columns so that they match
  curatcountry <- curatcountry %>% dplyr::rename(curat.freq = Freq, country = Var1 )
  curat.freq <- curatcountry$curat.freq
  covid.owid.gg <- cbind(covid.owid.gg, curat.freq)
  
  covid.owid.gg <- cbind(covid.owid.gg, curat.freq)
  #####################
  curat.combined <- covid.owid.gg
  
  ###### add the frequency to the GBD data
  #curatcountry$atlas.label <- NULL
  # renames them so that the column match
  #mnd.gbd.sub$curat.label <- mnd.gbd.sub$iso3c.location
  #curat.combined <- left_join(mnd.gbd.sub, curatcountry)
 
  # OUTPUT ; curat.combined
  
  mydata <- list(
                 "curat.combined" = curat.combined)
  message("Returning mydata that contains:\n curat.combined ")
  
  return(mydata)

}