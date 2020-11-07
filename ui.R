library(shiny)


shinyUI(fluidPage(
    
    
    titlePanel("Tarea Shiny Plots - 20003022"),
    
    tabsetPanel(
        tabPanel('Desglose de la tarea',
                 plotOutput('grafico',
                            click = 'click_grafico',
                            dblclick = 'dobleclick_grafico',
                            hover = 'hover_grafico',
                            brush = 'brush_grafico'
                 ),
                 DT::dataTableOutput('dataTable_mtcars')
        )
    )
    
))