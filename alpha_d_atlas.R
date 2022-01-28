alpha_d_atlas <- function(atlas.pseq) {
  # gets the meta data 
  atlas.meta <- microbiome::meta(atlas.pseq)
  # generates the diversites
  tab <- microbiome::alpha(atlas.pseq, index = "shannon")
  # creates Shannon
  atlas.meta$Shannon <- tab$diversity_shannon
  atlas.mnd.class <- levels(atlas.meta$atlas.mnd.class) # get the variables
  # Make a pairwise list that we want to compare.
  mnd.pairs <- combn(seq_along(atlas.mnd.class), 2, simplify = FALSE, FUN = function(i)atlas.mnd.class[i])
  mnd.pairs <<- list( c("HIGH","LOW"))
  # Compare differences in Shannon index between mnd group of the study subjects
  atlas.meta$atlas.mnd.class <- factor(atlas.meta$atlas.mnd.class, levels = c("LOW","HIGH"),  exclude = "NA")

  return(atlas.meta)
}

