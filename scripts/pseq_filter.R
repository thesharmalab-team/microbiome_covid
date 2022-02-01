pseq_filter <- function(mypseq) {

# N Sharma 15/9/20
# This script filters the pseq 
#  
   # The output is; 
   # curat.pseq.comp.filte
   
   # Relative abundance
   curat.recode.country.comp.pseq <- microbiome::transform(mypseq[["curat.recode.country.pseq" ]], "compositional")
   
   message("Coverting the data to relative abudance")
   
   # Filtering based on filter.features for siamcat
   # siamcat <- filter.features(siamcat, cutoff=1e-04, filter.method = 'abundance', feature.type = 'original')
   
   # Filtered such that only OTUs with a mean greater than 1e-05 are kept.
   curat.recode.country.comp.filter.pseq = filter_taxa(curat.recode.country.comp.pseq , function(x) mean(x) > 1e-04, TRUE)
   
   #Relative population frequencies; at 1% compositional abundance threshold:
   #prevalence(pseq.rel, detection = 1/100, sort = TRUE)
   
   
   
   # the filtering is really important about relative and counts. Sdome are appropriate. Other are not. 
   # # Core
   # keepotu = genefilter_sample(curat.recode.country.comp.pseq, filterfun_sample(topp(0.05)), A=5)
   # pseq.f <- subset_taxa(curat.recode.country.comp.pseq, keepotu)
   # pseq.f = subset_taxa(pseq.f, !is.na(Genus))
   # plot_heatmap(pseq.f, method="PCoA", distance="bray")
   # 
   # pseq.filt = subset_taxa(curat.recode.country.comp.pseq, keepotu & !is.na(Genus))
   # plot_heatmap(pseq.filt, method="PCoA", distance="bray")
   # 
   # sum(is.na(otu_table(physeqITS_DADA)))
   # psmelt(physeqITS_DADA) %>%
   #   filter(is.na(Abundance))
   
   curat.recode.country.comp.core.pseq <- core(curat.recode.country.comp.pseq, detection = 0, prevalence = .5)
   
   # Absolute population frequencies (sample count):
   #prevalence(pseq.rel, detection = 1/100, sort = TRUE, count = TRUE)
   
   curat.recode.country.filter.pseq = filter_taxa(mypseq[["curat.recode.country.pseq"]] , function(x) mean(x) > 1e-04, TRUE)
   curat.recode.country.comp.core.filter.pseq <- core(curat.recode.country.filter.pseq, detection = 0, prevalence = .5)
   
   
   
   #mypseq[["curat.recode.country.comp.core.filter.nNA.pseq"]] <- curat.recode.country.comp.core.filter.nNA.pseq
   
   mypseq[["curat.recode.country.comp.core.filter.pseq"]] <- curat.recode.country.comp.core.filter.pseq
   mypseq[["curat.recode.country.filter.pseq"]] <- curat.recode.country.filter.pseq
   mypseq[["curat.recode.country.comp.filter.pseq"]] <- curat.recode.country.comp.filter.pseq
   mypseq[["curat.recode.country.comp.core.pseq"]] <- curat.recode.country.comp.core.pseq
   mypseq[["curat.recode.country.comp.pseq"]] <- curat.recode.country.comp.pseq
   
   
   # This removes all of the additional covariates that are not required. 
   sample_data(mypseq[["curat.recode.country.filter.pseq"]])[c(2:3,6:16, 18, 20:95 )] = NULL
   sample_data(mypseq[["curat.recode.country.comp.filter.pseq"]])[c(2:3,6:16, 18, 20:95 )] = NULL
   sample_data(mypseq[["curat.recode.country.comp.pseq"]] )[c(2:3,6:16, 18, 20:95 )] = NULL
   
   # This command lists them sample_variables(curat.pseq.comp.filter)
   return(mypseq)
}