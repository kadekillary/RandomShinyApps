#####
# 
# This app.R will read data from a googlesheet
# and render the dataframe in the mainPanel. The
# user can switch the sheets by selecting another
# one from the selector input in the sidebarPanel.
#
#####

library(googlesheets)
library(tidyverse)
library(shinythemes)
library(DT)


# initialize UI
ui  <- fluidPage(
  # select shiny theme
  theme = shinytheme('simplex'),

  # set title
  titlePanel('[Your Title]'),

  sidebarLayout(

    sidebarPanel(
      # selector for worksheet name
      selectInput('ws', 'Worksheet', choices = c('DailyCosts', 'MonthlyOverview', 'DailySEMData', 'SEMDataOverview'))),

    mainPanel(
      # datatable to render
      DT::dataTableOutput('contents')  
    )
  )
)


# initialize server
server  <- function(input, output) {

  # authorize access to googlesheets
  gs_auth()

  # grab googlesheets object via URL
  gs_data  <- gs_url('https://docs.google.com/spreadsheets/d/187bilrHYjG4wEd-07GXZ4Z6YJkILQfaEJbGfZno3PDo/edit?usp=sharing')

  # grab user selected worksheet
  worksheet  <- reactive({
    input$ws
  })

  # render datatable
  output$contents  <- DT::renderDataTable({

    # read data from googlesheets
    data  <- gs_read(gs_data, ws = worksheet())

    # render datatable object + settings
    DT::datatable(data,
      # defining table style
      class = 'strive hover compact order-column',
      extensions = 'Buttons',
      options = list(
        dom = 'Bfrip',
        # buttons for Buttons extension
        buttons = c('excel', 'pdf', 'print'),
        pageLength = 50),
      filter = 'top')
  })
}


shinyApp(ui, server)
