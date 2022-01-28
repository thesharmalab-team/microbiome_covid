alpha_d_two_graph <- function(atlas.meta) {
  # on to the graphs!!! country 
  glob_theme <- "Moonrise3"
  p1 <<-ggviolin(atlas.meta, x = "country", y = "Shannon",
                  add = "boxplot", fill = "country", palette = "paired") +
    theme(axis.text.x = element_blank(),axis.ticks = element_blank()) + 
    theme(legend.position="bottom",legend.title = element_blank()) + 
    xlab("") 
  # the number in the palettes must equal the number of groups in bmi.pairs
  
  p2 <<- ggviolin(data=subset(atlas.meta, !is.na(atlas.mnd.class)), x = "atlas.mnd.class", y = "Shannon", add = "boxplot", fill = "atlas.mnd.class", na.rm = TRUE, palette = wes_palette(glob_theme)) 
  
  p2 <<- p2 + stat_compare_means(comparisons = mnd.pairs) + 
    xlab("MND Prevalence") + 
    theme(legend.position="bottom", axis.text.x = element_blank(),axis.ticks = element_blank()) +
    guides(fill=guide_legend(title="Group"))
  #this just generates the titles for the output
  
  #p3 <<-plot_grid(title,p1,p2, align = "v" , ncol = 1, labels = c('','A', 'B'),rel_heights = c(0.1, 1,1.2))
  figure <- ggarrange(p1, p2 ,ncol = 1, nrow = 2, align = "v", heights = c(2.3,2.1),  labels = c("A", "B"))
  
  output <- annotate_figure(figure,
                            left = text_grob("Alpha Diversity", face = "italic", rot = 90),
                            fig.lab = "Figure 1", fig.lab.face = "bold", fig.lab.size = 14, fig.lab.pos = "top")
  ggexport(output, filename = "figure1.png") 

  # save_plot('1Alpha_diversity.png', p4)
  return(output)
}