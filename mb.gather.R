# I do not think this is required anymore
mb.gather <- function (x) {
  # Creates an empty data frame
  mb.group <- data.frame("Location" = c("Central Europe","Eastern Europe","Scandinavia", "Southern Europe","UKIE","USA"), "Mean" = c(1:6)) 
  # groups the countries to match the microbiome classification 
  c.europe <<- filter(x,Location=="Belgium"|Location=="Denmark"|Location=="Germany"|Location=="The Netherlands")
  e.europe <- filter(x,Location=="Poland")
  scan <- filter(x,Location=="Finland"|Location=="Norway"|Location=="Sweden")
  s.europe <- filter(x,Location=="France"|Location=="Italy"|Location=="Serbia"|Location=="Spain")
  ukie <- filter(x,Location=="United Kingdom"|Location=="Ireland")
  usa <- filter(x,Location=="United States")
  # gmeans the data and put it into the data frame
  
  mb.group[1,2] <- round(mean(c.europe$Value),digits = 2)
  mb.group[2,2] <- round(mean(e.europe$Value),digits = 2)
  mb.group[3,2] <- round(mean(scan$Value),digits = 2)
  mb.group[4,2] <- round(mean(s.europe$Value),digits = 2)
  mb.group[5,2] <- round(mean(ukie$Value),digits = 2)
  mb.group[6,2] <- round(mean(usa$Value),digits = 2)
  
  mb.group[1,3] <- paste(round(mean(c.europe$Upper.bound),digits = 2), round(mean(c.europe$Lower.bound),digits = 2), sep = "-",collapse = "-")
  mb.group[2,3] <- paste(round(mean(e.europe$Upper.bound),digits = 2), round(mean(e.europe$Lower.bound),digits = 2), sep = "-",collapse = "-")
  mb.group[3,3] <- paste(round(mean(scan$Upper.bound),digits = 2), round(mean(scan$Lower.bound),digits = 2), sep = "-",collapse = "-")
  mb.group[4,3] <- paste(round(mean(s.europe$Upper.bound),digits = 2), round(mean(s.europe$Lower.bound),digits = 2), sep = "-",collapse = "-")
  mb.group[5,3] <- paste(round(mean(ukie$Upper.bound),digits = 2), round(mean(ukie$Lower.bound),digits = 2), sep = "-",collapse = "-")
  mb.group[6,3] <- paste(round(mean(usa$Upper.bound),digits = 2), round(mean(usa$Lower.bound),digits = 2), sep = "-",collapse = "-")
  # mb.group[2,3] <- paste(e.europe$Upper.bound,"-", e.europe$Lower.bound)
  # mb.group[3,3] <- paste(scan$Upper.bound,"-", scan$Lower.bound)
  # mb.group[4,3] <- paste(s.europe$Upper.bound,"-",s.europe$Lower.bound)
  # mb.group[5,3] <- paste(ukie$Upper.bound,"-", ukie$Lower.bound )
  # mb.group[6,3] <- paste(usa$Upper.bound,"-", usa$Lower.bound)
  return(mb.group)
}