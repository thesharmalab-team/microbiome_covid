# not sure this is requred Aug 2020
mb.cgather <- function (x) {
  # Creates an empty data frame
  mb.group <- data.frame("Location" = c("Norway","Sweden","Finland","Denmark","Luxembourg", "Italy","Austria","Germany","Spain","France","Netherlands","United Kingdom","United States","Canada"), "Mean" = c(1:14)) 
  # groups the countries to match the microbiome classification 
  mb.group <- filter(x,Location=="Norway"|Location=="Sweden"|Location=="Finland"|Location=="Denmark"|Location=="Luxembourg"|Location=="Italy"|Location=="Austria"|Location=="Germany"|Location=="Spain"|Location=="France"|Location=="Netherlands"|Location=="United Kingdom"|Location=="United States"|Location=="Canada")
  
  return(mb.group)
}