library(shiny)
library(stringr)
library(glue)

#to allow larger files from users
options(shiny.maxRequestSize = 10 * 1024^2)

#Useful vectors
rounds <- c("Baseline", "Midline", "Endline")
levels <- c("school", "teacher", "student")

ui <- fluidPage(
  
  #UI to import data
  selectInput("round", label = "Round of the data",choices = rounds),
  fileInput("upload", label = "Import zip file", accept = c(".zip")),
  actionButton("sendData", label = "Validate"),
  
  
  tableOutput("head")
)

server <- function(input, output, session) {
  data <- reactive({
    req(input$upload)
    
    #here I have to check that data for this round does not exist
    #check that file exists
    ext <- tools::file_ext(input$upload$name)
    zipdir <- input$upload$datapath
    #here, I have to check that the zip file contains 3 files
    
    switch(ext,
           zip = unzip_import(zipDir = zipdir, round = "Baseline", importDir = "data/imports"),
           #tsv = vroom::vroom(input$upload$datapath, delim = "\t"),
           validate("Invalid file; Please upload a .zip file")
    )
  })
  
  output$head <- renderTable({
    input$upload
  })
}

shinyApp(ui, server)