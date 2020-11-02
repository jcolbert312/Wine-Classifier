
# Use the Wine data set from the UCI Machine Learning Repository

#library(datasets)
#library(dbplyr)
library(rpart)
library(rpart.plot)
library(e1071)
library(randomForest)
library(readr)
#library(tableHTML)
library(rsconnect)
#library(DT)
library(tidyverse)

text_summary_string <- read_file('wine-analysis-summary.txt')


#Define a server for the Shiny app
function(input, output, session) {
  
  # Combine the selected variables into a new data frame
  
  selectedData <- reactive({
    w <-  wine[, c(input$xcol, input$ycol)]
    print(head(w)) 
    w
  })
  
  
  clusters <- reactive({
    cl <-  kmeans(selectedData(), input$clusters)
  })
  
  
  output$plot.kmeans <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
    
    par(mar = c(5.1, 4.1, 0, 1))
    cl <- clusters()
    plot(selectedData(),
         col = cl$cluster,
         pch = 1+wine$Type, cex=3)
    
    points(cl$centers, pch = 4, cex = 4, lwd = 4)
    
    
  })
  
  # Summary Tab - Create summary report for wine analysis using machine learning algorithms
  output$summary <- renderText(text_summary_string)
  #  output$text1 <- renderText("<h2>K-Means Cluster Analysis</h2>")
  
  
  # K-Means Tab - Apply K-Means algorithm to perform a cluster analysis on the wine data
  output$matrix.kmeans <- renderTable({
    cl <-  kmeans(selectedData(), input$clusters)
    tt <- as.data.frame(table(actual=wine$Type, labeled=LETTERS[cl$cluster]))
    df <- data.frame(actual=tt[,1], labeled=tt[,2], number=tt[,3])
    print(df)
    df
  })
  
  
  # Decision Tree Tab - 
  output$plot.decisiontree <- renderPlot({
    dt <- rpart(TypeF~., data = wine[,-1])
    rpart.plot(dt)
    
  })
  
  # Naive Bayes
  selectedPredictors <- reactive({
    sb <- c(F,input$Alcohol,input$Malic_acid,input$Ash,input$Alcalinity_of_ash,input$Magnesium,
            input$Total_phenols,input$Flavanoids,input$Nonflavanoid_phenols,input$Proanthocyanins,
            input$Color_intensity,input$Hue,input$OD280_OD315_of_diluted_wines,input$Proline,T)
    wnb <-  wine[,sb]
    print(head(wnb)) 
    wnb
  })
  
  output$matrix.nb <- renderTable({
    
    dt <- naiveBayes(TypeF~., data = selectedPredictors())   #drop first column because it is type
    preds <- predict(dt, wine)
    print(preds)
    table(actual=wine$TypeF, predicted=preds) 
  })
  # output$Alcohol <- renderText({input$Alcohol})
  
  # Random Forest
  output$matrix.rf <- renderTable({
    
    rf <- randomForest(TypeF~., data = wine[,-1])  #drop first column because it is type
    preds <- predict(rf, wine)
    print(preds)
    table(actual=wine$TypeF, predicted=preds)
  })
}
