alpha_d_curat <- function(curat.pseq) {
  # gets the meta data 
  curat.meta <- microbiome::meta(curat.pseq)
  # generates the diversites
  tab <- microbiome::alpha(curat.pseq, index = "shannon")
  # creates Shannon
  curat.meta$Shannon <- tab$diversity_shannon
  curat.covid.class <- levels(curat.meta$curat.covid.class) # get the variables
  # Make a pairwise list that we want to compare.
  covid.pairs <- combn(seq_along(curat.covid.class), 2, simplify = FALSE, FUN = function(i)curat.covid.class[i])
  covid.pairs <<- list( c("HIGH","LOW"))
  # Compare differences in Shannon index between mnd group of the study subjects
  curat.meta$curat.covid.class <- factor(curat.meta$curat.covid.class, levels = c("LOW","HIGH"),  exclude = "NA")

  return(curat.meta)
}

