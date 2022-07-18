perma_d_two <- function(mypseq) { # x & y must be either p.low,p.med or p.high
  
  temp.curat <- mypseq[["curat.recode.country.comp.core.pseq" ]] 
  
  # Curat data 
  
  p.low <- subset_samples(temp.curat, curat.covid.class == "LOW")
  #p.low.d <- divergence(p.low)
  p.high <- subset_samples(temp.curat, curat.covid.class == "HIGH")
  #p.high.d <- divergence(p.high)
  #p <<- boxplot(list(Low = p.low.d, High = p.high.d))
  
  # Convert to compositional data perma_d(p.low,p.high,"final_highVlow")
  pseqLvH <- subset_samples(temp.curat, curat.covid.class == c("LOW","HIGH"))
  pseq.rel <- microbiome::transform(pseqLvH, "compositional")
  otu <- abundances(pseq.rel)
  meta <- microbiome::meta(pseq.rel)
  

  
  permanova <- adonis(t(otu) ~ curat.covid.class,  data = meta, permutations=999, method = "bray")
  # P-value
  print(as.data.frame(permanova$aov.tab)["curat.covid.class", "Pr(>F)"])  
  dist <- vegdist(t(otu))
  anov <- anova(betadisper(dist, meta$curat.covid.class))
  summary(anov)
  tidy(anov)
  coef <- coefficients(permanova)["curat.covid.class1",]
  top.coef <- coef[rev(order(abs(coef)))[1:20]]
  par(mar = c(12, 30, 2, 1))
  #KEEP THIS  TO ENSURE THERE IS NOT A MISTAKE IN THE REORDERING BELOW
  #temp <- TeX("Top Genus")
  #png(paste("PERMOVA_",title_text,".png", sep = "" ), width = 450, height = 210,  units     = "mm",
  #res       = 1500)
  #barplot(sort(top.coef), col = rainbow(20), horiz = T, las = 1, main = temp)
  #dev.off() 
  temp <- as.data.frame(top.coef)
  temp$label <- rownames(temp) 
  temp$label <- sub("_*", "", temp[,2])
  #Add this so the label is in Italics, requires library(ggtext) & library(mdthemes)
  temp$label <- paste("*",temp$label, "*", sep="")

  permanova.curat <- temp
  
  temp <- NULL
  
  mypermanova <- list( 
                 "permanova.curat" = permanova.curat)

  return(mypermanova)
} 
