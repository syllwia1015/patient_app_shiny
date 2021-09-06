function(input, output, session, .data) {
  
  # suppress warnings  
  storeWarn<- getOption("warn")
  options(warn = -1) 
  
  
  
  #SIDEBAR ---------------------------------------------------------------------------------------------------------------
  
  df_zestaw <- reactive ({
    times <- input$reset_input
    
    dt <- data[BMRKR2 %in% input$checkgroup1 ]
    dt <- dt[LBCAT %in% input$checkgroup2 ]
    dt <- dt[LBTESTCD %in% input$checkgroup3 ]
    
  })
  
  
  
  
  # infoBox -------------------------------------------------------------------------------------------------------------
  
  output$UI_bmrkr1 <- renderInfoBox({
    infoBox(
      "Mean BMRKR1 value",round(mean(df_zestaw()$BMRKR1, na.rm = T),3), icon = icon("chart-bar", lib = "font-awesome"),
      color = "yellow", fill =TRUE,width = 3
    )
    
  })
  
  
  output$UI_age <- renderInfoBox({
    infoBox(
      "Mean age of patients ",round(mean(df_zestaw()$AGE, na.rm = T), 0), icon = icon("check-square", lib = "font-awesome"),
      color = "yellow", fill =TRUE,width = 3
    )
    
  })
  
  
  
  
  # Check boxes ---------------------------------------------------------------------------------------------------------------
  
  output$boxes1 <- renderUI({
    times <- input$reset_input
    
    prettyCheckboxGroup(inputId = 'checkgroup1', label = 'BMRKR2:', thick = TRUE, choices = c("MEDIUM" ,"HIGH",   "LOW"),
                        selected = c("MEDIUM" ,"HIGH" , "LOW"),animation = 'smooth', status = 'warning', shape = 'round')
    
  })
  
  
  output$boxes2 <- renderUI({
    times <- input$reset_input
    
    prettyCheckboxGroup(inputId = 'checkgroup2', label = 'LBCAT:', thick = TRUE, choices = c("CHEMISTRY",  "IMMUNOLOGY"),
                        selected = c("CHEMISTRY",  "IMMUNOLOGY"),animation = 'smooth', status = 'warning', shape = 'round')
    
  })
  
  
  output$boxes3 <- renderUI({
    times <- input$reset_input
    
    prettyCheckboxGroup(inputId = 'checkgroup3', label = 'LBTESTCD:', thick = TRUE, choices = c("ALT", "CRP", "IGA"),
                        selected = c("ALT", "CRP", "IGA"),animation = 'smooth', status = 'warning', shape = 'round')
    
  })
  
  
  
  
  # parameters ------------------------------------------------------------------------------------------------------
  
  
  output$UI_Select_x_num <- renderUI({
    
    selectInput(inputId = 'x_num1', label = "Numeric parameter:",
                choices =  colnames(df_zestaw())[unlist(lapply(df_zestaw(), is.numeric))] ,
                selected = 'BMRKR1')
  })
  
  
  
  output$UI_Select_char <- renderUI({
    
    selectInput(inputId = 'x_char2', label = "Character parameter:",
                choices =  colnames(df_zestaw())[unlist(lapply(df_zestaw(), is.character))][-c(1,2)] ,
                selected = 'BMRKR2')
  })
  
  output$UI_Select_color <- renderUI({
    
    selectInput(inputId = 'x_char3', label = "Group by parameter:",
                choices =  colnames(df_zestaw())[unlist(lapply(df_zestaw(), is.character))][-c(1,2)] ,
                selected = 'SEX')
  })
  
  
  output$slider_age <- renderUI({
    
    sliderInput("slider_age", label = "Age Range", min = min(df_zestaw()$AGE, na.rm = T), 
                max = max(df_zestaw()$AGE, na.rm = T), value = c(min(df_zestaw()$AGE, na.rm = T), max(df_zestaw()$AGE, na.rm = T)))
  })
  
  
  output$UI_Select_patient <- renderUI({
    pickerInput(
      inputId = "myPicker", 
      label = "Select/deselect all patients", 
      choices = unique(df_zestaw()$USUBJID), 
      selected = unique(df_zestaw()$USUBJID), 
      options = list(
        `actions-box` = TRUE, 
        size = 10,
        `selected-text-format` = "count > 3"
      ), 
      multiple = TRUE
    )
  })
  
  
  
  
  # wykresy ---------------------------------------------------------------------------------------------------------
  
  # data for the plots
  dt_wyk1 <- reactive({
    df_zestaw()[AGE >= input$slider_age[1] & AGE <=input$slider_age[2],]
  })
  
  dt_wyk <- reactive({
    dt_wyk1()[USUBJID %in% input$myPicker,]
  })
  
  
  
  # boxplot
  output$wykres <- renderPlotly({
    
    plt <- plot_ly(dt_wyk(),y=dt_wyk()[,get(input$x_num1)], x =dt_wyk()[,get(input$x_char2)], 
                   color =dt_wyk()[,get(input$x_char3)] , type = "box") 
    plt %>% layout(boxmode = 'group') %>% layout(xaxis = list(title = input$x_char2), 
                                                 yaxis = list(title = input$x_num1))
    
  })
  
  
  
  # scatterplot
  
  output$wykres1 <- renderPlotly({

    plot_ly(dt_wyk(),x= dt_wyk()[,get(input$x_num1)],color = dt_wyk()[,get(input$x_char3)],
            type = 'histogram') %>% layout(xaxis = list(title = input$x_num1))
    
  })
  
  
  
  # TABLE --------------------------------------------------------------------------------------------------------------
  
  output$tabledt <- DT::renderDataTable(({DT::datatable(dt_wyk(),
                                                        options = list(paging = T, searching = T, lengthChange = TRUE, bInfo=0, drop =FALSE,
                                                                       bAutoWidth = F,rownames=T, deferRender = TRUE, scrollX =T, pageLength = 20,
                                                                       columnDefs=list(list(class="dt-left")), className = 'dt-head-center', searchHighlight = TRUE)
  )}),server=FALSE)
  
  
}
