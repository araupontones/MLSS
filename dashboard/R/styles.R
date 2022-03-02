color_bg <- "white"
color_yes <- "#002244"
color_no <- "#009FDA"
colors_rounds <- c("#053657",'#004370','#00538A',
                   '#0071bc', '#A3DAFF', '#CDE7F9') # from https://theloop.worldbank.org/colors
  #"#F2F3F6"

theme_MLSS <- function(){
  
  theme(text = element_text(family = "Noto Sans"),
        #legend
        legend.position = 'top',
        legend.background = element_rect(fill = color_bg),
        #legend.title = element_blank(),
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


