plotServer <-  function(id, inputs, database ) {
  moduleServer(id, function(input, output, session) {
    
    my_plot <- eventReactive(inputs$go(), {
      
      
      #bar plots =============================================================
      if(inputs$plot_type() == "Bar Plot"){
        
        #if compare across time for Malawi of Province level
        if(inputs$by_other_var() & inputs$x_var_plot()$across_time){
          
          
          plot <- plot_compare_outcomes_time(database = database(),
                                             name_fill = inputs$compare_var_label(),
                                             y_label =  inputs$var_label(),
                                             level = id,
                                             plot_type = inputs$plot_type()
          )
          
          #if user selects to compare by other variable but between districts
        } else if(inputs$by_other_var() & !inputs$x_var_plot()$across_time){
          
          
          plot <- plot_compare_outcomes(database = database(),
                                        x = inputs$display(),
                                        name_fill = inputs$compare_var(),
                                        y_label =  inputs$var_label(),
                                        x_label = inputs$x_var_plot()$x_lab
          ) +
            guides(fill = guide_legend(title = 
                                         paste(str_to_title(id),inputs$compare_var_label()),
                                       title.position = "top",
                                       title.hjust = 0.5
            )
            )
          
          #if doesnt want to compare
        } else{
          
          plot <- plot_bar(database = database(),
                           x = inputs$display(),
                           y_label =  inputs$var_label(),
                           x_label  = inputs$x_var_plot()$x_lab,
                           across_time = inputs$x_var_plot()$across_time
          ) +
            theme(legend.title = element_blank())
        }
        
        
        
      }
      
      
      
      #Line plots =============================================================
      
      
      if(inputs$plot_type() == "Line Plot"){
        
        #if compare across time for Malawi of Province level
        if(inputs$by_other_var() & inputs$x_var_plot()$across_time){
          
          
          plot <- plot_compare_outcomes_time(database = database(),
                                             name_fill = inputs$compare_var_label(),
                                             y_label =  inputs$var_label(),
                                             level = id,
                                             plot_type = inputs$plot_type()
          )
          
          #if user selects to compare by other variable but between districts
        } else if(inputs$by_other_var() & !inputs$x_var_plot()$across_time){
          
          
          plot <- plot_line_compare(database = database(),
                            display = inputs$display(),
                            level = id,
                            legend = inputs$compare_var_label(),
                            y_label =  inputs$var_label()
                            )
                           
          
      
        } else{
          
          plot <- plot_line(database(),
                            display = inputs$display(),
                            y_label = inputs$var_label())
          
          
        }
        
        
        
      }
      
      
      
      
      #Box plots =============================================================
      
      if(inputs$plot_type() == "Box Plot"){
        
        
        plot<-plot_box(database= database(),
                       by_time = inputs$x_var_plot()$across_time,
                       x = inputs$display(),
                       y_label = inputs$var_label(),
                       x_label =inputs$x_var_plot()$x_lab,
                       across_time = inputs$x_var_plot()$across_time
        )
        
        
      }
      
      if(inputs$plot_type() == "Density Plot"){
        
        plot <- plot_density(database = database(),
                             by_time = inputs$x_var_plot()$across_time,
                             x_label = inputs$var_label(),
                             wrap_var = inputs$display(),
                             rounds = inputs$round())
        
        
      }
      
      
      if(inputs$binary_indicator() | inputs$percentage_indicator()){
        
        plot <- plot +
          scale_y_continuous(limits= c(0:1),
                             labels = function(x)c(seq(0,75,25), paste0(100,"%"))
          )
      }      
      
      plot <- plot +
        theme_MLSS()
      
      
      plot
      
      
      
    })
    
    
    output$plot <- renderPlot({
      
      req(my_plot(), cancelOutput = T)
      my_plot()
      
      
    })
    
    
  })
}