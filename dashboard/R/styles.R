color_bg <- "white"
color_strip <- "#3E0B08" #same color as color of text header
color_yes <- "#002244"
color_no <- "#009FDA"
color_line <- "#F0A85C" #same color as bg of form
color_spinner <- "#3E0B08"

# from https://theloop.worldbank.org/colors

#blue pallete
colors_rounds <- c("#053657",'#004370','#00538A',
                   '#0071bc', '#A3DAFF', '#CDE7F9')

#colorfull palete
colors_rounds_rainbow <-c("#00538A",'#296B4D','#AC016D',
                 '#B12911', '#01707E', '#DF9C02') 

theme_MLSS <- function(){
  
  theme(text = element_text(family = "Noto Sans"),
        #legend
        legend.position = 'top',
        legend.background = element_rect(fill = color_bg),
        legend.key = element_rect(fill = NA),
        #legend.title = element_blank(),
        #background
        panel.background = element_rect(fill = color_bg),
        plot.background = element_rect(fill = color_bg),
        #grids
        panel.grid = element_blank(),
        panel.grid.major.y = element_line(linetype = "dotted", colour = "black"),
        #axis
        axis.ticks = element_blank(),
        axis.title.y = element_text(margin = margin(r=20), size = 14),
        axis.title.x = element_text(margin = margin(t=20), size = 14),
        axis.text = element_text(size = 14),
        #strip
        strip.text = element_text(hjust = 0, color = 'white', size = 12, vjust = 1),
        strip.background = element_rect(fill = color_strip)
        
        )
}


