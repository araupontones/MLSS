plotServer <-  function(id, inputs, database ) {
  moduleServer(id, function(input, output, session) {
    
    my_plot <- eventReactive(inputs$go(), {
      
      
      #bar plots =============================================================
      if(inputs$plot_type() == "Bar Plot"){
        
        
        #if user selects to compare by other variable
        if(inputs$by_other_var()){
          
          
          plot <- plot_compare_outcomes(database = database(),
                                        x = inputs$x_var_plot()$x,
                                        name_fill = inputs$compare_var(),
                                        y_label =  inputs$var_label(),
                                        x_label = inputs$x_var_plot()$x_lab
          )
          
        } else{
          
          plot <- plot_bar(database = database(),
                           x = inputs$x_var_plot()$x,
                           y_label =  inputs$var_label(),
                           x_label  = inputs$x_var_plot()$x_lab
          ) 
        }
        
        
        
      }
      
      #Box plots =============================================================
      
      if(inputs$plot_type() == "Box Plot"){
        
        
        plot<-plot_box(database= database(),
                       by_time = inputs$x_var_plot()$across_time,
                       x = inputs$x_var_plot()$x,
                       y_label = inputs$var_label(),
                       x_label =inputs$x_var_plot()$x_lab
        )
        
        
      }
      
      if(inputs$plot_type() == "Density Plot"){
        
        plot <- plot_density(database = database(),
                             by_time = inputs$x_var_plot()$across_time,
                             x_label = inputs$var_label(),
                             wrap_var = inputs$x_var_plot()$x,
                             rounds = inputs$round())
        
        
      }
      
      
      if(inputs$binary_indicator()){
        
        plot <- plot +
          scale_y_continuous(limits= c(0:1),
                             labels = function(x)c(seq(0,75,25), paste0(100,"%"))
          )
      }      
      
      plot +
        theme_MLSS()
      
      
      
      
      
    })
    
    
    output$plot <- renderPlot({
      
      req(my_plot, cancelOutput = T)
      my_plot()
      
      
    })
    
    
  })
}