color_bg <- "white"
  #"#F2F3F6"

theme_MLSS <- function(){
  
  theme(text = element_text(family = "Noto Sans"),
        #legend
        legend.position = 'top',
        legend.background = element_rect(fill = color_bg),
<<<<<<< HEAD
        legend.title = element_blank(),
=======
        #legend.title = element_blank(),
>>>>>>> a744f8fdd4c80e6cda7d0b34ac1792b0d300d27c
        #background
        panel.background = element_rect(fill = color_bg),
        plot.background = element_rect(fill = color_bg),
        #grids
        panel.grid = element_blank(),
        panel.grid.major.y = element_line(linetype = "dotted", colour = "black"),
        #axis
        axis.ticks = element_blank(),
        axis.title.y = element_text(margin = margin(r=20)),
        axis.title.x = element_text(margin = margin(t=20)),
        #strip
        strip.text = element_text(hjust = 0, color = 'white'),
        strip.background = element_rect(fill = "black")
        
        )
}


