library(shiny)
library(ggplot2)
library(dplyr)

out_click<- NULL
out_hover<-NULL

shinyServer(function(input, output) {
    
    puntos <- reactive({
        if(!is.null(input$click_grafico$x)){
            df<-nearPoints(mtcars,
                           input$click_grafico,
                           xvar='wt',
                           yvar='mpg')
            out <- df %>% 
                select(wt,mpg)
            out_click <<- rbind(out_click,out) %>% 
                distinct()
            return(out)
        }
        if(!is.null(input$hover_grafico$x)){
            df<-nearPoints(mtcars,
                           input$hover_grafico,
                           xvar='wt',
                           yvar='mpg')
            out <- df %>% 
                select(wt,mpg)
            out_hover <<- out
            return(out_hover)
        }
        
        if(!is.null(input$dobleclick_grafico$x)){
            df<-nearPoints(mtcars,
                           input$dobleclick_grafico,
                           xvar='wt',
                           yvar='mpg')
            out <- df %>% 
                select(wt,mpg)
            out_click <<- setdiff(out_click,out)
            return(out_hover)
        }
        
        if(!is.null(input$brush_grafico)){
            df<-brushedPoints(mtcars,
                              input$brush_grafico,
                              xvar='wt',
                              yvar='mpg')
            out <- df %>% 
                select(wt,mpg)
            out_click <<- rbind(out_click,out) %>% 
                dplyr::distinct()
            return(out_hover)
        }
    })
    
    
    mtcars_plot <- reactive({
        plot(mtcars$wt,
             mtcars$mpg,
             xlab="Peso (1000 libras)",
             ylab="Millas por Galon")
        puntos <-puntos()
        if(!is.null(out_hover)){
            points(out_hover[,1],out_hover[,2],
                   col='gray',
                   pch=15,
                   cex=2)}
        if(!is.null(out_click)){
            points(out_click[,1],out_click[,2],
                   col='green',
                   pch=19,
                   cex=2)}
    })
    
    output$grafico <- renderPlot({
        mtcars_plot()
    })
    
    
    click_table <- reactive({
        input$click_grafico$x
        input$dobleclick_grafico$x
        input$brush_grafico
        out_click
    })
    
    output$dataTable_mtcars <- DT::renderDataTable({
        click_table() %>% 
            DT::datatable(options= list(pageLength=5,
                                                      lengthMenu=c(5,10,15)
                                                    ),
                                        selection = "single",
                                        colnames = c('indice',
                                                     'peso',
                                                     'millas por galon'),
                                        filter = 'none'
                                        )
    })
    
})