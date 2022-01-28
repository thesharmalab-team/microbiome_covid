
# not working. 


devtools::install_github("stefpeschel/NetCoMi", dependencies = TRUE,
                         repos = c("https://cloud.r-project.org/",
                                   BiocManager::repositories()))


devtools::install_github("vmikk/metagMisc")

library(SpiecEasi)
se.mb.amgut2 <- spiec.easi(atlas.pseq, method='mb', lambda.min.ratio=1e-2,
                           nlambda=20, pulsar.params=list(rep.num=50))
ig2.mb <- adj2igraph(getRefit(se.mb.amgut2),  vertex.attr=list(name=taxa_names(atlas.pseq)))
plot_network(ig2.mb, atlas.pseq, type='taxa', color="Phylum")


library(NetCoMi)
# Network comoparsions
amgut_split <- metagMisc::phyloseq_sep_variable(mypseq[["curat.recode.country.pseq"]], 
                                                "curat.mnd.class")

net_season <- netConstruct(amgut_split$HIGH, amgut_split$LOW, verbose = 2, 
                           filtTax = "highestVar",
                           filtTaxPar = list(highestVar = 50),
                           measure = "spieceasi",
                           measurePar = list(method = "mb", 
                                             nlambda=20, 
                                             pulsar.params=list(rep.num=20)),
                           normMethod = "none", zeroMethod = "none",
                           sparsMethod = "none", seed = 123456)

props_season <- netAnalyze(net_season, clustMethod = "cluster_fast_greedy")

plot(props_season, sameLayout = TRUE, layoutGroup = 1,
     nodeSize = "eigenvector", cexNodes = 1.5, cexLabels = 1.8,
     groupNames = c("Seasonal allergies", "No seasonal allergies"),
     hubBorderCol  = "gray40")

plot(props_season, rmSingles = "inboth", sameLayout = TRUE, layoutGroup = 1,
     nodeSize = "eigenvector", cexNodes = 1.5, cexLabels = 1.8,
     groupNames = c("Seasonal allergies", "No seasonal allergies"),
     hubBorderCol  = "gray40")

comp_season <- netCompare(props_season, permTest = TRUE, verbose = FALSE)

summary(comp_season, showCentr = c("degree", "eigen"), numbTaxa = 5)