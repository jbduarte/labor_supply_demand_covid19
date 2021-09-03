theme_publication <- function(base_size=14) {
  library(grid)
  library(ggthemes)
  (theme_classic(base_size=base_size, base_family ='serif')
    + theme(plot.title = element_text(face = "bold",
                                      size = rel(1.2), hjust = 0.5),
            )
  )
  
}