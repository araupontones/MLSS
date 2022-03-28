#geom line



# one indicator over time (no comparing) ======================================  
plot_line <- function(database = database(),
                      display = inputs$display(),
                      y_label = inputs$var_label()
                      ){
  
    if(display == "round"){
    
    plot <- ggplot(database,
           aes(x = round,
               y = mean,
               group = 1))+
      geom_line(size = 1,
                color = "gray")+
      geom_point(
        aes(fill = round,
            color = round),
        show.legend = F,
        shape = 21,
        size = 4
      ) 
      
  } else{
    
    
    data_plot <- database %>%
      rename(wrap_var = display)
    
    plot <- ggplot(data_plot,
           aes(x = round,
               y = mean,
               group = 1))+
      geom_line(size = 1,
                color = "gray")+
      geom_point(
        aes(fill = round,
            color = round),
        show.legend = F,
        shape = 21,
        size = 4
      ) +
      facet_wrap(~ wrap_var)
    
    
  }
  
  plot <- plot + 
    scale_fill_manual(values =  colors_rounds) +
    scale_color_manual(values =  colors_rounds) +
    labs(y = y_label,
         x = "")
  
  
}


# Compare indicator by characteristics at the provine and district level

plot_line_compare <- function(database = database(),
                              display = inputs$display(),
                              level = id,
                              legend = inputs$compare_var_label(),
                              y_label =  inputs$var_label()){
  
  data_plot <- database %>%
    rename(wrap_var = display)
  
  
  
  plot <- ggplot(data_plot,
                 aes(x = round,
                     y = mean,
                     fill = fill)) +
    geom_line(aes(group = fill,
                  color = fill),
              show.legend = F)+
    geom_point(size = 4,
               shape = 21) +
    scale_fill_manual(name = paste(str_to_title(level),legend),
                      breaks = c("Yes", "No"),
                      values = c(alpha(color_yes, .9), alpha(color_no, .7))
    )+
    scale_color_manual(values = c(color_yes, color_no)) +
    facet_wrap(~ wrap_var) +
    labs(y = y_label,
        x = "")
  
  
  
  
}
