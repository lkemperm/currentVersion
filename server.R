library(miRcomp)
library(miRcompData)
library(shiny)

shinyServer(function(input, output, session) {

  makeCustom <- reactive({
      inFileCT <- input$ctElements
      if (is.null(inFileCT)) return(NULL)
      tmp <- read.csv(inFileCT$datapath, header=TRUE)
      ct <- as.matrix(tmp[,-1])
      rownames(ct) <- tmp[,1]
      colnames(ct) <- gsub(".", ":", colnames(ct), fixed=TRUE)
        
      inFileQC <- input$qcElements
      if (is.null(inFileQC)) return(NULL)
      tmp <- read.csv(inFileQC$datapath, header=TRUE)
      qc <- as.matrix(tmp[,-1])
      rownames(qc) <- tmp[,1]
      colnames(qc) <- gsub(".", ":", colnames(qc), fixed=TRUE)
      
      return(list(ct=ct, qc=qc))
    })
  
  setCustom<-reactive({
    if(input$chooseFirstMethod=="custom"||input$chooseSecondMethod=="custom"){
      custom<<-makeCustom()
    }
  })
  
  createNone<-reactive({
    if(input$chooseSecondMethod=="none"){
      none<<-NULL
    }
  })

  plotLoD<-function(){
    setCustom()
    limitOfDetection(object=get(input$chooseFirstMethod), 
                     qcThreshold=quantile(get(input$chooseFirstMethod)$qc, input$qcThresholdA, na.rm=TRUE), 
                     plotType=(input$plotTypes))
  }
  
  plotAccuracy<-function(){
    setCustom()
    createNone()
    if(!is.null(get(input$chooseSecondMethod))){
      qcThresh2 <- quantile(get(input$chooseSecondMethod)$qc, input$qcThreshold2B, na.rm=TRUE)
    } else qcThresh2 <- NULL
      accuracy(object1=get(input$chooseFirstMethod), 
               qcThreshold1=quantile(get(input$chooseFirstMethod)$qc, input$qcThresholdB, na.rm=TRUE),
               object2=get(input$chooseSecondMethod), 
               qcThreshold2=qcThresh2,
               commonFeatures=input$commonFeaturesB, label1=input$chooseFirstMethod, label2=input$chooseSecondMethod)
  }
  
  plotPrecision<-function(){
    setCustom()
    createNone()
    if(!is.null(get(input$chooseSecondMethod))){
      qcThresh2 <- quantile(get(input$chooseSecondMethod)$qc, input$qcThreshold2C, na.rm=TRUE)
    } else qcThresh2 <- NULL
      precision(object1=get(input$chooseFirstMethod),
                qcThreshold1=quantile(get(input$chooseFirstMethod)$qc, input$qcThresholdC, na.rm=TRUE),
                object2=get(input$chooseSecondMethod), 
                qcThreshold2=qcThresh2,
                commonFeatures=input$commonFeaturesC,
                statistic=input$statistic, scale=input$scale, label1=input$chooseFirstMethod, label2=input$chooseSecondMethod)
  }
  
  plotTitrationResponse<-function(){
    setCustom()
    createNone()
    if(!is.null(get(input$chooseSecondMethod))){
      qcThresh2 <- quantile(get(input$chooseSecondMethod)$qc, input$qcThreshold2E, na.rm=TRUE)
    } else qcThresh2 <- NULL
      titrationResponse(object1=get(input$chooseFirstMethod), 
                        qcThreshold1=quantile(get(input$chooseFirstMethod)$qc, input$qcThresholdE, na.rm=TRUE),
                        object2=get(input$chooseSecondMethod), 
                        qcThreshold2=qcThresh2, 
                        commonFeatures=input$commonFeaturesE)
  }
  
  plotQualityAssessment<-function(){
    setCustom()
    createNone()
      qualityAssessment(object1=get(input$chooseFirstMethod),
                        object2=get(input$chooseSecondMethod), plotType=input$qPlotType,
                        label1=input$chooseFirstMethod, label2=input$chooseSecondMethod)
  }
  
   output$LoD<-renderPlot({
     plotLoD()
   })
   
   output$A<-renderPlot({
     plotAccuracy()
   })
   
   output$P<-renderPlot({
     plotPrecision()
   })
   
   output$Qa<-renderPlot({
     plotQualityAssessment()
   })
   
   output$Tr<-renderPlot({
     plotTitrationResponse()
   })

  output$text1<-renderText({
    paste("This corresponds to a qcThreshold of:", round(quantile(get(input$chooseFirstMethod)$qc, input$qcThresholdA, na.rm=TRUE), digits=4))
  })
  
  output$text2<-renderText({
    paste("This corresponds to a qcThreshold of:", round(quantile(get(input$chooseFirstMethod)$qc, input$qcThresholdB, na.rm=TRUE), digits=4))
  })
  
  output$text3<-renderText({
    paste("This corresponds to a qcThreshold of:", round(quantile(get(input$chooseFirstMethod)$qc, input$qcThresholdC, na.rm=TRUE), digits=4))
  })
  
  output$text4<-renderText({
    paste("This corresponds to a qcThreshold of:", round(quantile(get(input$chooseFirstMethod)$qc, input$qcThresholdE, na.rm=TRUE), digits=4))
  })
  
  output$text5<-renderText({
    if(!is.null(get(input$chooseSecondMethod))){
      paste("This corresponds to a qcThreshold of:", round(quantile(get(input$chooseSecondMethod)$qc, input$qcThreshold2B, na.rm=TRUE), digits=4))
    } else paste("")
  })
  
  output$text6<-renderText({
    if(!is.null(get(input$chooseSecondMethod))){
      paste("This corresponds to a qcThreshold of:", round(quantile(get(input$chooseSecondMethod)$qc, input$qcThreshold2C, na.rm=TRUE), digits=4))
    } else paste("")
  })
  
  output$text7<-renderText({
    if(!is.null(get(input$chooseSecondMethod))){
      paste("This corresponds to a qcThreshold of:", round(quantile(get(input$chooseSecondMethod)$qc, input$qcThreshold2E, na.rm=TRUE), digits=4))
    } else paste("")
  })
  
  output$lodText<-renderText({
    paste("You are currently plotting this method:", input$chooseFirstMethod, ". To change this, select the method you would like to plot as your first method.")
  })

})
