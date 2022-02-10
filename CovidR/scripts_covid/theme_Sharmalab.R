theme_Sharmalab <- function () { 
  theme_bw(base_size=18, base_family="Avenir") %+replace% 
    theme(
      panel.background  = element_blank(),
      plot.background = element_blank(),
      legend.background = element_rect(fill="transparent", colour=NA),
      legend.key = element_rect(fill="transparent", colour=NA),
      panel.grid.major = element_blank(), 
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      axis.line = element_line(colour = "black",size = 1.2),
      axis.title = element_text(face = "bold"),
      axis.title.x = element_text( size=12, face="bold"),
      axis.title.y = element_text( size=12, face="bold",angle = 90, vjust = 1.3)
    )
}

#https://drsimonj.svbtle.com/creating-corporate-colour-palettes-for-ggplot2

# create your own color palette based on `seedcolors`
P25 = createPalette(25,  c("#d11141", "#00b159", "#00aedb"))



SharmaLab_colors <- c(
  `red`        = "#d11141",
  `green`      = "#00b159",
  `blue`       = "#00aedb",
  `orange`     = "#f37735",
  `yellow`     = "#ffc425",
  `light grey` = "#cccccc",
  `dark grey`  = "#8c8c8c", 
   P25) # This adds the 25 colours .View with swatch(P25) and labelled NC1, 


# use Sharmalab_cols("red")
SharmaLab_cols <- function(...) {
  cols <- c(...)
  
  if (is.null(cols))
    return (SharmaLab_colors)
  
  SharmaLab_colors[cols]
}


# install.packages("Polychrome")




# use drsimonj_cols("red")
SharmaLab_palettes <- list(
  `main`  = SharmaLab_cols("red", "green", "blue"),
  
  `two_group_atlas`  = SharmaLab_cols("blue", "orange"),
  
  `two_group_curat`  = SharmaLab_cols("yellow", "red"),
  
  `hot`   = SharmaLab_cols("yellow", "orange", "red"),
  
  `mixed` = SharmaLab_cols("blue", "green", "yellow", "orange", "red"),
  
  `grey`  = SharmaLab_cols("light grey", "dark grey"),
  
  `curat`  = SharmaLab_cols("NC1", "NC2","NC3","NC4", "NC5","NC6","NC7", "NC8","NC9","NC10", "NC11","NC12","NC13", "NC14","NC15","NC16", "NC17","NC18"),
  
  `atlas`  = SharmaLab_cols( "NC20","NC21","NC22", "NC23","NC24","NC25" )
)

   
# Use Sharmalab_pal("cool")
Sharmalab_pal <- function(palette = "main", reverse = FALSE, ...) {
  pal <- SharmaLab_palettes[[palette]]
  
  if (reverse) pal <- rev(pal)
  
  colorRampPalette(pal, ...)
}

scale_color_Sharmalab <- function(palette = "main", discrete = TRUE, reverse = FALSE, ...) {
  pal <- Sharmalab_pal(palette = palette, reverse = reverse)
  
  if (discrete) {
    discrete_scale("colour", paste0("Sharmalab_", palette), palette = pal, ...)
  } else {
    scale_color_gradientn(colours = pal(256), ...)
  }
}


scale_fill_Sharmalab <- function(palette = "main", discrete = TRUE, reverse = FALSE, ...) {
  pal <- Sharmalab_pal(palette = palette, reverse = reverse)
  
  if (discrete) {
    discrete_scale("fill", paste0("Sharmalab_", palette), palette = pal, ...)
  } else {
    scale_fill_gradientn(colours = pal(256), ...)
  }
}


