library(shiny)
library(miRcomp)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("miRcomp"),
  
  # Sidebar with a slider input for qcThreshold
  sidebarLayout(

    sidebarPanel(
#       #Choices for first method for comparison 
#       selectInput("chooseFirstMethod", label=("Choose first method to compare:"),
#                   choices=list("qpcRDefault"="qpcRdefault", "Lifetech"="lifetech", "Custom"="custom"), selected=1),
#       
#       #Choices for next method for comparison 
#       selectInput("chooseSecondMethod", label=("Choose second method to compare:"),
#                   choices=list("None"="none", "qpcRDefault"="qpcRdefault", "Lifetech"="lifetech", "Custom"="custom"
#                                ), selected=1),
     
      selectInput("chooseFirstMethod", label=("Choose first method to compare:"),
                  choices=c(data(package="miRcomp")$results[,"Item"],"custom")),
      
      selectInput("chooseSecondMethod", label=("Choose second method to compare:"),
                  choices=c(data(package="miRcomp")$results[,"Item"],"custom","none")),
      
     conditionalPanel(condition="input.chooseSecondMethod=='custom'||input.chooseFirstMethod=='custom'",
                      
                      fileInput('qcElements', 'Upload qc elements',
                                accept=c('text/csv, values-, text/plain')),
                      fileInput('ctElements', 'Upload ct elements',
                                accept=c('text/csv, values-, text/plain'))
     )
                      ),


    mainPanel(align="center",
              
              tabsetPanel(id="tabs",
                tabPanel("Limit of Detection", value="A", plotOutput("LoD")),
                tabPanel("Accuracy", value="B", plotOutput("A")),
                tabPanel("Precision", value="C", plotOutput("P")),
                tabPanel("Quality Assessment", value="D", plotOutput("Qa")),
                tabPanel("Titration Response", value="E", plotOutput("Tr"))

              ),
              
              conditionalPanel("input.tabs=='A'",
              fluidRow(
                textOutput("lodText"),
                column(4,
                       sliderInput("qcThresholdA",
                        label="Percentage of data to exclude from method:",
                        min=0, max=1.0, value=c(0.00)),
                       textOutput("text1")
                ),
                column(4, offset = 1,
                       radioButtons("plotTypes", "Select plot type:",
                                    c("boxplot"="boxplot",
                                      "scatterplot"="scatterplot",
                                      "MAplot"="MAplot"
                                    ))  )
              )
              ),

    conditionalPanel(condition="input.tabs=='B'",
                     fluidRow(
                       column(4,
                              sliderInput("qcThresholdB",
                                          label="Percentage of data to exclude from first method:",
                                          min=0, max=1.0, value=c(0.00)),
                              textOutput("text2")
                          ),
                       column(4, offset = 1,
                              conditionalPanel(condition="input.chooseSecondMethod!='none'",
                                               sliderInput("qcThreshold2B",
                                                           label="Percentage of data to exclude from second method:",
                                                           min=0, max=1.0, value=c(0.00)),
                                               textOutput("text5")
                              )
                       ),
                       column(3,
                              radioButtons("commonFeaturesB", "Select common features preference",
                                           c("True"="TRUE", "False"="FALSE"))
                       )
                     )

                     
    ),
    conditionalPanel(condition="input.tabs=='C'",
                     fluidRow(
                       column(4,
                              sliderInput("qcThresholdC",
                                          label="Percentage of data to exclude from first method:",
                                          min=0, max=1.0, value=c(0.00)),
                               textOutput("text3")
                       ),
                       column(4, offset = 1,
                              conditionalPanel(condition="input.chooseSecondMethod!='none'",
                                               sliderInput("qcThreshold2C",
                                                           label="Percentage of data to exclude from second method:",
                                                           min=0, max=1.0, value=c(0.00)),
                                               textOutput("text6"),
                                               radioButtons("commonFeaturesC", "Select common features preference",
                                                            c("True"="TRUE", "False"="FALSE")))
                              
                       ),
                       column(3,
                              radioButtons("statistic", "Select which statistic you would like to compute:",
                                           c("standard deviation"="sd",
                                             "coefficient of variation"="cv")
                                           ),
                              br(),
                              radioButtons("scale", "Select which scale you would like to use (if any)",
                                           c("none"="none",
                                             "log"="log",
                                             "log10"="log10"))
                       )
                     )),

    
    conditionalPanel(condition="input.tabs=='D'",
                     fluidRow(
                      column(4, offset=1,
                             radioButtons("qPlotType", "Select plot type:",
                                          c("boxplot"="boxplot",
                                            "scatterplot"="scatterplot"))
                             )
                     )),
    
    conditionalPanel(condition="input.tabs=='E'",
                     
                     fluidRow(
                       column(3,
                              sliderInput("qcThresholdE",
                                          label="Percentage of data to exclude from first method:",
                                          min=0, max=1.0, value=c(0.00)),
                              textOutput("text4")
                              ),
                       
                       column(4, offset = 1,
                              conditionalPanel(condition="input.chooseSecondMethod!='none'",
                                               sliderInput("qcThreshold2E",
                                                           label="Percentage of data to exclude from second method:",
                                                           min=0, max=1.0, value=c(0.00)),
                                               textOutput("text7")
                              )
                       ),
                       column(4,
                              radioButtons("commonFeaturesE", "Select common features preference",
                                           c("True"="TRUE", "False"="FALSE"))
                       )
                     )

)))))