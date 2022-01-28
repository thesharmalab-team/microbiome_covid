# N Sharma 10/9/20
# downloads and saves the curate dataset 
if(!file.exists("data/curat.pseq.RData")){
  eh = ExperimentHub()
  myquery = query(eh, "curatedMetagenomicData")
  # Get the stool samples
  esl <- curatedMetagenomicData("*metaphlan_bugs_list.stool*", dryrun = FALSE)
  # merge
  eset <- mergeData(esl)
  # the relab=FALSE is essential as it Absolute Raw Count Data
  curat.pseq = ExpressionSet2phyloseq(eset,relab=FALSE ,simplify = TRUE, phylogenetictree = TRUE)
  save(curat.pseq, file = "data/curat.pseq.RData")
}

load("data/curat.pseq.RData")
