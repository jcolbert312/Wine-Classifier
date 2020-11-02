
## ur.R ##

# Input raw data set for wine chemical analysis
# UCI Machine Learning Repository: Wine Data Set
# Using chemical analysis to determine the origin of wines
wine_raw <- read.csv(file = 'wine.csv')
wine <- wine_raw

#text_summary <- readtext('wine-analysis-summary.txt')

cns <- c("Type", 'Alcohol'
         ,'Malic_acid'
         ,'Ash'
         ,'Alcalinity_of_ash'  
         ,'Magnesium'
         ,'Total_phenols'
         ,'Flavanoids'
         ,'Nonflavanoid_phenols'
         ,'Proanthocyanins'
         ,'Color_intensity'
         ,'Hue'
         ,'OD280_OD315_of_diluted_wines'
         ,'Proline'   )
colnames(wine) <- cns

wine$TypeF <- as.factor(wine$Type)

# Use a fluid Bootstrap layout
fluidPage(
          
          # Give page a title
          titlePanel("Wine Quality Analysis Using Machine Learning"),
          
          # Generate a row with a sidebar
          # sidebarLayout(
          
          
          # Define the sidebar with three inputs
          # sidebarPanel(
          
          # ),
          
          # Create a spot for the cluster plot
          mainPanel(
            
            tabsetPanel(type="tab"
                        ,tabPanel("Summary", 
                                  titlePanel("Wine Analysis Summary Report"), 
                                  
                                  mainPanel(width=12,
                                  htmlOutput('summary')
                                  )
                                  
                                )
                        
                        ,tabPanel("K Means",
                                  #tags$br(),
                                  titlePanel("K-Means Cluster Analysis"),
                                  sidebarLayout(
                                  
                                    sidebarPanel(width=4,
                                      selectInput('xcol', 'X Variable', cns, selected = cns[[2]]),
                                      selectInput('ycol', 'Y Variable', cns, selected = cns[[8]]),
                                      numericInput('clusters', 'Cluster count', 3, min = 1, max = 9)
                                    ),
                                    
                                    mainPanel(
                                     plotOutput('plot.kmeans'),
                                     uiOutput('matrix.kmeans', width=50),
                                     
                                    )
                                    
                                  )
                        )
                        
                        ,tabPanel("Naive Bayes", 
                                  #tags$br(),
                                  titlePanel("Naive Bayes Classification"),
                                  
                                  sidebarLayout(
                                    
                                    sidebarPanel(width=4,
                                      tags$h5("Select desired attributes")
                                     ,checkboxInput("Alcohol", "Alcohol", TRUE)
                                     ,checkboxInput("Malic_acid", "Malic Acid", TRUE)
                                     ,checkboxInput("Ash", "Ash", TRUE)
                                     ,checkboxInput("Alcalinity_of_ash", "Ash Alcalinity", TRUE)
                                     ,checkboxInput("Magnesium", "Magnesium", TRUE)
                                     ,checkboxInput("Total_phenols", "Total Phenols", TRUE)
                                     ,checkboxInput("Flavanoids", "Flavanoids", TRUE)
                                     ,checkboxInput("Nonflavanoid_phenols", "Nonflavanoid Phenols", TRUE)
                                     ,checkboxInput("Proanthocyanins", "Proanthocyanins", TRUE)
                                     ,checkboxInput("Color_intensity", "Color Intensity", TRUE)
                                     ,checkboxInput("Hue", "Hue", TRUE)
                                     ,checkboxInput("OD280_OD315_of_diluted_wines", "OD280-OD315-diluted wines", TRUE)
                                     ,checkboxInput("Proline", "Proline", TRUE)
                                    ),
                                    mainPanel(
                                      uiOutput('matrix.nb')
                                    )
                                  
                                  )
                                  
                         )
                                  
                        ,tabPanel("Decision Tree", titlePanel("Classification with Decision Tree"), plotOutput('plot.decisiontree'))
                        ,tabPanel("Random Forest", titlePanel("Classification with Random Forest"), uiOutput('matrix.rf'))
            )
            
          )
          
          #          )
)
