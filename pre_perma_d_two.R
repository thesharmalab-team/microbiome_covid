pre_perma_d_two <- function(curat.pseq) { 
  p.low <<- subset_samples(curat.pseq, curat.mnd.class == "LOW")
  p.low.d <<- divergence(p.low)
  p.high <<- subset_samples(curat.pseq, curat.mnd.class == "HIGH")
  p.high.d <<- divergence(p.high)
  p <<- boxplot(list(Low = p.low.d, High = p.high.d))
  return(p)
}