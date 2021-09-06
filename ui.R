dashboardPage( 
  
  # header ---------------------------------------------------------------------------------------------------------------
  dashboardHeader(title =HTML(paste(tags$a(icon('heartbeat'),tags$img(height = 50)),'   Laboratory Analysis')),  titleWidth = 300,
                  tags$li(class = "dropdown",
                          tags$a(icon('github fa-2x'), href="https://github.com/syllwia1015/7N_shiny", target="_blank",
                                 tags$img(height = 15))),
                  tags$li(class = "dropdown",
                          tags$a(icon('linkedin fa-2x'), href="https://www.linkedin.com/in/sylwia-sikoraa/", target="_blank",
                                 tags$img(height = 15)))
  ), # end dashboardHeader
  
  
  
  # Sidebar ---------------------------------------------------------------------------------------------------------------  
  dashboardSidebar(
    tags$style("left-side, main-sidebar {padding-top: 200px"),
    
    width = 300,
    br(),
    br(),
    #some stats
    uiOutput('UI_bmrkr1'),
    uiOutput('UI_age'),
    
    
    hr(),
    # filtering dataset
    tags$h4("  FILTER THE DATASET:"),
    uiOutput('boxes1'),
    uiOutput('boxes2'),
    uiOutput('boxes3'),
    uiOutput("slider_age"),
    uiOutput("UI_Select_patient"),
    br(),
    
    actionButton("reset_input", "Reset settinngs", icon = icon('redo-alt'), class="btn-primary"),
    hr(),
    
    sidebarMenu(id = "tabs",
                menuItem("Graphs", tabName = 'graph',icon = icon("bar-chart-o"), startExpanded = TRUE),
                menuItem("Table", tabName = "table1", icon = icon("table")))),
  
  
  
  # Body --------------------------------------------------------------------------------------------------------------
  dashboardBody(
    shinyDashboardThemes(theme = "grey_dark"),
    fluidPage(
      tabItems(
        tabItem(tabName = "graph", 
                width = 8,
                br(),
                column(3, uiOutput("UI_Select_x_num")),
                column(3, uiOutput("UI_Select_char")),
                column(3, uiOutput("UI_Select_color")),
                br(),
                br(),
                br(),br(),br(),br(),
                plotlyOutput('wykres'),
                plotlyOutput('wykres1')
                
        ),
        tabItem(tabName = "table1", 
                width = 8,
                br(),
                DT::dataTableOutput('tabledt')
                
        )# end tabItem
      )# end tabItems
    )# end fluidPage
  )# end dashboardBody
)# end dashboardPage
