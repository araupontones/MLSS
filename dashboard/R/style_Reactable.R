
reactable_bar <- function(database, label_mean){
  
  #if binary
  reactable(
    database,
    bordered = T,
    defaultPageSize = nrow(database),
    columns = list(
      mean = colDef(
        cell = data_bars(database,
                         background = "lightgrey",
                         fill_color = color_yes,
                         number_fmt = scales::number_format(accuracy = 0.01),
                         text_position = "inside-end"),
        name =paste(label_mean, "(mean)")
        
      ),
      n = colDef(
        cell = data_bars(database,
                         background = "lightgrey",
                         fill_color = "black",
                         text_color = "white",
                         number_fmt = scales::number,
                         text_position = "inside-end"),
        name = "N"
        
      )
      
    )
  )
  
  
}

#table for binary bars --------------------------------------------------------
reactable_bar_binary <- function(database, label_mean){
  
  #if binary
  reactable(
    database,
    bordered = T,
    defaultPageSize = nrow(database),
    columns = list(
      mean = colDef(
        cell = data_bars(database,
                         background = "lightgrey",
                         fill_color = color_yes,
                         number_fmt = scales::percent,
                         text_position = "inside-end"),
        name =paste(label_mean, "(mean)")
        
      ),
      n = colDef(
        cell = data_bars(database,
                         background = "lightgrey",
                         fill_color = "black",
                         text_color = "white",
                         number_fmt = scales::number,
                         text_position = "inside-end"),
        name = "N"
        
      )
      
    )
  )
  
  
}

#inputs$compare_var_label()
#inputs$var_label()
reactable_compare <- function(database, label_fill, label_mean, level){
  
    reactable(
      database,
      bordered = T,
      defaultPageSize = nrow(database),
      columns = list(
        mean = colDef(
          cell = data_bars(database,
                           background = "lightgrey",
                           fill_color_ref =  "color",
                           number_fmt = scales::number_format(accuracy = 0.01),
                           text_position = "inside-end"),
          name = paste(label_mean, "(mean)")

        ),
        n = colDef(
          cell = data_bars(database,
                           background = "lightgrey",
                           number_fmt = scales::number,
                           fill_color = "black",
                           text_color = "white",
                           text_position = "inside-end"),
          name = "N"

        ),
        fill = colDef(

          name = paste(level,label_fill)
        ),
        color = colDef(
          show = F
        )
      )
    )
  
  
  
}


# } else{
#   #if it is not binary
#   reactable(
#     data_user(),
#     bordered = T,
#     defaultPageSize = nrow(data_user()),
#     columns = list(
#       mean = colDef(
#         cell = data_bars(data_user(),
#                          background = "lightgrey",
#                          fill_color = alpha(color_yes,.9),
#                          number_fmt = scales::number_format(accuracy = 0.01),
#                          text_position = "inside-end")
#         
#       ),
#       n = colDef(
#         cell = data_bars(data_user(),
#                          background = "lightgrey",
#                          number_fmt = scales::number,
#                          fill_color = "black",
#                          text_color = "white",
#                          text_position = "inside-end")
#         
#       )
#     )
#   )
#   
# }



# 
# if(inputs$compare_by_chars() & !inputs$binary_indicator()){
#   
#   reactable(
#     data_user(),
#     bordered = T,
#     defaultPageSize = nrow(data_user()),
#     columns = list(
#       mean = colDef(
#         cell = data_bars(data_user(),
#                          background = "lightgrey",
#                          fill_color_ref =  "color",
#                          number_fmt = scales::number_format(accuracy = 0.01),
#                          text_position = "inside-end"),
#         name = paste(inputs$var_label(), "(mean)")
#         
#       ),
#       n = colDef(
#         cell = data_bars(data_user(),
#                          background = "lightgrey",
#                          number_fmt = scales::number,
#                          fill_color = "black",
#                          text_color = "white",
#                          text_position = "inside-end")
#         
#       ),
#       fill = colDef(
#         
#         name = inputs$compare_var_label()
#       ),
#       color = colDef(
#         show = F
#       )
#     )
#   )
#   
#   
# }

# if(inputs$plot_type() != "Bar Plot"){
#   
#   reactable(
#     data_user() %>%
#       relocate(division_nam, district_nam, round, targetvar)
#     
#   )
# }
#   




# if(inputs$plot_type() == "Box Plot"){
#   

# } else {
#   
#   reactable(data_user())
# }
# 
