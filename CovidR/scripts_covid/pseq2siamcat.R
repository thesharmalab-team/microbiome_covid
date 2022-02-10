pseq2siamcat <- function(atlas.pseq) {

atlas.pseq.c <- core(atlas.pseq, detection = 0.1/100, prevalence = 50/100)
atlas.pseq.c <- microbiome::transform(atlas.pseq.c, "compositional")

feat=otu_table(atlas.pseq.c)
meta=sample_data(atlas.pseq.c)
#Create siamcat object:
label <- create.label(meta=sample_data(atlas.pseq.c),
                      label = "mnd",
                      case = c("HIGH"), control = "LOW")

siamcat <- siamcat(phyloseq=atlas.pseq.c, label=label)

phyloseq <- physeq(siamcat)
otu_tab <- otu_table(phyloseq)
return(siamcat)
}