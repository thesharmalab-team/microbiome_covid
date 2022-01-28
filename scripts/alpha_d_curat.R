alpha_d_curat <- function(curat.pseq) {
  # gets the meta data 
  curat.meta <- microbiome::meta(curat.pseq)
  # generates the diversites
  tab <- microbiome::alpha(curat.pseq, index = "shannon")
  # creates Shannon
  curat.meta$Shannon <- tab$diversity_shannon
  curat.mnd.class <- levels(curat.meta$curat.mnd.class) # get the variables
  # Make a pairwise list that we want to compare.
  mnd.pairs <- combn(seq_along(curat.mnd.class), 2, simplify = FALSE, FUN = function(i)curat.mnd.class[i])
  mnd.pairs <<- list( c("HIGH","LOW"))
  # Compare differences in Shannon index between mnd group of the study subjects
  curat.meta$curat.mnd.class <- factor(curat.meta$curat.mnd.class, levels = c("LOW","HIGH"),  exclude = "NA")

  return(curat.meta)
}

